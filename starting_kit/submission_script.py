import os
import subprocess
import sys
import zipfile
import numpy as np
import pandas as pd
# from scipy.optimize import nnls
import inspect 
import importlib

# import rpy2.robjects as ro
from rpy2.robjects import pandas2ri
pandas2ri.activate()
# from rpy2.robjects.packages import importr

import rpy2.robjects as ro
readRDS = ro.r['readRDS']
saveRDS= ro.r["saveRDS"]


########################################################
### Package dependencies /!\ DO NOT CHANGE THIS PART ###
########################################################

nb_datasets = 4
def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# List of required packages
required_packages = [
    "numpy",
    "pandas",
    "scipy",
    "rpy2",
    "zipfile",
    "inspect"
]

# Install each package if not already installed
for package in required_packages:
    try:
        globals()[package] = importlib.import_module(package)
    except ImportError:
        print('impossible to import, installing packages',package)
        install(package)
        globals()[package] = importlib.import_module(package)

####################################################
### Submission modes /!\ DO NOT CHANGE THIS PART ###
####################################################

###############################
### Code submission mode
# Participants need to make a zip file (no constrain on the namefile) that contains:
#   - your code inside a Python file named `program.py`. This file will be sourced and have to contain:
#   - a function `program` with `data_test` and `input_k_value` as arguments
#   - any other files that you want to access from your function `program`: during the ingestion phase (when your code is evaluated), the working directory will be inside the directory obtained by unzipping your submission.

###############################
### Result submission mode  
# Participants have to make a zip file (no constrain on the namefile), with your results as a matrix inside a pkl file named `results_1.pkl`.

##################################################################################################
### Submission modes /!\ EDIT THE FOLLOWING CODE BY COMMENTING/UNCOMMENTING THE REQUIRED PARTS ###
##################################################################################################

# Write a function to predict cell-type heterogeneity proportion matrix
# In the provided example, we use a naive method to generate the baseline prediction.

def program(mix_rna=None, mix_met=None, ref_rna=None, ref_met=None):
    """
    The function to estimate the A matrix
    
    Parameters:
    mix_rna (numpy.ndarray): the bulk matrix associated to the transcriptome data set
    mix_met (numpy.ndarray): the bulk matrix associated to the methylation data set
    ref_rna (numpy.ndarray): the reference matrix associated to the transcriptome data set
    ref_met (numpy.ndarray): the reference matrix associated to the methylation data set
    
    Returns:
    numpy.ndarray: the estimated A matrix
    """

    ##
    ## YOUR CODE BEGINS HERE
    ##

    ###### Install requiered packages if necessary
    # List of required packages
    required_packages = [
        "scipy",
    ]

    # Install each package if not already installed
    for package in required_packages:
        try:
            # __import__(package)
            globals()[package] = importlib.import_module(package)
        except ImportError:
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])
            globals()[package] = importlib.import_module(package)


    def estimate_proportions(mix, ref):
        res = [scipy.optimize.nnls(ref, mix[:, i])[0] for i in range(mix.shape[1])]
        props = np.array([res_i / sum(res_i) for res_i in res])
        return props.T

    if mix_rna is not None:
        prop_rna = estimate_proportions(mix_rna, ref_rna)
    else:
        prop_rna = None

    if mix_met is not None:
        prop_met = estimate_proportions(mix_met, ref_met)
    else:
        prop_met = None


    if prop_rna is not None and prop_met is not None:
        assert prop_rna.shape == prop_met.shape, "Dimensions of RNA and Methylation data do not match"
        prop = (prop_rna + prop_met) / 2
    elif prop_rna is not None:
        prop = prop_rna
    elif prop_met is not None:
        prop = prop_met
    else:
        raise ValueError("At least one of mix_rna or mix_met must be provided")

    if not np.allclose(np.sum(prop, axis=0), 1):
        prop = prop / np.sum(prop, axis=0)

    return prop

    ##
    ## YOUR CODE ENDS HERE
    ##


##############################################################
### Check the prediction /!\ DO NOT CHANGE THIS PART ###
##############################################################

