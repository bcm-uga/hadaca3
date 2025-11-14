import argparse
import os
import numpy 
import time 
import pandas 
import importlib
import subprocess
import data_processing as dp


# try:
#     # Define the target and link name
#     target = "../ingested_program/attachement/"
#     link_name = "attachement"
    
#     os.symlink(target, link_name)
# except FileExistsError:
#     # Handle the case where the symbolic link already exists
#     os.unlink(link_name)  # Remove the existing symbolic link
#     os.symlink(target, link_name)  # Recreate the


# Parsing command-line arguments
parser = argparse.ArgumentParser(description='Process some paths.')
parser.add_argument('input', type=str, help='input data directory')
parser.add_argument('output_results', type=str, help='output file')
parser.add_argument('submission_program', type=str, help='directory of the code submitted by the participants')
parser.add_argument('output_profiling_h5', type=str, help='output_profiling_h5')


args = parser.parse_args()

# Assigning the arguments to variables
input_dir = args.input.strip()
print(f"input data directory: {input_dir}")

output_results = args.output_results.strip()
print(f"output file: {output_results}")

submission_program = args.submission_program.strip()
print(f"directory of the code submitted by the participants: {submission_program}")

output_profiling_h5 = args.output_profiling_h5.strip()
print(f"output_profiling file: {output_profiling_h5}")


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




dir_name = input_dir


datasets_list = [filename for filename in os.listdir(dir_name) if filename.startswith("mixes")]

# ref_file = os.path.join(dir_name, "reference_pdac.rds")
ref_file = os.path.join(dir_name, "reference_pdac.h5")


print("reading reference file")
reference_data = dp.read_hdf5(ref_file)


total_time = 0 

d_time = {}

 
predi_dic = {}
for dataset_name in datasets_list :

    file= os.path.join(dir_name,dataset_name)
    mixes_data = dp.read_hdf5(file)

    print(f"generating prediction for dataset: {dataset_name}")

    start_time = time.perf_counter()
    # pred_prop = program(mix_rna, ref_bulkRNA, mix_met=mix_met, ref_met=ref_met   )
    pred_prop = program(mixes_data["mix_rna"], reference_data["ref_bulkRNA"], mix_met=mixes_data["mix_met"], ref_met=reference_data["ref_met"]   )

    prog_time = time.perf_counter() - start_time

    cleaned_name=dataset_name.replace("mixes_", "").removesuffix(".h5")
    d_time[cleaned_name] = prog_time
    total_time += prog_time
    predi_dic[cleaned_name] = pred_prop


dp.write_hdf5(os.path.join(output_results),predi_dic)
dp.write_hdf5(os.path.join(output_profiling_h5),d_time)

