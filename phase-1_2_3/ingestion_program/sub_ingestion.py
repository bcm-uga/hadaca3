import argparse
import os
import numpy 
import time 
import pandas 
import importlib
import subprocess

# from scipy.optimize import nnls

from rpy2.robjects import pandas2ri
pandas2ri.activate()
# from rpy2.robjects.packages import importr

import rpy2.robjects 
readRDS = rpy2.robjects .r['readRDS']
saveRDS= rpy2.robjects .r["saveRDS"]
# import rpy2.robjects as ro


try:
    # Define the target and link name
    target = "../ingested_program/attachement/"
    link_name = "attachement/"
    
    # Create a symbolic link
    os.symlink(target, link_name)
    # print(f"Symbolic link created: {link_name} -> {target}")
except FileExistsError:
    # Handle the case where the symbolic link already exists
    os.unlink(link_name)  # Remove the existing symbolic link
    os.symlink(target, link_name)  # Recreate the


# Parsing command-line arguments
parser = argparse.ArgumentParser(description='Process some paths.')
parser.add_argument('input', type=str, help='input data directory')
parser.add_argument('output_results', type=str, help='output file')
parser.add_argument('submission_program', type=str, help='directory of the code submitted by the participants')
parser.add_argument('output_profiling_rds', type=str, help='output_profiling_rds')


args = parser.parse_args()

# Assigning the arguments to variables
input_dir = args.input.strip()
print(f"input data directory: {input_dir}")

output_results = args.output_results.strip()
print(f"output file: {output_results}")

submission_program = args.submission_program.strip()
print(f"directory of the code submitted by the participants: {submission_program}")

output_profiling_rds = args.output_profiling_rds.strip()
print(f"output_profiling file: {output_profiling_rds}")


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

          

# Reading and executing the code submitted by the participants
program_file = os.path.join(submission_program, 'program.py')

# Ensure that the file exists before attempting to read it
if os.path.isfile(program_file):
    with open(program_file, 'r') as file:
        program_code = file.read()
        exec(program_code, globals())
else:
    print(f"File not found: {program_file}")

# Example: calling the function 'program' if it's defined in the submitted code
if 'program' in globals():
    pass
else:
    print("The 'program' function is not defined in the submitted code.")


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


# Function to convert R object to pandas DataFrame or numpy array
def r_object_to_python(r_object,file,element_name):
    try:
        # Try to convert to pandas DataFrame
        return pandas2ri.rpy2py(r_object)
    except NotImplementedError:
        # If not convertible to DataFrame, we need to read row and colnames with R
        if rpy2.robjects.r['is.matrix'](r_object)[0] or rpy2.robjects.r['is.data.frame'](r_object)[0]:
            rows, columns =get_both_row_col(file,element_name)
            if(isinstance(columns, type (rpy2.robjects.NULL))):
                df = pandas.DataFrame(r_object, index=rows)
            else: 
                columns = list(columns)
                df = pandas.DataFrame(r_object, columns=columns, index=rows)

            return df
        else:
            # we should not come in this case 
            return(pandas.DataFrame(r_object))

# Function to extract named data elements and convert appropriately
def extract_data_element(data, file, element_name):
    if element_name in data.names:
        element = data.rx2(element_name)
        return r_object_to_python(element,file,element_name)
    return None



dir_name = input_dir


datasets_list = [filename for filename in os.listdir(dir_name) if filename.startswith("mixes")]

ref_file = os.path.join(dir_name, "reference_pdac.rds")
print("reading reference file")
reference_data = readRDS(ref_file)
ref_bulkRNA = extract_data_element(reference_data,ref_file, 'ref_bulkRNA') 
ref_met = extract_data_element(reference_data,ref_file, 'ref_met')
ref_scRNA = extract_data_element(reference_data,ref_file, 'ref_scRNA')


total_time = 0 

d_time = {}

 
predi_dic = {}
for dataset_name in datasets_list :

    file= os.path.join(dir_name,dataset_name)
    mixes_data = readRDS(file)

    print(f"generating prediction for dataset: {dataset_name}")

    mix_rna = extract_data_element(mixes_data,file, 'mix_rna') 
    mix_met = extract_data_element(mixes_data,file, 'mix_met')

    start_time = time.perf_counter()
    pred_prop = program(mix_rna, ref_bulkRNA, mix_met=mix_met, ref_met=ref_met   )
    prog_time = time.perf_counter() - start_time
    d_time[dataset_name] = prog_time
    total_time += prog_time
    # predi_dic[dataset_name] = rpy2.robjects.conversion.py2rpy(pred_prop)
    predi_dic[dataset_name] = pred_prop


# print(total_time)
# l_time.append(total_time)

# prediction_name = "prediction.rds"
# saveRDS(predi_list, os.path.join(output_results, prediction_name))
saveRDS(rpy2.robjects.ListVector(predi_dic), os.path.join(output_results))


# saveRDS(total_time, os.path.join(output_profiling_rds))
saveRDS(rpy2.robjects.ListVector(d_time), os.path.join(output_profiling_rds))


