install.packages("coda.base", repos="https://cloud.r-project.org")

weighgeomMean <- function(x,w) {
  prod(mapply(function(a,b) a^b, a=x, b=w), na.rm=T)^(1/sum(w))
}

#########################
# homogenization function to find the best match between real and predicted A matrices for unsupervised methods. -USELESS
homogeneized_cor_mat = function(A_real, A_pred) {
    cmat = cor(t(A_real),t(A_pred))
    pvec <- c(clue::solve_LSAP((1+cmat)^2,maximum = TRUE))
    return(A_pred[pvec,])
}

#########################
# Pre-treatment of predicted A
#not useful because reference based algorithm
prepare_A <- function(A_real, A_pred) {
  N <- ncol(A_real)
  K <- nrow(A_real)
    
  stopifnot(K > 1)
  stopifnot(ncol(A_pred) == N)
  stopifnot(!anyNA(A_pred))
    
  ### STEP 1 : matching the number of predicted components to the real number of cell types K
    
  ## if predicting too few cell types
  if (nrow(A_pred) < K) {
    #set random positive values closed to 0 for missing rows
    set.seed(1)
    random_data = abs(jitter(matrix(data = 0, nrow = K - nrow(A_pred), ncol = N), factor = 0.01))
    A_pred <- rbind(A_pred, random_data)
    print("Add rows of 0s to match K")
  }
           
  ## if predicting too many cell types
  
  ### strategy 1: keep the most abundant cell types
  if (nrow(A_pred) > K) {
    A_pred <- A_pred[order(rowSums(A_pred), decreasing = TRUE)[1:K],]
    print("Number of predicted cell types exceeds K, only the K most abundant cell types are kept for scoring.")
  }
  
  ### strategy 2: clustering of similar cell types to match K components -> SLIM
        
  ### STEP 2 : reordering predicted components to find the best match -> SLIM
  A_pred_best_cor = as.matrix(homogeneized_cor_mat(A_real, A_pred))
  
  return(A_pred_best_cor)
}

#########################
# Global Pearson/Spearman correlation coefficients
correlationP_tot = function(A_real, A_pred) {
  if (all(c(var(A_pred))==0)) {return(-1)} #worst case scenario where all cell types are predicted with the same proportions
  return(cor(c(A_real), c(A_pred), method = "pearson"))
}
correlationS_tot = function(A_real, A_pred) {
  if (all(c(var(A_pred))==0)) {return(-1)} #worst case scenario where all cell types are predicted with the same proportions
  return(cor(c(A_real), c(A_pred), method = "spearman"))
}

#########################
# Mean column/sample Pearson/Spearman correlation coefficients
correlationP_col = function(A_real, A_pred) {
  res = c()
  for (i in seq(ncol(A_real))) {
    if (sd(A_pred[, i]) > 0 & sd(A_real[, i]) > 0) {
      res[i] = cor(A_real[, i], A_pred[, i], method = "pearson")
    }
  }
  res = res[!is.na(res)]
  print(paste0(length(res), " columns are kept for correlation analysis"))
  if (length(res)==0) {return(-1)}
  return(mean(res))
}
correlationS_col = function(A_real, A_pred) {
  res = c()
  for (i in seq(ncol(A_real))) {
    if (sd(A_pred[, i]) > 0 & sd(A_real[, i]) > 0) {
      res[i] = cor(A_real[, i], A_pred[, i], method = "spearman")
    }
  }
  res = res[!is.na(res)]
  print(paste0(length(res), " columns are kept for correlation analysis"))
  if (length(res)==0) {return(-1)}
  return(mean(res))
}

#########################
# Mean row/cell type Pearson/Spearman correlation coefficients
correlationP_row = function (A_real, A_pred) {
  res = c()
  for (i in seq(nrow(A_real))) {
    if (sd(A_pred[i, ]) > 0 & sd(A_real[i, ]) > 0) {
      res[i] = cor(A_real[i, ], A_pred[i, ], method = "pearson")
    }
  }
  res = res[!is.na(res)]
  print(paste0(length(res), " rows are kept for correlation analysis"))
  if (length(res)==0) {return(-1)}
  return(mean(res))
}
correlationS_row = function (A_real, A_pred) {
  res = c()
  for (i in seq(nrow(A_real))) {
    if (sd(A_pred[i, ]) > 0 & sd(A_real[i, ]) > 0) {
      res[i] = cor(A_real[i, ], A_pred[i, ], method = "spearman")
    }
  }
  res = res[!is.na(res)]
  print(paste0(length(res), " rows are kept for correlation analysis"))
  if (length(res)==0) {return(-1)}
  return(mean(res))
}

