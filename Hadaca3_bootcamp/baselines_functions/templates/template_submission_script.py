##################################################################################################
### PLEASE only edit the program function between YOUR CODE BEGINS/ENDS HERE                   ###
##################################################################################################

### Write programs Here !




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
  "zipfile",
  "inspect",
]
install_and_import_packages(required_packages)

import os
import attachement.data_processing as dp


dir_name = "data"+os.sep

datasets_list = [filename for filename in os.listdir(dir_name) if filename.startswith("mixes")]

ref_file = os.path.join(dir_name, "reference_pdac.h5")
reference_data = dp.read_hdf5(ref_file)


predi_dic = {}
for dataset_name in datasets_list :

    file= os.path.join(dir_name,dataset_name)
    mixes_data = dp.read_hdf5(file)

    print(f"generating prediction for dataset: {dataset_name}")

    # mix_rna = extract_data_element(mixes_data,file, 'mix_rna') 
    # mix_met = extract_data_element(mixes_data,file, 'mix_met')

    pred_prop = program(mixes_data["mix_rna"], reference_data["ref_bulkRNA"], mix_met=mixes_data["mix_met"], ref_met=reference_data["ref_met"]   )
    # validate_pred(pred_prop, nb_samples=mix_rna.shape[1], nb_cells=ref_bulkRNA.shape[1], col_names=ref_bulkRNA.columns)
    predi_dic[dataset_name] = pred_prop

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


def zipdir(path, ziph):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file), 
                       os.path.relpath(os.path.join(root, file), 
                                       os.path.join(path, '..')))
if os.path.exists("attachement"):
    with zipfile.ZipFile(zip_program, 'a', zipfile.ZIP_DEFLATED) as zipf:
        zipdir('attachement/', zipf)


print(zip_program)

###############################


# Generate a zip file with the prediction
if not os.path.exists("submissions"):
    os.makedirs("submissions")

prediction_name = "prediction.h5"

dp.write_global_hdf5(os.path.join("submissions", prediction_name),predi_dic)



# Create the associated zip file:
zip_results = os.path.join("submissions", f"results_{date_suffix}.zip")
with zipfile.ZipFile(zip_results, 'w') as zipf:
    zipf.write(os.path.join("submissions", prediction_name), arcname=prediction_name)

print(zip_results)

