args <- commandArgs(trailingOnly = TRUE)



try(system("ln -sf  ../ingested_program/attachement/ attachement", intern = TRUE, ignore.stderr = TRUE))

## index of the input file :
# i                  <- trimws(x = args[1] )
# print(paste0("index of the input file :", i))
## input data directory :
input              <- trimws(x = args[1] )
print(paste0("input data directory :", input))
## output file :
output_results     <- trimws(x = args[2] )
print(paste0("output file :", output_results))
## directory of the code submitted by the participants :
submission_program <- trimws(x = args[3] )
print(paste0(" directory of the code submitted by the participants :", submission_program))
## directory of the code submitted by the participants :
output_profiling_rds <- trimws(x = args[4] )
print(paste0(" output_profiling file:", output_profiling_rds))


## read code submitted by the participants :
.tempEnv <- new.env( )
source(
# file  = paste0(submission_program, .Platform$file.sep, "program.R")
    file  = paste0(submission_program, .Platform$file.sep, "program.R")
  , local = .tempEnv
)


####################################
## read input data :
#####################################

base::set.seed(seed = 1)


l_time = list()
predi_list = list()



install.packages = function (pkgs, repos="https://cloud.r-project.org", ...) {
  installed_packages <- installed.packages( )
  for (package in pkgs ) {
    if ( !{ package %in% installed_packages } ) {
     print(x = paste("Installation of ", package, sep = "") )
      utils::install.packages(
        pkgs = package,
        repos = repos,
        ...
      )
    } else {
      print(x = paste(package, " is installed.", sep = "") )
    }
  }
}



dir_name = paste0(input,.Platform$file.sep)
dataset_list = list.files(dir_name,pattern="mixes*")
reference_data <- readRDS(file =  paste0(dir_name, "reference_pdac.rds"))
# names(reference_data)

for (dataset_name in dataset_list){
  print(paste0("generating prediction for dataset:",toString(dataset_name) ))


  mixes_data <- readRDS(file = paste0(dir_name,dataset_name))
  names(mixes_data)
  # mix_rna <- mixes_data$mix_rna
  # mix_met <- mixes_data$mix_met


  # ref_rna <- as.matrix(reference_data$ref_bulkRNA)
  # # ref_sc_rna <- as.matrix(reference_data$ref_scRNA)
  # ref_met <- as.matrix(reference_data$ref_met)

  if ("mix_rna" %in% names(mixes_data)) {
    mix_rna = mixes_data$mix_rna
  } else {
    mix_rna = mixes_data
  }
  if ("mix_met" %in% names(mixes_data)) {
    mix_met = mixes_data$mix_met  
  } else {
    mix_met = NULL
  }

  if ("ref_bulkRNA" %in% names(reference_data)) {
    ref_bulkRNA = reference_data$ref_bulkRNA
  } else {
    ref_bulkRNA = reference_data
  }
  if ("ref_met" %in% names(reference_data)) {
    ref_met = reference_data$ref_met  
  } else {
    ref_met = NULL
  }
  if ("ref_scRNA" %in% names(reference_data)) {
    ref_scRNA = reference_data$ref_scRNA  
  } else {
    ref_scRNA = NULL
  }


  # we use the previously defined function 'program' to estimate A :
  start_time <- proc.time()
  pred_prop <- .tempEnv$program(mix_rna, ref_bulkRNA, mix_met=mix_met, ref_met=ref_met, ref_scRNA=ref_scRNA)


  elapsed_time <- proc.time() - start_time
  print (paste0("Prediction has ", nrow(pred_prop), " rows and ", ncol(pred_prop), " columns"))

  l_time[[dataset_name]] = as.numeric(elapsed_time["elapsed"])

  predi_list[[dataset_name]] = pred_prop

}

saveRDS(
    object = l_time
  , file   = output_profiling_rds
)


print(paste0("Save predictions in .rds format"))
saveRDS(
object = predi_list
, file   = output_results
)

# print(paste0("Save predicted A matrix from dataset ",i,  " in .csv format"))
# write.csv2( 
#   x = prediction$A_matrix,
#   file = output_A)

# print(paste0("Save predicted T matrix from dataset ",i,  " in .csv format"))

# write.csv2( 
#   x = prediction$T_matrix, 
#   file = output_T)