#########################
# Aitchison distance
eval_Aitchison = function(A_real, A_pred, min = 1e-9) {
  # Aitchison dist doesn't like 0 
  A_real[A_real < min] = min
  A_pred[A_pred < min] = min
  
  # Aitchison apply a transformation to manage compositional data, so only sample by sample comparison have sens
  res = c()
  for (i in seq(ncol(A_real))) {
    res[i] = coda.base::dist(rbind(t(A_real[,i]), t(A_pred[,i])), method = "aitchison")[1]
  }
  res = res[!is.na(res)]
  return(mean(res))
}

#########################
# RMSE
eval_RMSE = function(A_real, A_pred) {
  return(sqrt(mean((A_real - A_pred)^2)))
}

#########################
# MAE
eval_MAE = function (A_real, A_pred){
  return(mean(abs(A_real - A_pred)))
}

#########################
# Scoring function 
scoring_function <- function(A_real, A_pred) {
  # pre-treatment of predicted A
  #A_pred = prepare_A(A_real = A_real, A_pred = A_pred)
  
  # scoring with different metrics
  if (nrow(A_pred)==nrow(A_real)) {
    
    # Match cell types
    if (all(rownames(A_pred) %in% rownames(A_real))) {
      A_pred = A_pred[rownames(A_real),]
    }
    else {stop(paste0("Cell types names do not match:\n Predicted cell types are ",paste(rownames(A_pred), collapse=', '),"\n Real cell types are ",paste(rownames(A_real), collapse=', ')))}
    mae = eval_MAE(A_real, A_pred)
    rmse = eval_RMSE(A_real, A_pred)
    aitchison = eval_Aitchison(A_real, A_pred)
    pearson_tot = correlationP_tot(A_real, A_pred)
    pearson_col = correlationP_col(A_real, A_pred)
    pearson_row = correlationP_row(A_real, A_pred)
    spearman_tot = correlationS_tot(A_real, A_pred)
    spearman_col = correlationS_col(A_real, A_pred)
    spearman_row = correlationS_row(A_real, A_pred)
    all_judges = data.frame("rmse"=rmse,
                            "mae"=mae,
                            "aitchison"=aitchison,
                            "pearson_tot"=pearson_tot,
                            "pearson_col"=pearson_col,
                            "pearson_row"=pearson_row,
                            "spearman_tot"=spearman_tot,
                            "spearman_col"=spearman_col,
                            "spearman_row"=spearman_row)
  }
  else if (nrow(A_pred)==(nrow(A_real)+1)) { # In case of an extra cell type in the reference matrix compared to the source/ground truth
    # Match cell types
    if (all(rownames(A_real) %in% rownames(A_pred))) {
      extra_type = matrix(0,ncol=ncol(A_real),nrow=1)
      rownames(extra_type) = setdiff(rownames(A_pred),rownames(A_real))
      A_real = rbind(A_real,extra_type)
      A_pred = A_pred[rownames(A_real),]
    }
    else {stop(paste0("Cell types names do not match:\n Predicted cell types are ",paste(rownames(A_pred), collapse=', '),"\n Real cell types are ",paste(rownames(A_real), collapse=', ')))}
    mae = eval_MAE(A_real, A_pred)
    rmse = eval_RMSE(A_real, A_pred)
    aitchison = eval_Aitchison(A_real, A_pred)
    pearson_tot = correlationP_tot(A_real, A_pred)
    pearson_col = correlationP_col(A_real, A_pred)
    pearson_row = correlationP_row(A_real, A_pred)
    spearman_tot = correlationS_tot(A_real, A_pred)
    spearman_col = correlationS_col(A_real, A_pred)
    spearman_row = correlationS_row(A_real, A_pred)
    all_judges = data.frame("rmse"=rmse,
                            "mae"=mae,
                            "aitchison"=aitchison,
                            "pearson_tot"=pearson_tot,
                            "pearson_col"=pearson_col,
                            "pearson_row"=pearson_row,
                            "spearman_tot"=spearman_tot,
                            "spearman_col"=spearman_col,
                            "spearman_row"=spearman_row)
  }
  else if (nrow(A_pred)==(nrow(A_real)-1)) { # In case of a missing cell type in the reference matrix compared to the source/ground truth
    # Match cell types
    if (all(rownames(A_pred) %in% rownames(A_real))) {
      A_real = A_real[rownames(A_pred),]
    }
    else {stop(paste0("Cell types names do not match:\n Predicted cell types are ",paste(rownames(A_pred), collapse=', '),"\n Real cell types are ",paste(rownames(A_real), collapse=', ')))}
    mae = eval_MAE(A_real, A_pred)
    rmse = eval_RMSE(A_real, A_pred)
    aitchison = eval_Aitchison(A_real, A_pred)
    pearson_tot = correlationP_tot(A_real, A_pred)
    pearson_col = correlationP_col(A_real, A_pred)
    pearson_row = correlationP_row(A_real, A_pred)
    spearman_tot = correlationS_tot(A_real, A_pred)
    spearman_col = correlationS_col(A_real, A_pred)
    spearman_row = correlationS_row(A_real, A_pred)
    all_judges = data.frame("rmse"=rmse,
                            "mae"=mae,
                            "aitchison"=aitchison,
                            "pearson_tot"=pearson_tot,
                            "pearson_col"=pearson_col,
                            "pearson_row"=pearson_row,
                            "spearman_tot"=spearman_tot,
                            "spearman_col"=spearman_col,
                            "spearman_row"=spearman_row)
  }
  else if (nrow(A_pred) > nrow(A_real) & setequal(rownames(A_real), c("basal",'classic'))) { # partial ground truth only for the in vivo dataset
    rmse = NA
    mae = NA
    aitchison = NA
    pearson_tot = NA
    pearson_col = NA
    pearson_row = correlationP_row(A_real, A_pred[rownames(A_real),])
    spearman_tot = NA
    spearman_col = NA
    spearman_row = correlationS_row(A_real, A_pred[rownames(A_real),])
    all_judges = data.frame("rmse"=rmse,
                            "mae"=mae,
                            "aitchison"=aitchison,
                            "pearson_tot"=pearson_tot,
                            "pearson_col"=pearson_col,
                            "pearson_row"=pearson_row,
                            "spearman_tot"=spearman_tot,
                            "spearman_col"=spearman_col,
                            "spearman_row"=spearman_row)
    weights_spec = c(rep(0,5),1/2,rep(0,2),1/2)
  }
  
  # generate best/worst possible metrics
  fake_worst_pred = apply(A_real, 2, function(prop) { 
    tmp = rep(1e-9, length(prop))
    tmp[which.min(prop)] = 1
    return(tmp)})
  judge_candidate = rbind(all_judges,
                          data.frame("rmse"=0,
                                     "mae"=0,
                                     "aitchison"=0,
                                     "pearson_tot"=1,
                                     "pearson_col"=1,
                                     "pearson_row"=1,
                                     "spearman_tot"=1,
                                     "spearman_col"=1,
                                     "spearman_row"=1),
                          data.frame("rmse"=eval_RMSE(A_real, fake_worst_pred),
                                     "mae"=eval_MAE(A_real, fake_worst_pred),
                                     "aitchison"=eval_Aitchison(A_real, fake_worst_pred), # verify it's the correct worst distance
                                     "pearson_tot"=-1,
                                     "pearson_col"=-1,
                                     "pearson_row"=-1,
                                     "spearman_tot"=-1,
                                     "spearman_col"=-1,
                                     "spearman_row"=-1))
  
  # normalize scores
  #CenterScaleNorm <- function(x) {
  #  tr1 = x - mean(x, na.rm=T)
  #  tr2 = tr1/sd(x, na.rm=T)
  #  return(pnorm(tr2))
  #}
  # strategy when normalizing only one method
  CenterScaleNorm <- function(x) {
    tr1 = x - min(x, na.rm=T)
    tr2 = tr1/(max(tr1, na.rm=T))
    return(tr2)
  }
  judge_candidate_norm = apply(judge_candidate, 2, CenterScaleNorm)

  # transform scores s.t. 1 is the best score
  judge_candidate_norm = 1 - judge_candidate_norm
  judge_candidate_norm[,grep("pearson",colnames(judge_candidate_norm))] = 1 - judge_candidate_norm[,grep("pearson",colnames(judge_candidate_norm))]
  judge_candidate_norm[,grep("spearman",colnames(judge_candidate_norm))] = 1 - judge_candidate_norm[,grep("spearman",colnames(judge_candidate_norm))]
  
  # Average over judges with the geometric mean for the candidate of interest
  #score_aggreg = exp(mean(log(judge_candidate_norm[1,]),na.rm=T))
  weights = c(1/3*1/2,1/3*1/2,
              1/3,
              rep(1/3*1/6,6))
  if (nrow(A_pred) > nrow(A_real) & setequal(rownames(A_real), c("basal",'classic'))) {weights = weights_spec}
  score_aggreg = weighgeomMean(judge_candidate_norm[1,],
                               weights)

  return(list("score_aggreg"=score_aggreg,
              "rmse"=rmse,
              "mae"=mae,
              "aitchison"=aitchison,
              "pearson_tot"=pearson_tot,
              "pearson_col"=pearson_col,
              "pearson_row"=pearson_row,
              "spearman_tot"=spearman_tot,
              "spearman_col"=spearman_col,
              "spearman_row"=spearman_row))
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


# input = "test_output"
# output = "test_output"
# program ="test_output"

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



###########################################################
# Reading files and scroring function
###########################################################


## load R profiling of the estimation of A :
profiling <- readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "Rprof.rds") )


