

source("data_processing.R")
print(x = "System information :")
print(x = Sys.info( ) )
print(x = Sys.getenv( ) )
print(x = "")


## define ingestion_program/input/output/submission_program from command line args and remove white spaces (should in principle never be changed)
args <- commandArgs(trailingOnly = TRUE)

## directory where the ingestion program is located :
ingestion_program  <- trimws(x = args[1] )
## input data directory :
input              <- trimws(x = args[2] )
## output directory (where predictions are written) :
output             <- trimws(x = args[3] )
## directory of the code submitted by the participants :
submission_program <- trimws(x = args[4] )


print(x = "Ingestion Program :")
print(x = list.files(path = ingestion_program, all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
print(x = "Input :")
print(x = list.files(path = input , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
print(x = "Submission Program :")
print(x = list.files(path = submission_program, all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")

## output files
output_profiling_h5 <- paste0(output, .Platform$file.sep, "Rprof.h5")


#Check it is a result submission or a program submission
file_R  = paste0(submission_program, .Platform$file.sep, "program.R")
file_py = paste0(submission_program, .Platform$file.sep, "program.py")
output_results <- paste0(output, .Platform$file.sep, "prediction.h5")

if (file.exists(file_R)) { 
   
  print("Executing a R program") 
  cmd = paste("Rscript", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.R"), input, output_results, submission_program, sep = " ") 
  print(cmd)
  system(command = paste("Rscript", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.R"), input, output_results, submission_program,output_profiling_h5, sep = " ") )

 }else if (file.exists(file_py)) {

  print("Executing a python program")

  cmd = paste("python", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.py"), input, output_results, submission_program, sep = " ") 
  print(cmd)
  system(command = paste("python", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.py"), input, output_results, submission_program,output_profiling_h5, sep = " ") )

 } else { 
    print("no program to execute, go straight to scoring step") 
    print(paste0(" output_profiling file:", output_profiling_h5))
    l_time = list()

    dir_name = paste0(input,.Platform$file.sep)
    dataset_list = list.files(dir_name,pattern="mixes*")
    total_time = 86400 #24 h in seconds! 

    for (dataset_name in dataset_list){

      cleaned_dataset_name <- sub("\\.h5$", "", unlist(strsplit(dataset_name, "_"))[2])

      l_time[[cleaned_dataset_name]] = total_time
    }

    write_hdf5(output_profiling_h5,l_time)
}


print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
