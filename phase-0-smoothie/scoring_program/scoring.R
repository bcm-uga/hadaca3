## Authors: Alexis ARNAUD, Magali RICHARD, UGA
## alexis.arnaud@univ-grenoble-alpes.fr
## magali.richard@univ-grenoble-alpes.fr
##---------------------------------------------


for ( package in c( "combinat", "rmarkdown", "clue", "infotheo") ) {
    if ( !{ package %in% installed.packages( ) } ) {
        install.packages(pkgs = package, repos = "https://cloud.r-project.org")
    }
}
remove(list = "package")

##############################################
### SCORING

#########################
# homogenization function to find the best match between real and estimated A matrices

homogeneized_cor_mat = function(A_real, A_est) {
    cmat = cor(t(A_real),t(A_est))
    pvec <- c(clue::solve_LSAP((1+cmat)^2,maximum = TRUE))
    return(A_est[pvec,])
}
#########################
# Estimated A pre-treatment
#not useful because reference based algorithm

prepare_A <- function(A_real, A_est) {
  N <- ncol(A_real)
  K <- nrow(A_real)
    
  stopifnot(K > 1)
  stopifnot(ncol(A_est) == N)
  stopifnot(!anyNA(A_est))
    
  ### STEP 1 : matching the number of estimated components to the real number of cell types K
    
  ## if estimating too few cell types
  if (nrow(A_est) < K) {
    #set random positive values closed to 0 for missing rows
    set.seed(1)
    random_data = abs(jitter(matrix(data = 0, nrow = K - nrow(A_est), ncol = N), factor = 0.01))
    A_est <- rbind(A_est, random_data)
    print("Add rows of 0s to match K")
  }
           
  ## if estimating too many cell types
  
  ### strategy 1: keep the most abundant cell types
  if (nrow(A_est) > K) {
    A_est <- A_est[order(rowSums(A_est), decreasing = TRUE)[1:K],]
    print("Number of estimated cell types exceeds K, only the K most abundant cell types are kept for scoring.")
  }
  
  ### strategy 2: clustering of similar cell types to match K components -> SLIM
        
  ### STEP 2 : reordering estimated components to find the best match -> SLIM
  A_est_best_cor = as.matrix(homogeneized_cor_mat(A_real, A_est))
  
  return(A_est_best_cor)
}

#########################
# Computation of Pearson correlation on rows, columns and whole matrix
pearson_cor <-  function(real, prediction) {
  return(cor(c(as.matrix(real)), c(prediction), method="pearson"))
}

eval_pearson = function(A_real, A_est) {
  cor_matrix = pearson_cor(A_real, A_est)
  cor_row = sapply(seq(nrow(A_est)), function(i)
    pearson_cor(A_real[i, ], A_est[i, ]))
  cor_col = sapply(seq(ncol(A_est)), function(i)
    pearson_cor(A_real[, i], A_est[, i]))
  return(structure(c(cor_matrix, mean(cor_row, na.rm=T), mean(cor_col, na.rm=T)),
                   names=c("cor_matrix", "cor_row", "cor_col")))
}

#########################
# Computation of RMSE

eval_RMSE = function (A_real, A_est) {
  return(sqrt(mean((A_real - A_est)^2)))
}

#########################
# Computation of Mean Absolute Error

eval_MAE = function (A_real, A_est){
  return(mean(abs(A_real - A_est)))
}

#########################
# Scoring function 

scoring_function <- function(A_real, A_est) {
  
  # pre-treatment of estimated A
  A_est_tt = prepare_A(A_real = A_real, A_est = A_est)
  
  # scoring
  rmse = eval_RMSE(A_real, A_est_tt)
  mae = eval_MAE(A_real, A_est_tt)
  pearson = eval_pearson(A_real, A_est_tt)

  # scores aggregation (ADD TIME)
  
  # load baselines scores for normalization (data.frame of the 5 scores for each baseline on the same dataset)
  # baseline_estimation = readRDS("baseline_scores.rds")
  # PATCH FCh: issue #5 "baseline_scores.rds not present""
  baseline_estimation = data.frame("rmse"=rmse,
                                     "mae"=mae,
                                     "pearson_mat"=pearson[["cor_matrix"]],
                                     "pearson_row"=pearson[["cor_row"]]   ,
                                     "pearson_col"=pearson[["cor_col"]]    
                                  )

  judge_candidate = rbind(baseline_estimation,
                          data.frame("rmse"=rmse,
                                     "mae"=mae,
                                     "pearson_mat"=pearson[["cor_matrix"]],
                                     "pearson_row"=pearson[["cor_row"]]   ,
                                     "pearson_col"=pearson[["cor_col"]]    
                                    )
                          )

  CenterScaleNorm <-function(x) {
  tr1 = x - mean(x, na.rm=TRUE)
  tr2 = tr1/sd(x, na.rm=TRUE)
  return(pnorm(tr2))
  }
  judge_candidate_norm = apply(judge_candidate, 2, CenterScaleNorm)

  # Merge pearson scores
  judge_candidate_norm_concat = cbind(judge_candidate_norm[,-grep("pearson",colnames(judge_candidate_norm))],
                                      rowMeans(judge_candidate_norm[,grep("pearson",colnames(judge_candidate_norm))]))

  # Average over judges (geometric mean) and keep only the score of the candidate (not the baselines)
  score_aggreg = apply(judge_candidate_norm_concat, 1, function(x) exp(mean(log(x), na.rm=T)))[nrow(judge_candidate)]

  return(list(score_aggreg = score_aggreg,
              rmse = rmse,
              mae = mae,
              "pearson_mat"=pearson[["cor_matrix"]],
              "pearson_row"=pearson[["cor_row"]]   ,
              "pearson_col"=pearson[["cor_col"]]    
        ))
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
    

## Load reference data
A_real =  readRDS(file = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep, "groundtruth_smoothies_fruits.rds") )



## load R profiling of the estimation of A :
profiling <- readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "Rprof.rds") )



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






##Ensure some properties of the Prediction are ok. 

Aest  = as.matrix(readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "prediction.rds") ) )
A_real = as.matrix(A_real)

# print(Aest)

validate_pred( Aest, nb_samples = ncol(A_real), nb_cells=nrow(A_real) , col_names=rownames(A_real) )


scores_full = scoring_function(A_real = A_real,  A_est = Aest)

scores = as.numeric(scores_full)

saveRDS(scores, paste0(output,"/score.rds"))

# stopifnot(exprs = all( !is.na(x = scores) ) )
print(paste0("Scores names : ", paste(names(scores_full), collapse = ", ") ))
print(x = paste0("Scores dataset : ", paste(scores, collapse = ", ") ) )
cat(paste0("Accuracy_mean: " , mean(x = scores,na.rm=TRUE), "\n"), file = output_file, append = TRUE)

print(x = list.files(path = output, all.files = TRUE, full.names = TRUE, recursive = TRUE) )



# cat(paste0("Time :", sum( profiling$by.total$total.time ) / length(x = Aref), "\n"), file = output_file, append = TRUE )
# cat(paste0("Time: ", profiling["elapsed"], "\n"), file = output_file, append = TRUE )
cat(paste0("Time: ", profiling, "\n"), file = output_file, append = TRUE )

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
