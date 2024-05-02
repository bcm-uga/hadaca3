###########
# Authors
# florent.chuffard@univ-grenoble-alpes.fr
# slim.karkar@univ-grenoble-alpes.fr
# magali.richard@univ-grenoble-alpes.fr
# ---

#to get list of function before sourcing new functions
before <- ls()
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



##################################################################################################
### Submission modes /!\ EDIT THE FOLLOWING CODE BY COMMENTING/UNCOMMENTING THE REQUIRED PARTS ###
##################################################################################################


## define the data set that you will use for your prediction (in this example, transcriptome data) :
data_test <- readRDS(file = "public_data_rna.rds") #Comment if you want to predict from methylome data
#data_test <- readRDS(file = "public_data_met.rds") #Uncomment if you want to predict from methylome data

# # Write a function to predict cell-type heterogeneity proportion matrix
#
# In the provided example, we use a naive method to generate the baseline prediction.


#' The prediction function
#'
#' @param D_matrix a matrix from which to estimate the proportion matrix A_matrix
#' @param k the number of cell types to estimate
#' @return The proportion A_matrix and the cell-type specific profiles T_matrix
#' @examples
#' program(D_matrix = data_test, k = 3)

#CAREFUL: submission_script_module.R or other sourced files should be on the same folder. 
# Please don't source inside the program. 
source("modules/submission_script_module.R")

program <- 

    function(D_matrix,  k = 5) { #CAREFUL: don't forget to set the paramater k to the number of cell types you want to estimate
        return(sub_program(D_matrix, k))   #sub programme is included from submission_script_module.R
    
}

##############################################################
### Generate a submission file /!\ DO NOT CHANGE THIS PART ###
##############################################################

# we use the previously defined function 'program' to estimate A :
prediction <- program(
  D_matrix = data_test
  # k = input_k_value
)

###############################
### Code submission mode

# we generate a zip file with the 'program' source code

if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}


# list all functions to dump them.  
after <- ls()
changed <- setdiff(after, before)
changed_objects <- mget(changed, inherits = T)
changed_function <- do.call(rbind, lapply(changed_objects, is.function))
new_functions <- changed[changed_function]
new_functions

# we save the source code as a R file named 'program.R' :
dump(
    # list = c("program")
    list = new_functions
  , file = paste0("submissions", .Platform$file.sep, "program.R")
)


# we create the associated zip file :
zip_program <- paste0("submissions", .Platform$file.sep, "program_", format(x = Sys.time( ), format = "%Y_%m_%d_%S"), ".zip")
# zip::zip(zipfile= zip_program
#                 , files= paste0("modules", .Platform$file.sep)
#                 , mode = "cherry-pick")
# zip::zip_append(
#          zipfile = zip_program
#        #, files   = paste0("submissions", .Platform$file.sep, c("program.R", "metadata") )
#        , files   = paste0("submissions", .Platform$file.sep, "program.R")
#        , mode = "cherry-pick"
#      )
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

## we save the estimated A matrix as a rds file named 'results.rds' :
saveRDS(
object = prediction$A_matrix
, file   = paste0("submissions", .Platform$file.sep, "results_1.rds")) 

## we create the associated zip file :
zip_results <- paste0("submissions", .Platform$file.sep, "results_", format(x = Sys.time( ), format = "%Y_%m_%d_%S"), ".zip")
zip::zipr(
         zipfile = zip_results
       , files   = paste0("submissions", .Platform$file.sep, c("results_1.rds") )
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