##Ensure some properties of the Prediction are ok. 
Aest_l  = readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "prediction.rds") )

l_res = list()


# mixes2_insilicodirichletEMFA_pdac.rds
# groundtruth2_invivo_pdac.rds

dir_name = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep)
groundtruh_list = list.files(dir_name,pattern="groundtruth*")

for (groundthruth_name in groundtruh_list){
  
  gt_list = unlist(strsplit(groundthruth_name, "_"))
  methods_name =  gt_list[2]
  phase =  substr(gt_list[1], nchar(gt_list[1]), nchar(gt_list[1]))

  dataset_name = paste0("mixes",phase,"_",methods_name,'_pdac.rds')

  message(dataset_name)

  # print(dim(Aest_l))
  Aest = as.matrix(Aest_l[[dataset_name]])
  # print(dim(Aest))
  ## Load ground_thuth data


  Atruth =  readRDS(file = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep, groundthruth_name) )
  print(dim(Atruth))
  Atruth = as.matrix(Atruth)
  
  # timing=profiling[[dataset_name]]

  # baseline_scores = baseline_scoring_function(A_real=Atruth, A_pred=Aest, time=as.numeric(timing))
  baseline_scores = scoring_function(A_real=Atruth,  A_pred=Aest)

  score_mean = as.numeric(baseline_scores$score_aggreg)
  # break
  # baseline_scores = baseline_scoring_function(A_real=Atruth, A_pred=Aest, time=timing)
  # rownames(baseline_scores$baseline_estimation) = baseline

  scores = as.numeric(baseline_scores)
  names(scores) = names(baseline_scores)

  saveRDS(scores, paste0(output,"/scores_",dataset_name))

  cat(scores)
  # stopifnot(exprs = all( !is.na(x = scores) ) )
  # print(x = paste0("Scores dataset ",toString(dataset_name), ": ", paste(baseline_scores, collapse = ", ") ) )

  # score_mean = mean(x = as.numeric(scores), na.rm =TRUE )
  # score_mean = as.numeric(scores$score_aggreg)
  cat(paste0("Accuracy_mean_",toString(methods_name), ": " , score_mean, "\n"), file = output_file, append = TRUE)

  l_res[[dataset_name]] = score_mean

  print(x = list.files(path = output, all.files = TRUE, full.names = TRUE, recursive = TRUE) )

}

cat(paste0("median_performance : " , median(unlist(l_res)), "\n"), file = output_file, append = TRUE)

cat(paste0("Time: ", sum(as.numeric(unlist(profiling))), "\n"), file = output_file, append = TRUE )
print( paste0("Time: ", toString(unlist(profiling)), " ", sum(unlist(profiling)), "\n") )

rmarkdown::render(
  input       = paste0(program, .Platform$file.sep, "detailed_results.Rmd")
  , envir       = parent.frame( )
  , output_dir  = output
  , output_file = "detailed_results.html"
)

print(x = "Output :")
print(x = list.files(path = output , all.files = TRUE, full.names = TRUE, recursive = TRUE) )
print(x = "")
