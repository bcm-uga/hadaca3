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
# homogenization function to find the best match between real and estimated A matrix

homgeneized_cor_mat =function(A_r, A_est) {
    cmat=cor(t(A_r),t(A_est))
    pvec <- c(clue::solve_LSAP((1+cmat)^2,maximum = TRUE))
    return(A_est[pvec,])
}


#########################
# Estimated A pre-treatment

#not usefull because reference based algorithm
prepare_A <- function(A_r, A_est) {
    N <- ncol(x = A_r)
    K <- nrow(x = A_r)
    stopifnot(K > 1)
    
    stopifnot( ncol(x = A_est) == N )
    stopifnot( !anyNA(x = A_est))
    
    ### STEP 1 : matching the number of estimated component to real number of cell types K
    
        ## if not supplying enough types (make sure that {nrow(A_est) >= K})
        if ( nrow(x = A_est) < K ) {
               #set positive random values closed to 0 for missing rows
               set.seed(1)
               random_data = abs(jitter(matrix(data = 0, nrow = K - nrow(x = A_est), ncol = N), factor = 0.01))
               A_est <- rbind(A_est, random_data )
                print("Add rows of 0 to match the exact number of K")
           }
           
         ## if supplying too manycell types
         
         ### strategy 1: keep the most abundant cell types
         if ( nrow(x = A_est) > K ) {
                     A_est <- A_est[order(rowSums(A_est), decreasing = TRUE)[1:K],]
                     print("Number of cell type exceded K, only the K most contributing cell types were kept for scoring.")
                 }
                 
        ### strategy 2: clustering of similar cell types to match K components -> SLIM
        
    ### STEP 2 : reordering estimated components to find the best match -> SLIM
    
    homgeneized_cor_mat =function(A_r, A_est) {
     cmat=cor(t(A_r),t(A_est))
    #cmat[cmat<0]=0 
    #cmat= (1+1e-14+(0.5*(log(1+cmat)-log(1-cmat))))/2
     pvec <- c(clue::solve_LSAP((1+cmat)^2,maximum = TRUE)) 
        #print(pvec)
     return(A_est[pvec,])
 
    }
     
    A_est_best_cor = as.matrix(homgeneized_cor_mat(A_r, A_est))
    
    return(A_est_best_cor)
}

#########################
# Coputation of column correlation score

correlation_col = function (A_r , Aest_p){
    res = c()
    for(i in 1:ncol(A_r)){
       if (sd(Aest_p[, i]) > 0 & sd(A_r[, i]) > 0) {
        res[i] =cor(A_r[, i], Aest_p[, i], method = "pearson")
        }
    }

    res = res[!is.na(res)]
       print(paste0(length(res), " cols are kept for correlation analysis"))
    res[which(res<0)] = 0
    COR = sum(res)/length(res)

    return(COR)
}

#########################
# Coputation of row correlation score

correlation_row = function (A_r , Aest_p){
    res = c()
    for(i in 1:nrow(A_r)){
       if (sd(Aest_p[i, ]) > 0 & sd(A_r[i, ]) > 0) {
        res[i] =cor(A_r[i, ], Aest_p[i, ], method = "pearson")
        }
    }
   
    res = res[!is.na(res)]
    print(paste0(length(res), " rows are kept for correlation analysis"))
    res[which(res<0)] = 0
    COR = sum(res)/length(res)

    return(COR)
}

#########################
# Computation of Mean absolute error score

eval_MAE = function (A_r , Aest_p){
  MAE <- function(M1, M2) {
      return(mean(x = abs(x = M1 - M2) ))
  }
  return(MAE(A_r,Aest_p) )
}

#########################
# Scoring function 

scoring_function <- function(Aref, Aest) {
  #  pretreatment of estimated A
#   Aest_p = prepare_A(A_r = Aref, A_est = Aest)
  Aest_p = Aest[rownames(Aref),]
  
  #  scoring
  mae = eval_MAE(Aref, Aest_p)
  cr = correlation_row(Aref, Aest_p)
  cc = correlation_col(Aref, Aest_p)
  #  scoring agregation (using a derivative of the maxmin approach)
  rd_mae = c()
  set.seed(1)
  random_col = c(1, rep(0,(nrow(Aref)-1)))
  random_base = matrix(rep(random_col, ncol(Aref)), nrow(Aref), ncol(Aref))
  for (j in 1:1000){
      rd= random_base[sample(nrow(Aref)),]
      rd_mae[j] =eval_MAE(Aref,rd)
  }
  max_mae = max(rd_mae)
  min_mae = 0
  max_cor = 1
  min_cor = 0
  mae_maxmin = (mae - min_mae) / (max_mae-min_mae)
  cr_maxmin = (cr - min_cor) / (max_cor-min_cor)
  cc_maxmin = (cc - min_cor) / (max_cor-min_cor)
  score_combine = ( cr_maxmin + cc_maxmin + (1- mae_maxmin) )/3
    return( list(score_combine =  score_combine,
                mae = mae,
                cr = cr,
                cc = cc,
                mae_maxmin = mae_maxmin,
                cr_maxmin = cr_maxmin,
                cc_maxmin = cc_maxmin))
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
Aref =  readRDS(file = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep, "ground_truth.rds") )
# Aref =  readRDS(file = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep, "test_solution.rds") )
# Aref = list(Aref) #remove this if you ref is already a list
# nb_dataset = length(Aref)
# print(x = paste0("Number of test dataset is :", nb_dataset) )


