##################################################################################################
### PLEASE only edit the program function between YOUR CODE BEGINS/ENDS HERE                   ###
##################################################################################################


########################################################
### Package dependencies /!\ DO NOT CHANGE THIS PART ###
########################################################
import subprocess
import sys
import importlib

def program(mix=None, ref=None, **kwargs):

  ##
  ## YOUR CODE BEGINS HERE
  ##

  required_packages = ["sklearn","pandas",'scipy']
  install_and_import_packages(required_packages)
  from sklearn.linear_model import LinearRegression

  def estimate_proportions(mix_df, ref_df):
    results = []
    for i in range(len(mix_df.columns)):
        mix_col = mix_df.iloc[:, i]  # Select the i-th column as a Series
        res = LinearRegression(fit_intercept=False).fit(ref_df, mix_col).coef_
        # res, _ = scipy.optimize.nnls(ref_df.to_numpy(), mix_col.to_numpy())
        results.append(res)

    # Normalize the results to get proportions
    props = pandas.DataFrame([res_i / sum(res_i) for res_i in results], columns=ref_df.columns)
    return props.T
  

  # Creation of an index, idx_feat, corresponding to the intersection of features present in the references and those present in the mixtures.
  idx_feat = mix.index.intersection(ref.index)
  mix_filtered = mix.loc[idx_feat, :]
  ref_filtered = ref.loc[idx_feat, :]

  prop = estimate_proportions(mix_filtered, ref_filtered)
 
  # Labeling of estimated proportions 
  prop.columns = mix.columns

  return prop
  ##
  ## YOUR CODE ENDS HERE
  ##


# Install and import each package
def install_and_import_packages(required_packages):
  for package in required_packages:
      try:
          globals()[package] = importlib.import_module(package)
      except ImportError:
          print('impossible to import, installing packages',package)
          package_to_install = 'scikit-learn' if package == 'sklearn' else package
          subprocess.check_call([sys.executable, "-m", "pip", "install", package_to_install])
          globals()[package] = importlib.import_module(package)

##############################################################
### Check the prediction /!\ DO NOT CHANGE THIS PART ###
##############################################################

def validate_pred(pred, nb_samples=None, nb_cells=None, col_names=None):
    error_status = 0  # 0 means no errors, 1 means "Fatal errors" and 2 means "Warning"
    error_informations = ''

    # Ensure that all sum of cells proportion approximately equal 1
    if not numpy.allclose(numpy.sum(pred, axis=0), 1):
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

# List of required packages
required_packages = [
  "numpy",
  "pandas",
  "rpy2",
  "zipfile",
  "inspect",
]
install_and_import_packages(required_packages)

# from rpy2.robjects import pandas2ri
import os
import rpy2.robjects
readRDS = rpy2.robjects.r['readRDS']
saveRDS= rpy2.robjects.r["saveRDS"]

from rpy2.robjects import pandas2ri
pandas2ri.activate()

# TODO rewrite this 
# r_code_get_colnames_nested = '''
# get_colnames_nested <- function(reference_data) {
#     return (colnames(reference_data$ref_bulkRNA))
# }
# '''
# ro.r(r_code_get_colnames_nested)

r_code_get_colnames = '''
get_colnames <- function(ref_names="reference_fruits.rds") {
  ref_names = readRDS(ref_names)
  return (colnames(ref_names))
}
'''
rpy2.robjects.r(r_code_get_colnames)
get_colnames = rpy2.robjects.r['get_colnames']

r_code_get_rownames = '''
get_rownames <- function(ref_names="reference_fruits.rds") {
  ref_names = readRDS(ref_names)
  return (rownames(ref_names))
}
'''
rpy2.robjects.r(r_code_get_rownames)
get_rownames = rpy2.robjects.r['get_rownames']

mixes_data = readRDS(os.path.join( "mixes_smoothies_fruits.rds"))
reference_data = readRDS(os.path.join( "reference_fruits.rds"))  


file = "mixes_smoothies_fruits.rds"
mixes_data = pandas.DataFrame(mixes_data, index=get_rownames(file),columns=get_colnames(file))
file = "reference_fruits.rds"
reference_data = pandas.DataFrame(reference_data, index=get_rownames(file),columns=get_colnames(file))




nb_datasets = 4

predi_list = []
for dataset_name in range(1, nb_datasets + 1):

    dir_name = "data"+os.sep
    mixes_data = readRDS(os.path.join(dir_name, f"mixes_data_{dataset_name}.rds"))
    print(f"generating prediction for dataset: {dataset_name}")

    mix_rna= numpy.array(mixes_data.rx('mix_rna'))
    mix_rna = mix_rna[0]

    mix_met = numpy.array(mixes_data.rx('mix_met'))
    mix_met = mix_met[0]

    reference_data = readRDS(os.path.join(dir_name, "reference_pdac.rds"))

    ref_rna = numpy.array(reference_data.rx('ref_bulkRNA'))
    ref_met = numpy.array(reference_data.rx('ref_met'))
    ref_rna = ref_rna[0]
    ref_met = ref_met[0]

    get_colnames_nested = rpy2.robjects.r['get_colnames_nested']
    colnames_result = get_colnames_nested(reference_data)

    pred_prop = program(
        mix_rna=mix_rna, mix_met=mix_met,
        ref_rna=ref_rna, ref_met=ref_met
    )
    
    pred_prop_df = pandas.DataFrame(pred_prop, index=colnames_result)

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

date_suffix = pandas.Timestamp.now().strftime("%Y_%m_%d_%H_%M_%S")

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
