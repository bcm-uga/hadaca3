#' The function to estimate the A matrix
#' In the provided example, we use basic non-negative least squares (package "nnls"), which consists of minimizing the error term $||Mix - Ref \times Prop||^2$ with only positive entries in the prop matrix.
#'
#' @param mix a matrix of bulks (columns) and features (rows)
#' @param ref a matrix pure types (columns) and features (rows)
#' @param ... other parameters that will be ignored
#' 
#' @return the estimated A matrix
#' 
program = function(mix=NULL, ref=NULL, ...) {

  ##
  ## YOUR CODE BEGINS HERE
  ##
  
  requiered_packages = c() 

  installed_packages <- installed.packages( )
  for (package in requiered_packages ) {
      if ( !{ package %in% installed_packages } ) {
          print(x = paste("Installation of ", package, sep = "") )
          install.packages(
              pkgs = package
            , repos = "https://cloud.r-project.org"
          )
      } else {
          print(x = paste(package, " is installed.", sep = "") )
      }
      library(package, character.only = TRUE)
  }
  remove(list = c("installed_packages", "package") )


  idx_feat = intersect(rownames(mix), rownames(ref))

  prop = apply(mix[idx_feat,], 2, function(b, A) {
    # Solve for the least squares solution using OLS
    tmp_prop = lm(b ~ A - 1)$coefficients  # Using `-1` to remove the intercept
    tmp_prop = tmp_prop / sum(tmp_prop)    # Sum To One
    return(tmp_prop)
  }, A=ref[idx_feat,])


  rownames(prop) = colnames(ref)
  return(prop)
  
  ##
  ## YOUR CODE ENDS HERE nnls()
  ##
}


##############################################################
### Generate a prediction file /!\ DO NOT CHANGE THIS PART ###
##############################################################



mixes_data = readRDS("mixes_smoothies_fruits.rds")
reference_data = readRDS("reference_fruits.rds")

# we use the previously defined function 'program' to estimate A :
pred_prop <- program(
  mix = mixes_data ,
  ref = reference_data
)





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
        library(package, character.only = TRUE)
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





##############################################################
### Check the prediction /!\ DO NOT CHANGE THIS PART ###
##############################################################

validate_pred <- function(pred, nb_samples , nb_cells,col_names ){

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



# validate_pred <- function(pred, nb_samples = ncol(mixes_data) , nb_cells= ncol(reference_data),col_names = colnames(reference_data) ){


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
, file   = paste0("submissions", .Platform$file.sep, prediction_name)
) 

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

