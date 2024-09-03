## Authors: Alexis ARNAUD, Magali RICHARD, UGA
## alexis.arnaud@univ-grenoble-alpes.fr
## magali.richard@univ-grenoble-alpes.fr
##---------------------------------------------

nb_datasets = 4

for ( package in c( "combinat", "rmarkdown", "clue", "infotheo") ) {
    if ( !{ package %in% installed.packages( ) } ) {
        install.packages(pkgs = package, repos = "https://cloud.r-project.org")
    }
}
remove(list = "package")

##############################################
### SCORING
#########################
# Align cell types to find the best match between real and estimated A matrices

homogeneized_cor_mat = function(A_real, A_pred) {

  if (any(apply(A_pred, 1, sd) == 0)) {
    A_pred[which(apply(A_pred, 1, sd) == 0),] = abs(jitter(A_pred[which(apply(A_pred, 1, sd) == 0),], factor = 0.01))
    
    A_pred = sapply(1:ncol(A_pred), 
                   function(col_i) { A_pred[,col_i] / sum(A_pred[,col_i]) }) # Sum To One 
  }
  
  cmat = cor(t(A_real),t(A_pred))
  pvec <- c(clue::solve_LSAP((1+cmat)^2,maximum = TRUE))
  return(A_pred[pvec,])
}

#########################
# Correct A_pred if we predicted too few/many cell types and align the latter

prepare_A <- function(A_real, A_pred) {
  N <- ncol(A_real)
  K <- nrow(A_real)
    
  stopifnot(K > 1)
  stopifnot(ncol(A_pred) == N)
  stopifnot(!anyNA(A_pred))
    
  # STEP 1 : matching the number of estimated components to the real number of cell types K
    
  ## if estimating too few cell types
  if (nrow(A_pred) < K) {
    #set random positive values closed to 0 for missing rows
    set.seed(1)
    random_data = abs(jitter(matrix(data = 0, nrow = K - nrow(A_pred), ncol = N), factor = 0.01))
    A_pred <- rbind(A_pred, random_data)
    print("Add rows of 0s to match K")
  }
           
  ## if estimating too many cell types
  
  ### strategy 1: keep the most abundant cell types
  if (nrow(A_pred) > K) {
    A_pred <- A_pred[order(rowSums(A_pred), decreasing = TRUE)[1:K],]
    print("Number of estimated cell types exceeds K, only the K most abundant cell types are kept for scoring.")
  }
  
  ### strategy 2: clustering of similar cell types to match K components -> SLIM
        
  # STEP 2 : align estimated components to find the best match -> SLIM
  A_pred_best_cor = as.matrix(homogeneized_cor_mat(A_real, A_pred))
  
  return(A_pred_best_cor)
}

#########################
# Computation of Pearson correlation on rows, columns and whole matrix

pearson_cor <-  function(real, prediction) {
  return(cor(c(as.matrix(real)), c(prediction), method="pearson"))
}

eval_pearson = function(A_real, A_pred) {
  cor_matrix = pearson_cor(real=A_real, prediction=A_pred)
  cor_row = sapply(seq(nrow(A_pred)), function(i)
    pearson_cor(real=A_real[i, ], prediction=A_pred[i, ]))
  cor_col = sapply(seq(ncol(A_pred)), function(i)
    pearson_cor(real=A_real[, i], prediction=A_pred[, i]))
  return(structure(c(cor_matrix, mean(cor_row, na.rm=T), mean(cor_col, na.rm=T)),
                   names=c("cor_matrix", "cor_row", "cor_col")))
}

eval_pearson_per_samples = function(A_real, A_pred) {
  cor_col = sapply(seq(ncol(A_pred)), function(i)
    pearson_cor(real=A_real[, i], prediction=A_pred[, i]))
  return(cor_col)
}

#########################
# Computation of RMSE

eval_RMSE = function(A_real, A_pred) {
  return(sqrt(mean((A_real - A_pred)^2)))
}

eval_RMSE_per_samples = function(A_real, A_pred) {
  return(sqrt(colMeans((A_real - A_pred)^2)))
}

#########################
# Computation of Mean Absolute Error

eval_MAE = function(A_real, A_pred){
  return(mean(abs(A_real - A_pred)))
}

eval_MAE_per_samples = function(A_real, A_pred){
  return(colMeans(abs(A_real - A_pred)))
}

#########################
# Scoring function 

baseline_scoring_function <- function(A_real, A_pred, time) {
  
  # pre-treatment of estimated A
  A_pred_tt = prepare_A(A_real = A_real, A_pred = A_pred)
  
  # scoring
  rmse = eval_RMSE(A_real=A_real, A_pred=A_pred_tt)
  mae = eval_MAE(A_real=A_real, A_pred=A_pred_tt)
  pearson = eval_pearson(A_real=A_real, A_pred=A_pred_tt)

  baseline_estimation = data.frame("rmse"=rmse,
                                   "mae"=mae,
                                   "pearson_mat"=pearson["cor_matrix"],
                                   "pearson_row"=pearson["cor_row"],
                                   "pearson_col"=pearson["cor_col"],
                                   "time"=time)
  
  # scoring per samples
  rmse = eval_RMSE_per_samples(A_real=A_real, A_pred=A_pred_tt)
  mae = eval_MAE_per_samples(A_real=A_real, A_pred=A_pred_tt)
  pearson = eval_pearson_per_samples(A_real=A_real, A_pred=A_pred_tt)
  
  return(list(baseline_estimation = baseline_estimation,
              rmse_samples = rmse,
              mae_samples = mae,
              pearson_samples = pearson))
}
   
