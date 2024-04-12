args <- commandArgs(trailingOnly = TRUE)

## index of the input file :
i                  <- trimws(x = args[1] )
print(paste0("index of the input file :", i))
## input data directory :
input              <- trimws(x = args[2] )
print(paste0("input data directory :", input))
## output file :
output_results     <- trimws(x = args[3] )
print(paste0("output file :", output_results))
## output A :
output_A           <- trimws(x = args[4] )
print(paste0(" output A :", output_A))
## output T :
output_T           <- trimws(x = args[5] )
print(paste0(" output T :", output_T))
## directory of the code submitted by the participants :
submission_program <- trimws(x = args[6] )
print(paste0(" directory of the code submitted by the participants :", submission_program))



## read code submitted by the participants :
.tempEnv <- new.env( )
source(
# file  = paste0(submission_program, .Platform$file.sep, "program.R")
    file  = paste0(submission_program, .Platform$file.sep, "program.R")
  , local = .tempEnv
)


## read input data :
test_data <- readRDS(file = paste0(input, .Platform$file.sep, "test_data.rds") )
test_data = list(test_data) #remove this if your input data is already a list!
print(paste0("length of test_data : ", length(test_data)))
print(paste0("type of test data : ", typeof(test_data)))
names(test_data)
D_matrix = test_data[[as.numeric(i)]]
#print(paste0("dim of test_data[[idx]] : ",dim(D_matrix)))
input_k_value = readRDS(file = paste0(input, .Platform$file.sep, "input_k_value.rds") )
print(paste0(" input k value = ",input_k_value))

cancer_type = readRDS(file = paste0(input, .Platform$file.sep, "cancer_type.rds") )
print(paste0(" cancer type = ",cancer_type))


## TEMP
#D_met <- D_met[1:1e2, ]
#D_matrix <- D_matrix[1:1e2, ]

base::set.seed(seed = 1)


#if (length(input_k_value) > 0) {
  #  print(paste0("use_private_k = ",input_k_value))
  #  prediction <-.tempEnv$program(D_matrix = D_matrix, k = input_k_value)
#} else {
    print(paste0("use_default_k"))
    prediction <-.tempEnv$program(D_matrix = D_matrix)
#}

print (paste0("Prediction has ", nrow(prediction$A_matrix), " rows and ", ncol(prediction$A_matrix), " columns"))

print(paste0("Save predictions from dataset ",i,  " in .rds format"))

saveRDS(
object = prediction$A_matrix
, file   = output_results
)

print(paste0("Save predicted A matrix from dataset ",i,  " in .csv format"))
write.csv2( 
  x = prediction$A_matrix,
  file = output_A)

print(paste0("Save predicted T matrix from dataset ",i,  " in .csv format"))

write.csv2( 
  x = prediction$T_matrix, 
  file = output_T)


