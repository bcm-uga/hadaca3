##################################################################################################
### PLEASE only edit the program function between YOUR CODE BEGINS/ENDS HERE                   ###
##################################################################################################

### Write programs Here !

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


r_code_get_rowandcolnames = '''
get_both <- function(ref_names = "reference_fruits.rds", mat = NULL) {
  ref_names <- readRDS(ref_names)
  if (!is.null(mat)) {
    return(list(  rownames(ref_names[[mat]]), colnames(ref_names[[mat]]) ))
  } else {
    return(list(rownames(ref_names),colnames(ref_names) ))
  }
}
'''
rpy2.robjects.r(r_code_get_rowandcolnames)
get_both_row_col = rpy2.robjects.r['get_both']


# # Function to convert R object to pandas DataFrame or numpy array
def r_object_to_python(r_object,file,element_name):
    try:
        # Try to convert to pandas DataFrame
        return pandas2ri.rpy2py(r_object)
    except NotImplementedError:
        rows, columns =get_both_row_col(file,element_name)
        if(isinstance(columns, type (rpy2.robjects.NULL))):
            df = pandas.DataFrame(r_object, index=rows)
        else: 
            columns = list(columns)
            df = pandas.DataFrame(r_object, columns=columns, index=rows)
        return df

# Function to extract named data elements and convert appropriately
def extract_data_element(data, file, element_name):
    if element_name in data.names:
        element = data.rx2(element_name)
        return r_object_to_python(element,file,element_name)
    return None


dir_name = "data"+os.sep

datasets_list = [filename for filename in os.listdir(dir_name) if filename.startswith("mixes")]

ref_file = os.path.join(dir_name, "reference_pdac.rds")
print("reading reference file")
reference_data = readRDS(ref_file)
ref_bulkRNA = extract_data_element(reference_data,ref_file, 'ref_bulkRNA') 
ref_met = extract_data_element(reference_data,ref_file, 'ref_met')
ref_scRNA = extract_data_element(reference_data,ref_file, 'ref_scRNA')

predi_dic = {}
for dataset_name in datasets_list :

    file= os.path.join(dir_name,dataset_name)
    mixes_data = readRDS(file)

    print(f"generating prediction for dataset: {dataset_name}")

    mix_rna = extract_data_element(mixes_data,file, 'mix_rna') 
    mix_met = extract_data_element(mixes_data,file, 'mix_met')

    pred_prop = program(mix_rna, ref_bulkRNA, mix_met=mix_met, ref_met=ref_met   )
    validate_pred(pred_prop, nb_samples=mix_rna.shape[1], nb_cells=ref_bulkRNA.shape[1], col_names=ref_bulkRNA.columns)
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



# # Check if the "attachment" directory exists
# if os.path.exists("attachement"):
#     # Append the contents of the "attachment" directory to the zip archive
#     with zipfile.ZipFile(zip_program, mode="a") as zf:
#         for root, _, files in os.walk("attachement"):
#             for file in files:
#                 file_path = os.path.join(root, file)
#                 # Add file to zip while preserving directory structure
#                 arcname = os.path.relpath(file_path, start="attachement")
#                 zf.write(file_path, arcname)

print(zip_program)

###############################
### Result submission mode  

# Generate a zip file with the prediction
if not os.path.exists("submissions"):
    os.makedirs("submissions")

prediction_name = "prediction.rds"

saveRDS(rpy2.robjects.ListVector(predi_dic), os.path.join("submissions", prediction_name))



# Create the associated zip file:
zip_results = os.path.join("submissions", f"results_{date_suffix}.zip")
with zipfile.ZipFile(zip_results, 'w') as zipf:
    zipf.write(os.path.join("submissions", prediction_name), arcname=prediction_name)

print(zip_results)

