##################################################################################################
### PLEASE only edit the program function between YOUR CODE BEGINS/ENDS HERE                   ###
##################################################################################################

### Write programs Here !


##############################################################
### Generate a prediction file /!\ DO NOT CHANGE THIS PART ###
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
    # tryCatch(message("hello\n"), message=function(e){cat("goodbye\n")})  use this here ? 
    stop(error_informations)
  }
  if(error_status == 2){
    print("Warning: ")
    warning(error_informations)
  }  
}

dir_name = paste0("data",.Platform$file.sep)
dataset_list = list.files(dir_name,pattern="mixes*")

source("attachement/data_processing.R")

reference_data <- read_hdf5( paste0(dir_name, "reference_pdac.h5"))


predi_list = list()
for (dataset_name in dataset_list){

  print(paste0("generating prediction for dataset:",toString(dataset_name) ))

  mixes_data <- read_hdf5(paste0(dir_name, dataset_name))

  if ("mix_rna" %in% names(mixes_data)) {
    mix_rna = mixes_data$mix_rna
  } else {
    mix_rna = mixes_data
  }
  if ("mix_met" %in% names(mixes_data)) {
    mix_met = mixes_data$mix_met  
  } else {
    mix_met = NULL
  }

  if ("ref_bulkRNA" %in% names(reference_data)) {
    ref_bulkRNA = reference_data$ref_bulkRNA
  } else {
    ref_bulkRNA = reference_data
  }
  if ("ref_met" %in% names(reference_data)) {
    ref_met = reference_data$ref_met  
  } else {
    ref_met = NULL
  }
  if ("ref_scRNA" %in% names(reference_data)) {
    ref_scRNA = reference_data$ref_scRNA  
  } else {
    ref_scRNA = NULL
  }

  # we use the previously defined function 'program' to estimate A :
  pred_prop <- program(mix_rna, ref_bulkRNA, mix_met=mix_met, ref_met=ref_met, ref_scRNA=ref_scRNA)
  validate_pred(pred_prop,nb_samples = ncol(mix_rna),nb_cells = ncol(ref_bulkRNA),col_names = colnames(ref_met))
  predi_list[[dataset_name]] = pred_prop

}


##############################################################
### Check the prediction /!\ DO NOT CHANGE THIS PART ###
##############################################################


###############################
### Code submission mode


print("")
for (package in c("zip") ) {
  if ( !{ package %in% installed.packages( ) } ) {
        print(x = paste("Installation of ", package, sep = "") )
        install.packages(
            pkgs = "zip"
          , repos = "https://cloud.r-project.org"
        )
    } 
}


# we generate a zip file with the 'program' source code

if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}

# we save the source code as a R file named 'program.R' :
dump(
    list = c("program")
    # list = new_functions
  , file = paste0("submissions", .Platform$file.sep, "program.R")
)

date_suffix = format(x = Sys.time( ), format = "%Y_%m_%d_%H_%M_%S")



zip_program <- paste0("submissions", .Platform$file.sep, "program_", date_suffix, ".zip")
zip::zip(zipfile= zip_program
  , files   = paste0("submissions", .Platform$file.sep, "program.R")
  , mode = "cherry-pick")

if(dir.exists("attachement")) {
  zip::zip_append(
      zipfile = zip_program
      , files= paste0("attachement", .Platform$file.sep)
    , mode = "cherry-pick"
  )
}

zip::zip_list(zip_program)
print(x = zip_program)




# # we create the associated zip file :
# zip_program <- paste0("submissions", .Platform$file.sep, "program_", date_suffix, ".zip")
# zip::zip(zipfile= zip_program
#                 , files= paste0("submissions", .Platform$file.sep, "program.R")
#                 , mode = "cherry-pick"
#                 )

# zip::zip_list(zip_program)
# print(x = zip_program)

###############################
### Result submission mode  

#  Generate a zip file with the prediction
if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}

prediction_name = "prediction.h5"

## we save the estimated A matrix as a rds file named 'results.rds' :
write_global_hdf5(paste0("submissions", .Platform$file.sep, prediction_name),predi_list)
# saveRDS(
# object = predi_list
# , file   = paste0("submissions", .Platform$file.sep, prediction_name)) 

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

