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
# output_program       <- paste0(output, .Platform$file.sep, "output_program.txt")
# output_profiling     <- paste0(output, .Platform$file.sep, "Rprof.out"         )
output_profiling_rds <- paste0(output, .Platform$file.sep, "Rprof.rds"         )
#output_dataType      <- paste0(output, .Platform$file.sep, "dataType.rds"      )
# file.create(output_program, output_profiling)

## diverting R output to a text file :
## sink(file = output_program, append = FALSE)


# Rprof(
#     filename         = output_profiling
#   , append           = FALSE
#   , interval         = 0.02
#   , memory.profiling = TRUE
#   , gc.profiling     = FALSE
#   , line.profiling   = FALSE
# )
# start_time <- proc.time()


# Rprof(output_profiling,interval = 0.02)


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
