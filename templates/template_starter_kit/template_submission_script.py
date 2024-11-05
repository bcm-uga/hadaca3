##################################################################################################
### PLEASE only edit the program function between YOUR CODE BEGINS/ENDS HERE                   ###
##################################################################################################

### Write programs Here !


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


r_code_get_colnames = '''
get_colnames <- function(ref_names="reference_fruits.rds") {
  reference_data = readRDS(ref_names)
  return (colnames(reference_data))
}
'''
rpy2.robjects.r(r_code_get_colnames)

mixes_data = readRDS(os.path.join( "mixes_smoothies_fruits.rds"))
reference_data = readRDS(os.path.join( "reference_fruits.rds"))  


pred_prop = program(
  mix=mixes_data, ref=reference_data
)

get_colnames = rpy2.robjects.r['get_colnames']
colnames_result = get_colnames("reference_fruits.rds")
pred_prop_df = pandas.DataFrame(pred_prop, index=colnames_result)



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
      msg = f"The row names in the prediction matrix should match: {col_names}\n, they are instead: {pred.index}"
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




validate_pred(pred_prop_df, nb_samples=mixes_data.shape[1] , nb_cells=reference_data.shape[1], col_names=colnames_result)



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

saveRDS(pred_prop_df, os.path.join("submissions", prediction_name))



# Create the associated zip file:
zip_results = os.path.join("submissions", f"results_{date_suffix}.zip")
with zipfile.ZipFile(zip_results, 'w') as zipf:
  zipf.write(os.path.join("submissions", prediction_name), arcname=prediction_name)

print(zip_results)