def validate_pred(pred, nb_samples=None, nb_cells=None, col_names=None):
    error_status = 0  # 0 means no errors, 1 means "Fatal errors" and 2 means "Warning"
    error_informations = ''

    # Ensure that all sum of cells proportion approximately equal 1
    if not np.allclose(np.sum(pred, axis=0), 1):
        msg = "The prediction matrix does not respect the laws of proportions: the sum of each column should be equal to 1\n"
        error_informations += msg
        error_status = 2

    # Ensure that the prediction has the correct names
    if not set(col_names) == set(pred.index):
        msg = f"The row names in the prediction matrix should match: {col_names}\n"
        error_informations += msg
        error_status = 2

    # Ensure that the prediction returns the correct number of samples and number of cells
    if pred.shape != (nb_cells, nb_samples):
        msg = f'The prediction matrix has the dimension: {pred.shape} whereas the dimension: {(nb_cells, nb_samples)} is expected\n'
        error_informations += msg
        error_status = 1

    if error_status == 1:
        # The error is blocking and should therefore stop the execution
        raise ValueError(error_informations)
    if error_status == 2:
        print("Warning:")
        print(error_informations)


##############################################################
### Generate a prediction file /!\ DO NOT CHANGE THIS PART ###
##############################################################

r_code_get_colnames_nested = '''
get_colnames_nested <- function(reference_data) {
    return (colnames(reference_data$ref_bulkRNA))
}
'''
ro.r(r_code_get_colnames_nested)

predi_list = []
for dataset_name in range(1, nb_datasets + 1):
    dir_name = f"input_data_{dataset_name}/"
    print(f"generating prediction for dataset: {dataset_name}")

    mixes_data = readRDS(os.path.join(dir_name, "mixes_data.rds"))
    # mixes_data = pandas2ri.rpy2py(mixes_data)
    # print(type(mixes_data))
    # print((mixes_data.rx2("mix_rna"))[0].names)
    # nested_list = mixes_data.rx2("mix_rna")
    # print(nested_names = nested_list.names)

    mix_rna= np.array(mixes_data.rx('mix_rna'))
    mix_rna = mix_rna[0]
    # print(mix_rna)

    # print(type(mix_rna[0]))
    # print(pd.DataFrame({'mix_rna':mix_rna.flatten()} ))

    # mix_met = mixes_data.get('mix_met')
    mix_met = np.array(mixes_data.rx('mix_met'))
    mix_met = mix_met[0]
    # print(mix_met)

    reference_data = readRDS(os.path.join(dir_name, "reference_data.rds"))
    # reference_data = pandas2ri.rpy2py(reference_data)
    ref_rna = np.array(reference_data.rx('ref_bulkRNA'))
    ref_met = np.array(reference_data.rx('ref_met'))
    ref_rna = ref_rna[0]
    ref_met = ref_met[0]

    get_colnames_nested = ro.r['get_colnames_nested']
    colnames_result = get_colnames_nested(reference_data)

    pred_prop = program(
        mix_rna=mix_rna, mix_met=mix_met,
        ref_rna=ref_rna, ref_met=ref_met
    )
    
    pred_prop_df = pd.DataFrame(pred_prop, index=colnames_result)

    # validate_pred(pred_prop, nb_samples=mix_rna.shape[1] if mix_rna is not None else mix_met.shape[1], nb_cells=ref_rna.shape[1], col_names=reference_data['ref_met'].columns)

    predi_list.append(pred_prop_df)

############################### 
### Code submission mode

# we generate a zip file with the 'program' source code

if not os.path.exists("submissions"):
    os.makedirs("submissions")

# we save the source code as a Python file named 'program.py':
with open(os.path.join("submissions", "program.py"), 'w') as f:
    f.write(inspect.getsource(program))

date_suffix = pd.Timestamp.now().strftime("%Y_%m_%d_%H_%M_%S")

# we create the associated zip file:
zip_program = os.path.join("submissions", f"program_{date_suffix}.zip")
with zipfile.ZipFile(zip_program, 'w') as zipf:
    zipf.write(os.path.join("submissions", "program.py"), arcname="program.py")

print(zip_program)

###############################
### Result submission mode  

# Generate a zip file with the prediction
if not os.path.exists("submissions"):
    os.makedirs("submissions")

prediction_name = "prediction.rds"

saveRDS(predi_list, os.path.join("submissions", prediction_name))



# Create the associated zip file:
zip_results = os.path.join("submissions", f"results_{date_suffix}.zip")
with zipfile.ZipFile(zip_results, 'w') as zipf:
    zipf.write(os.path.join("submissions", prediction_name), arcname=prediction_name)

print(zip_results)


# <class 'rpy2.robjects.vectors.ListVector'>
