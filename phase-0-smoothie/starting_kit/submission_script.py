import os
import subprocess
import sys
import importlib

########################################################
### Package dependencies /!\ DO NOT CHANGE THIS PART ###
########################################################

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# List of required packages
required_packages = [
    "numpy",
    "pandas",
    # "scipy",  # Installed also inside the program because it not included inside the docker.
    "rpy2",
    "zipfile",
    "inspect"
]

# we could remove the installation steps, the packages should already be inside in the docker
# Install each package if not already installed
for package in required_packages:
    try:
        globals()[package] = importlib.import_module(package)
    except ImportError:
        print('impossible to import, installing packages',package)
        install(package)
        globals()[package] = importlib.import_module(package)


import zipfile
import numpy as np
import pandas as pd
# from scipy.optimize import nnls
import inspect 

# import rpy2.robjects as ro
from rpy2.robjects import pandas2ri
pandas2ri.activate()
# from rpy2.robjects.packages import importr

import rpy2.robjects as ro
readRDS = ro.r['readRDS']
saveRDS= ro.r["saveRDS"]



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

def program(mix=None, ref=None):
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

    prop = estimate_proportions(mix, ref)

    # if not np.allclose(np.sum(prop, axis=0), 1):
    #     prop = prop / np.sum(prop, axis=0)

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

r_code_get_colnames = '''
get_colnames <- function(ref_names="reference_fruits.rds") {
    reference_data = readRDS(ref_names)
    return (colnames(reference_data))
}
'''
ro.r(r_code_get_colnames)

mixes_data = readRDS(os.path.join( "mixes_smoothies_fruits.rds"))
# print(mixes_data)
# print(type(mixes_data))
# print(colnames(mixes_data))
# mixes_data= np.array(mixes_data.rx('mix_rna'))
# mixes_data = mixes_data[0]
reference_data = readRDS(os.path.join( "reference_fruits.rds"))  
# reference_data = np.array(reference_data.rx('ref_bulkRNA'))
# reference_data = reference_data[0]

pred_prop = program(
    mix=mixes_data, ref=reference_data
)

get_colnames = ro.r['get_colnames']
colnames_result = get_colnames("reference_fruits.rds")
pred_prop_df = pd.DataFrame(pred_prop, index=colnames_result)

# validate_pred(pred_prop, nb_samples=mix_rna.shape[1] if mix_rna is not None else mix_met.shape[1], nb_cells=ref_rna.shape[1], col_names=reference_data['ref_met'].columns)
    

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

saveRDS(pred_prop_df, os.path.join("submissions", prediction_name))



# Create the associated zip file:
zip_results = os.path.join("submissions", f"results_{date_suffix}.zip")
with zipfile.ZipFile(zip_results, 'w') as zipf:
    zipf.write(os.path.join("submissions", prediction_name), arcname=prediction_name)

print(zip_results)


# <class 'rpy2.robjects.vectors.ListVector'>
