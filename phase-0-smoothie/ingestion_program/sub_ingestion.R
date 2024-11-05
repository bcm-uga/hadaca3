args <- commandArgs(trailingOnly = TRUE)


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

total_time <- 0

mixes_data = readRDS( paste0(input,.Platform$file.sep,"mixes_smoothies_fruits.rds") )
reference_data = readRDS( paste0(input,.Platform$file.sep,"reference_fruits.rds"))


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

# we use the previously defined function 'program' to estimate A :
start_time <- proc.time()
pred_prop <- .tempEnv$program(
  mix = mixes_data,
  ref = reference_data
)
elapsed_time <- proc.time() - start_time
print (paste0("Prediction has ", nrow(pred_prop), " rows and ", ncol(pred_prop), " columns"))


total_time <- total_time + elapsed_time["elapsed"]


print(total_time)
## save profiling
saveRDS(
    object = total_time
  , file   = output_profiling_rds
)


print(paste0("Save predictions in .rds format"))
saveRDS(
object = pred_prop
, file   = output_results
)