##############################################
### SESSION

## define input/output from command line args and remove white spaces (should in principle never be changed)
args <- commandArgs(trailingOnly = TRUE)

## input data directory :
input   <- trimws(x = args[ 1 ] )
## output directory (where predictions are written) :
output  <- trimws(x = args[ 2 ] )
## scoring program directory :
program <- trimws(x = args[ 3 ] )

print(x = "Input :")
print(x = list.files(path = input , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
print(x = "Program :")
print(x = list.files(path = program, all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")

###  EVALUATION
output_file <- paste0(output, .Platform$file.sep, "scores.txt")

# if(!file.exists(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "test_solution.rds"))){
#     print("no solution file, scoring is not executed")
#     print("Scores : empty file")
#     cat(paste0("Accuracy_mean: NA", "\n"), file = output_file, append = FALSE)
#     cat(paste0("Accuracy_sd: NA", "\n"), file = output_file, append = TRUE )
#     cat(paste0("Time: NA", "\n"), file = output_file, append = TRUE )
# } else {
    print("execution of the info_mut scoring program")
    




## load submited results from participant program :
# Aest <- lapply(
#     X   = seq_len(length.out = nb_dataset )
#   , FUN = function( i ) {
#       readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "results_", i, ".rds") )
#   }
# )






##############################################


validate_pred <- function(pred, nb_samples , nb_cells , col_names ){

  error_status = 0   # 0 means no errors, 1 means "Fatal errors" and 2 means "Warning"
  error_informations = ''

  ## Ensure that all sum ofcells proportion approximately equal 1
  if (!all(sapply(colSums(pred), function(x) isTRUE(all.equal(x, 1) )))) {
    msg = "The prediction matrix does not respect the laws of proportions: the sum of each columns should be equal to 1\n"
    error_informations = paste(error_informations,msg)
    error_status = 2
  }

  ##Ensure that the prediction have the correct names ! 
  if(! setequal(rownames(pred),col_names) ){
    msg = paste0(    "The row names in the prediction matrix should match: ", toString(col_names),"\n")
    error_informations = paste(error_informations,msg)
    error_status = 2
  }

  ## Ensure that the prediction return the correct number of samples and  number of cells. 
  if (nrow(pred) != nb_cells  | ncol(pred) != nb_samples)  {
    msg= paste0('The prediction matrix has the dimension: ',toString(dim(pred))," whereas the dimension: ",toString(c(nb_cells,nb_samples))," is expected\n"   )
    error_informations = paste(error_informations,msg)
    error_status = 1
  }

  if(error_status == 1){
    # The error is blocking and should therefor stop the execution. 
    stop(error_informations)
  }
  if(error_status == 2){
    print("Warning: ")
    warning(error_informations)
  }  
}



## load R profiling of the estimation of A :
profiling <- readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "Rprof.rds") )


##Ensure some properties of the Prediction are ok. 
Aest_l  = readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "prediction.rds") )

l_res = list()
for (dataset_name in 1:nb_datasets){

  Aest = as.matrix(Aest_l[[dataset_name]])

  ## Load ground_thuth data
  Atruth =  readRDS(file = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep, "ground_truth_",toString(dataset_name),".rds") )
  Atruth = as.matrix(Atruth)
  validate_pred( Aest,nb_samples = ncol(Atruth), nb_cells=nrow(Atruth) , col_names=rownames(Atruth) )

  timing=profiling[[dataset_name]]

  # baseline_scores = baseline_scoring_function(A_real=Atruth, A_pred=Aest, time=as.numeric(timing))
  baseline_scores = baseline_scoring_function(A_real=Atruth, A_pred=Aest, time=timing)
  # rownames(baseline_scores$baseline_estimation) = baseline

  saveRDS(baseline_scores, paste0(output,"/scores_",toString(dataset_name),".rds"))

  stopifnot(exprs = all( !is.na(x = baseline_scores) ) )
  # print(x = paste0("Scores dataset ",toString(dataset_name), ": ", paste(baseline_scores, collapse = ", ") ) )

  score_mean = mean(x = as.numeric(baseline_scores$baseline_estimation[, -ncol(baseline_scores$baseline_estimation)]) )
  cat(paste0("Accuracy_mean_",toString(dataset_name), ": " , score_mean, "\n"), file = output_file, append = TRUE)

  l_res[[dataset_name]] = score_mean

  print(x = list.files(path = output, all.files = TRUE, full.names = TRUE, recursive = TRUE) )

}

cat(paste0("median_performance : " , median(unlist(l_res)), "\n"), file = output_file, append = TRUE)

cat(paste0("Time: ", sum(unlist(profiling)), "\n"), file = output_file, append = TRUE )
print( paste0("Time: ", toString(unlist(profiling)), " ", sum(unlist(profiling)), "\n") )

rmarkdown::render(
  input       = paste0(program, .Platform$file.sep, "detailed_results.Rmd")
  , envir       = parent.frame( )
  , output_dir  = output
  # , output_file = "scores.html"
  , output_file = "detailed_results.html"
)

print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
