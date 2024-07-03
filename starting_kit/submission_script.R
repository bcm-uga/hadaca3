###########
# Authors
# florent.chuffard@univ-grenoble-alpes.fr
# slim.karkar@univ-grenoble-alpes.fr
# magali.richard@univ-grenoble-alpes.fr
# ---

#to get list of function before sourcing new functions
# before <- ls()
########################################################
### Package dependencies /!\ DO NOT CHANGE THIS PART ###
########################################################

##  to generate the zip files that contain the programs or the results to submit to the Codalab platform.

if ( !exists(x = "params") ) {
    params                      <- NULL
}
if ( is.null(x = params$package_repository) ) {
    params$package_repository   <- "https://cloud.r-project.org"
}
if ( is.null(x = params$install_dependencies) ) {
    params$install_dependencies <- TRUE
}
print(params)
if ( params$install_dependencies ) {
    installed_packages <- installed.packages( )
    for (package in c("zip") ) {
        if ( !{ package %in% installed_packages } ) {
            print(x = paste("Installation of ", package, sep = "") )
            install.packages(
                pkgs = package
              , repos = params$package_repository
            )
        } else {
            print(x = paste(package, " is installed.", sep = "") )
        }
    }
    remove(list = c("installed_packages", "package") )
}
# -

####################################################
### Submission modes /!\ DO NOT CHANGE THIS PART ###
####################################################

# Participants can submit either
# - a code program, that will be executed on the challenge platform to generate the result (prediction) that will be scored against the ground truth
# - a result (prediction )file, that will be scored against the ground truth

###############################
### Code submission mode
# Participants need make a zip file (no constrain on the namefile) that contains :
#   - your code inside a *R* file named `program.R`. This file will be sourced and have to contain :
#   - a function `program` with `data_test` and `input_k_value` as arguments 
#   - any other files that you want to access from your function `program` : during the ingestion phase (when your code is evaluated), the working directory will be inside the directory obtained by unzipping your submission.

###############################
### Result submission mode  
# Participants have to make a zip file (no constrain on the namefile), with your results as a matrix inside a rds file named `results_1.rds`.

# if ( !( "tidyverse" %in% installed.packages() ) ) {
#     install.packages(pkgs = "tidyverse", repos = "https://cloud.r-project.org")
# }

# require(tidyverse)


##################################################################################################
### Submission modes /!\ EDIT THE FOLLOWING CODE BY COMMENTING/UNCOMMENTING THE REQUIRED PARTS ###
##################################################################################################
#New data 


mixes_data <- readRDS(file = "mixes_data.rds")

mix_rna <- mixes_data$mix_rna
mix_met <- mixes_data$mix_met


reference_data <- readRDS(file = "reference_data.rds")
ref_rna <- as.matrix(reference_data$ref_bulkRNA)
# ref_sc_rna <- as.matrix(reference_data$ref_scRNA)
ref_met <- as.matrix(reference_data$ref_met)



# # Write a function to predict cell-type heterogeneity proportion matrix
#
# In the provided example, we use a naive method to generate the baseline prediction.

#' The function to estimate the A matrix
#'
#' @param mix_rna the list of bulk matrix associated to the transcriptome data set
#' @param mix_met the list of bulk matrix associated to the methylation data set
#' 
#' @param ref_rna the reference matrix associated to the transcriptome data set
#' @param ref_met the reference matrix associated to the methylation data set
#' 
#' @return the estimated A matrix
#' @examples
#' 
program <- function(mix_rna = NULL, mix_met = NULL, 
                    ref_rna = NULL, ref_met = NULL) {
  ##
  ## YOUR CODE BEGINS HERE
  ##
  
  if ( !( "nnls" %in% installed.packages() ) ) {
      install.packages(pkgs = "nnls", repos = "https://cloud.r-project.org")
  }
  require(nnls)
  
  ## we compute the estimation of the proportions for the transcription data set :
  if ( !( is.null(x = mix_rna) ) ) {
    
    res_rna <- apply( # apply nnls for all sample (i.e. column of mix_rna)
      X = mix_rna,
      MARGIN = 2,
      FUN = nnls,
      A = ref_rna
    )
    
    prop_rna <- sapply( # apply to recover estimate of each bulk
      res_rna, 
      function(res_bulk_i){
        tmp_prop <- res_bulk_i$x # <- res_bulk_i$X if error
        tmp_prop <- tmp_prop / sum(tmp_prop) # Sum To One
        return(tmp_prop)
      }
    ) 
    
    rownames(prop_rna) <- colnames(ref_rna)
    
  }
  
  ## we compute the estimation of A for the methylation data set :
  if ( !( is.null(mix_met) ) ) {
    
    res_met <- apply( # apply nnls for all sample (i.e. column of mix_met)
      X = mix_met,
      MARGIN = 2,
      FUN = nnls,
      A = ref_met
    )
    
    prop_met <- sapply( # apply to recover estimate of each bulk
      res_met, 
      function(res_bulk_i){
        tmp_prop <- res_bulk_i$x # <- res_bulk_i$X if error
        tmp_prop <- tmp_prop / sum(tmp_prop) # Sum To One
        return(tmp_prop)
      }
    ) 
    
    rownames(prop_met) <- colnames(ref_met)
    
  }
  
  
  
  ## we compute the mean of all the estimated A matrices as the final A matrix :
  
  
  
  if ( !is.null(x = mix_met) ) {
    if ( !is.null(x = mix_rna) ) {
      
      stopifnot( identical(x = dim(prop_rna), y = dim(prop_met)) ) # stop if not same number of cell type or samples
      
      ## we have an estimation of prop based on the the methylation and transcriptome data sets
      prop <- (prop_rna + prop_met) / 2
        
    } else {
      
      ## we have an estimation of prop based on the the methylation data set only
      prop <- prop_met
        
    }
  } else {
    
    ## we have an estimation of prop based on the the transcriptome data set only
    prop <- prop_rna
      
  }
  
  if (any(colSums(prop) != 1)) { # Sum To One 
    prop <- sapply(
      1:ncol(prop), 
      function(col_i) { prop[,col_i] / sum(prop[,col_i]) }
    )
  }


  return(prop)
  
  ##
  ## YOUR CODE ENDS HERE
  ##
}


