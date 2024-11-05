import argparse
import os
import numpy 
import time 
import pandas
import importlib
import subprocess

from rpy2.robjects import pandas2ri
pandas2ri.activate()


# import rpy2.robjects as robjects
import rpy2.robjects
readRDS = rpy2.robjects.r['readRDS']
saveRDS= rpy2.robjects.r["saveRDS"]

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
if 'program' not in globals():
    print("The 'program' function is not defined in the submitted code.")


r_code_get_colnames = '''
get_colnames <- function(ref_names="reference_fruits.rds") {
    reference_data = readRDS(ref_names)
    return (colnames(reference_data))
}
'''
rpy2.robjects.r(r_code_get_colnames)

mixes_data = readRDS(os.path.join(input_dir,"mixes_smoothies_fruits.rds"))

reference_data = readRDS(os.path.join(input_dir,"reference_fruits.rds"))  


# total_time = 0 
start_time = time.perf_counter()

pred_prop = program(
    mix=mixes_data, ref=reference_data
)
total_time = time.perf_counter() - start_time

get_colnames = rpy2.robjects.r['get_colnames']
colnames_result = get_colnames(os.path.join(input_dir,"reference_fruits.rds"))
pred_prop_df = pandas.DataFrame(pred_prop, index=colnames_result)



print(total_time)

# prediction_name = "prediction.rds"
# saveRDS(predi_list, os.path.join(output_results, prediction_name))
saveRDS(pred_prop_df, os.path.join(output_results))


saveRDS(total_time, os.path.join(output_profiling_rds))


