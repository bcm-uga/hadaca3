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

nb_datasets = 4

####################################
## read input data :
#####################################



# mixes_data <- readRDS(file = paste0(input, .Platform$file.sep, "mixes_data.rds") )

# mix_rna <- mixes_data$mix_rna
# mix_met <- mixes_data$mix_met
# names(mixes_data)

# reference_data <- readRDS(file = paste0(input, .Platform$file.sep, "reference_data.rds")  )
# ref_rna <- as.matrix(reference_data$ref_bulkRNA)
# ref_met <- as.matrix(reference_data$ref_met)
# names(reference_data)



base::set.seed(seed = 1)

total_time <- 0


predi_list = list()
for (dataset_name in 1:nb_datasets){
  # dir_name = dir_name = paste0(input,.Platform$file.sep,"input_data", .Platform$file.sep,"input_data_",toString( dataset_name),.Platform$file.sep)
  dir_name = dir_name = paste0(input,.Platform$file.sep,"input_data_",toString( dataset_name),.Platform$file.sep)
  print(paste0("generating prediction for dataset:",toString(dataset_name) ))



  mixes_data <- readRDS(file = paste0(dir_name, "mixes_data.rds"))
  mix_rna <- mixes_data$mix_rna
  mix_met <- mixes_data$mix_met
  names(mixes_data)

  reference_data <- readRDS(file =  paste0(dir_name, "reference_data.rds"))
  ref_rna <- as.matrix(reference_data$ref_bulkRNA)
  # ref_sc_rna <- as.matrix(reference_data$ref_scRNA)
  ref_met <- as.matrix(reference_data$ref_met)
  names(reference_data)

  # we use the previously defined function 'program' to estimate A :
  start_time <- proc.time()
  pred_prop <- .tempEnv$program(
    mix_rna = mix_rna, mix_met = mix_met,
    ref_rna = ref_rna, ref_met = ref_met
  )
  elapsed_time <- proc.time() - start_time
  print (paste0("Prediction has ", nrow(pred_prop), " rows and ", ncol(pred_prop), " columns"))


  total_time <- total_time + elapsed_time["elapsed"]

  predi_list[[dataset_name]] = pred_prop

}

# prediction <-.tempEnv$program(  
# mix_rna = mix_rna, mix_met = mix_met,
# ref_rna = ref_rna, ref_met = ref_met)




print(total_time)
## save profiling
saveRDS(
    object = total_time
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