##############################################################
### Generate a submission file /!\ DO NOT CHANGE THIS PART ###
##############################################################

# we use the previously defined function 'program' to estimate A :
pred_prop <- program(
  mix_rna = mix_rna, mix_met = mix_met,
  ref_rna = ref_rna, ref_met = ref_met
)

##############################################################
### Check the prediction /!\ DO NOT CHANGE THIS PART ###
##############################################################

validate_pred <- function(pred, nb_samples = ncol(mix_rna) , nb_cells= ncol(ref_rna),col_names = colnames(ref_met) ){

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


validate_pred(pred_prop)




###############################
### Code submission mode

# we generate a zip file with the 'program' source code

if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}


## list all functions to dump them inside R the program.R.  
# after <- ls()
# changed <- setdiff(after, before)
# changed_objects <- mget(changed, inherits = T)
# changed_function <- do.call(rbind, lapply(changed_objects, is.function))
# new_functions <- changed[changed_function]
# new_functions

# we save the source code as a R file named 'program.R' :
dump(
    list = c("program")
    # list = new_functions
  , file = paste0("submissions", .Platform$file.sep, "program.R")
)

date_suffix = format(x = Sys.time( ), format = "%Y_%m_%d_%H_%M_%S")

# we create the associated zip file :
zip_program <- paste0("submissions", .Platform$file.sep, "program_", date_suffix, ".zip")
zip::zip(zipfile= zip_program
                , files= paste0("submissions", .Platform$file.sep, "program.R")
                , mode = "cherry-pick"
                )

zip::zip_list(zip_program)
print(x = zip_program)

###############################
### Result submission mode  

#  Generate a zip file with the prediction
if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}

prediction_name = "prediction.rds"

## we save the estimated A matrix as a rds file named 'results.rds' :
saveRDS(
object = pred_prop
, file   = paste0("submissions", .Platform$file.sep, prediction_name)) 

# write_rds(pred_prop, file = "prediction_hugo.rds")

## we create the associated zip file :
zip_results <- paste0("submissions", .Platform$file.sep, "results_", date_suffix, ".zip")
zip::zipr(
         zipfile = zip_results
       , files   = paste0("submissions", .Platform$file.sep, c(prediction_name) )
     )
print(x = zip_results)

sessionInfo( )

###############################################################
### How to submit the zip file? /!\ DO NOT CHANGE THIS PART ###
###############################################################
#
# The code above generates the files *`r zip_program`*  and *`r zip_results`*  (the 1st one for code submission, the 2nd one for result submission).
#
# Submit the zip submission file on the challenge in the `My Submission` tab, fill the metadata, select the task you want to submit to and upload your submission files
#
# On the codalab challenge web page, The *STATUS* become :
#   - Submitting
#   - Submitted
#   - Running
#   - Finished
#
# When it’s finished :
#   - You refresh the page and click on the green button 'add to leaderboard' to see your score
#   - If enable, details for report could be downloaded by clicking on your submission
#   - Some execution logs are available to check and or download.
#   - Metadata are editable when you click on your submission
#   - Leader board is updated in the `Results` tab.
#


