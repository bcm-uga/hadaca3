import argparse
import os
import numpy as np 
import time 
import pandas as pd
import importlib
import subprocess

# from scipy.optimize import nnls

from rpy2.robjects import pandas2ri
pandas2ri.activate()
# from rpy2.robjects.packages import importr

import rpy2.robjects as robjects
readRDS = robjects.r['readRDS']
saveRDS= robjects.r["saveRDS"]
import rpy2.robjects as ro

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
    # print('progris in memory')
    # Call the function with example arguments (these should be defined appropriately)
    # result = program(arg1, arg2, ...)  # Pass actual arguments required by the function
    pass
else:
    print("The 'program' function is not defined in the submitted code.")



# r_code_get_colnames_nested = '''
# get_colnames_nested <- function(reference_data) {
#     return (colnames(reference_data$ref_bulkRNA))
# }
# '''
# ro.r(r_code_get_colnames_nested)




# # This should be place elsewhere. 
# nb_datasets = 4

# predi_list = []
# total_time = 0 


# for dataset_name in range(1, nb_datasets + 1):
#     # dir_name = f"input_data_{dataset_name}/"
#     # dir_name = dir_name = paste0(input,.Platform$file.sep,"input_data_",toString( dataset_name),.Platform$file.sep)
#     dir_name = os.path.join(input_dir, f"input_data_{dataset_name}")
#     print(f"generating prediction for dataset: {dataset_name}")
    

#     mixes_data = readRDS(os.path.join(dir_name, "mixes_data.rds"))

#     mix_rna= np.array(mixes_data.rx('mix_rna'))
#     mix_rna = mix_rna[0]
#     mix_met = np.array(mixes_data.rx('mix_met'))
#     mix_met = mix_met[0]

#     reference_data = readRDS(os.path.join(dir_name, "reference_data.rds"))
#     # reference_data = pandas2ri.rpy2py(reference_data)
#     ref_rna = np.array(reference_data.rx('ref_bulkRNA'))
#     ref_met = np.array(reference_data.rx('ref_met'))
#     ref_rna = ref_rna[0]
#     ref_met = ref_met[0]

#     get_colnames_nested = ro.r['get_colnames_nested']
#     colnames_result = get_colnames_nested(reference_data)

#     #Program is in memory 
#     start_time = time.perf_counter()
#     pred_prop = program(
#         mix_rna=mix_rna, mix_met=mix_met,
#         ref_rna=ref_rna, ref_met=ref_met
#     )
#     total_time += time.perf_counter() - start_time
    
#     pred_prop_df = pd.DataFrame(pred_prop, index=colnames_result)

#     # validate_pred(pred_prop, nb_samples=mix_rna.shape[1] if mix_rna is not None else mix_met.shape[1], nb_cells=ref_rna.shape[1], col_names=reference_data['ref_met'].columns)

#     predi_list.append(pred_prop_df)

r_code_get_colnames = '''
get_colnames <- function(ref_names="reference_fruits.rds") {
    reference_data = readRDS(ref_names)
    return (colnames(reference_data))
}
'''
ro.r(r_code_get_colnames)

mixes_data = readRDS(os.path.join(input_dir,"mixes_smoothies_fruits.rds"))
# print(mixes_data)
# print(type(mixes_data))
# print(colnames(mixes_data))
# mixes_data= np.array(mixes_data.rx('mix_rna'))
# mixes_data = mixes_data[0]
reference_data = readRDS(os.path.join(input_dir,"reference_fruits.rds"))  
# reference_data = np.array(reference_data.rx('ref_bulkRNA'))
# reference_data = reference_data[0]

# total_time = 0 
start_time = time.perf_counter()

pred_prop = program(
    mix=mixes_data, ref=reference_data
)
total_time = time.perf_counter() - start_time

get_colnames = ro.r['get_colnames']
colnames_result = get_colnames(os.path.join(input_dir,"reference_fruits.rds"))
pred_prop_df = pd.DataFrame(pred_prop, index=colnames_result)



print(total_time)

# prediction_name = "prediction.rds"
# saveRDS(predi_list, os.path.join(output_results, prediction_name))
saveRDS(pred_prop_df, os.path.join(output_results))


saveRDS(total_time, os.path.join(output_profiling_rds))


