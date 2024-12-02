## Authors: Alexis ARNAUD, UGA
## alexis.arnaud@univ-grenoble-alpes.fr
##
## ------------------------------------



print(x = "System information :")
print(x = Sys.info( ) )
print(x = Sys.getenv( ) )
print(x = "")


# Create symbolic link with 

try(system("ln -sf  ../ingested_program/modules/ modules", intern = TRUE, ignore.stderr = TRUE))


# source(file = "Detach_packages.R")

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
output_profiling_rds <- paste0(output, .Platform$file.sep, "Rprof.rds"         )


#Check it is a result submission or a program submission
file_R  = paste0(submission_program, .Platform$file.sep, "program.R")
file_py = paste0(submission_program, .Platform$file.sep, "program.py")
output_results <- paste0(output, .Platform$file.sep, "prediction.rds")

if (file.exists(file_R)) { 
   
  print("Executing a R program") 

  cmd = paste("Rscript", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.R"), input, output_results, submission_program, sep = " ") 
  print(cmd)
  system(command = paste("Rscript", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.R"), input, output_results, submission_program,output_profiling_rds, sep = " ") )

 }else if (file.exists(file_py)) {

  print("Executing a python program")

  cmd = paste("python", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.py"), input, output_results, submission_program, sep = " ") 
  print(cmd)
  system(command = paste("python", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.py"), input, output_results, submission_program,output_profiling_rds, sep = " ") )

 } else { 
    print("no program to execute, go straight to scoring step") 
    print(paste0(" output_profiling file:", output_profiling_rds))
    # l_time = list()
 
    # # dir_name = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep)
    # dir_name = paste0(output, .Platform$file.sep, "ref", .Platform$file.sep)
    # groundtruh_list = list.files(dir_name,pattern="groundtruth*")
    total_time = 86400 #24 h in seconds! 

    # for (groundthruth_name in groundtruh_list){
      
    #   gt_list = unlist(strsplit(groundthruth_name, "_"))
    #   methods_name =  gt_list[2]
    #   phase =  substr(gt_list[1], nchar(gt_list[1]), nchar(gt_list[1]))

    #   l_time[[methods_name]] = total_time
    # }


    saveRDS(
      object = total_time,
      file   = output_profiling_rds
    )
}



# execution_time <-  proc.time() - start_time

# print(execution_time)

# ## save profiling
# saveRDS(
#     object = execution_time
#   , file   = output_profiling_rds
# )

## stop diverting R output to a text file
## sink(file = NULL)

print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