## load submited results from participant program :
# Aest <- lapply(
#     X   = seq_len(length.out = nb_dataset )
#   , FUN = function( i ) {
#       readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "results_", i, ".rds") )
#   }
# )
Aest = readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "prediction.rds") )


## load R profiling of the estimation of A :
profiling <- readRDS(file = paste0(input, .Platform$file.sep, "res", .Platform$file.sep, "Rprof.rds") )



##############################################


validate_pred <- function(pred, nb_samples = ncol(Aref), nb_cells=nrow(Aref) , col_names=rownames(Aref) ){

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
    msg= paste0('The prediction matrix has the dimention: ',toString(dim(pred))," whereas the dimention: ",toString(c(nb_cells,nb_samples))," is expected\n"   )
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



Aref = as.matrix(Aref)
Aest = as.matrix(Aest)


##Ensure some properties of the Prediction are ok. 
validate_pred( Aest )


#compute scores
    # scores_full <- sapply(
    # X   = seq_len(length.out = nb_dataset  )
    # , FUN = function( i ) {
    #   print(i)
    #     scoring_function(Aref = as.matrix(Aref[[ i ]]),  Aest = as.matrix(Aest[[ i ]] ))
    # }
    # )

    scores_full = scoring_function(Aref = Aref,  Aest = Aest)
    # if (nb_dataset > 1) {scores = as.numeric(scores_full[1,])}
    # if (nb_dataset == 1) {scores = as.numeric(scores_full[1])}
    scores = as.numeric(scores_full)


    #generate estimated pre-treated A matrix for visualisation purposes
    # estimates = list()
    # for (i in seq_len(length.out = length(x = Aest) ) ) {
    #     print(x = paste0("A matrix ", i) )
    #    estimates[[i]] = prepare_A(A_r = as.matrix(Aref[[ i ]]), A_est = as.matrix(Aest[[ i ]] ) )
    # }
    # remove(list = "i")
    

    #generate result table using aggregated score
        # res <- data.frame(
        # A         = seq_len(length.out = nb_dataset  )
        # , scoring = rep(x = program,   times = nb_dataset)
        # , accuracy     = scores
        # )
    
        #saving and visualisation
    
        # saveRDS(res, paste0(output,"/res_df.rds"))
        saveRDS(scores, paste0(output,"/accuracy.rds"))

        stopifnot(exprs = all( !is.na(x = scores) ) )
        print(x = paste0("Scores : ", paste(scores, collapse = ", ") ) )

        # if (nb_dataset == 1){
        #     print("Scores : No Accuracy_sd computed because there is only one solution to be tested")
        #     cat(paste0("Accuracy_mean: " , mean(x = scores ), "\n"), file = output_file, append = FALSE)
        #     cat(paste0("Accuracy_sd: "   , 0, "\n"), file = output_file, append = TRUE )
        #     cat(paste0("Time: "     , sum( profiling$by.total$total.time ) / length(x = Aref), "\n"), file = output_file, append = TRUE )
        # } 
        # else {
        #     print("Scores : Accuracy_mean, Accuracy_sd and Time computed")
        #     cat(paste0("Accuracy_mean: " , mean(x = scores ), "\n"), file = output_file, append = FALSE)
        #     cat(paste0("Accuracy_sd: "   , sd(  x = scores ), "\n"), file = output_file, append = TRUE )
        #     cat(paste0("Time: "     , sum( profiling$by.total$total.time ) / length(x = Aref), "\n"), file = output_file, append = TRUE )
        # }

        cat(paste0("Accuracy_mean: " , mean(x = scores ), "\n"), file = output_file, append = FALSE)
        cat(paste0("Time: "     , sum( profiling$by.total$total.time ) / length(x = Aref), "\n"), file = output_file, append = TRUE )

        print(x = list.files(path = output, all.files = TRUE, full.names = TRUE, recursive = TRUE) )

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
    
        

