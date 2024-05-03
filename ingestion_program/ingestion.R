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
output_program       <- paste0(output, .Platform$file.sep, "output_program.txt")
output_profiling     <- paste0(output, .Platform$file.sep, "Rprof.out"         )
output_profiling_rds <- paste0(output, .Platform$file.sep, "Rprof.rds"         )
#output_dataType      <- paste0(output, .Platform$file.sep, "dataType.rds"      )
file.create(output_program, output_profiling)

## diverting R output to a text file :
## sink(file = output_program, append = FALSE)

Rprof(
    filename         = output_profiling
  , append           = FALSE
  , interval         = 0.9
  , memory.profiling = TRUE
  , gc.profiling     = FALSE
  , line.profiling   = FALSE
)

#Check it is a result submission or a progran submission
file  = paste0(submission_program, .Platform$file.sep, "program.R")
print(file)

if (file.exists(file)) { 
   
  print("execution of the program") 
  
  #Define the number of dataset
  test_data <- readRDS(file = paste0(input, .Platform$file.sep, "public_data_rna.rds") )
  test_data = list(test_data) #remove this if your input data is already a list!
  nb_dataset = length(test_data)
  print(x = paste0("Number of test dataset is :", nb_dataset) )

  for ( i in seq_len(length.out = nb_dataset) ) {
      print(x = paste0("Test : ", i) )
      output_results <- paste0(output, .Platform$file.sep, "results_", i, ".rds")
      output_A <- paste0(output, .Platform$file.sep, "results_A_", i, ".csv")
      output_T <- paste0(output, .Platform$file.sep, "results_T_", i, ".csv")
      print(x = "")
    
      system(command = paste("Rscript", paste0(ingestion_program, .Platform$file.sep, "sub_ingestion.R"), i, input, output_results,  output_A,  output_T, submission_program, sep = " ") )
  
  }
  remove(list = "i")
} else { 
    print("no program to execute, go straight to scoring step") 
}

Rprof(filename = NULL)
profiling <- summaryRprof(filename = output_profiling, memory = "both")

## save profiling
saveRDS(
    object = profiling
  , file   = output_profiling_rds
)

## stop diverting R output to a text file
## sink(file = NULL)

print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
