

h3_p_path = "~/projects/hadaca3_private/"

dir_path = "submissions"
# dir_path = "submissions_test"


#  Generate a zip file with the prediction
if ( !dir.exists(paths = dir_path) ) {
    dir.create(path = dir_path)
}

source(paste0(h3_p_path,"baselines.R"))

copy_file <- function(file){
    file_to_take = file.path(h3_p_path,file)
    target = file.path(file)
    file.copy( file_to_take ,target,overwrite =TRUE)
}


for (baseline in baselines){
   file = paste0(h3_p_path, "baseline_",baseline,".R")
   print(file)
   target_file = paste0(dir_path, .Platform$file.sep, "program.R")
   # target_file = paste0(dir_path, .Platform$file.sep, baseline)
   print(target_file)
   file.copy(file, target_file,overwrite =TRUE)
      while (!file.exists(target_file)) {
   Sys.sleep(1)
   }

   if(identical(baseline,"nnlsmultimodalSource") )  {
      dir.create(file.path( "attachement/"), showWarnings = FALSE)
      for ( file in c("attachement/Source_prior_known_features.R","attachement/random_choosen_features.rds")     ){
            copy_file(file)
      }
   }

   zip_program <- paste0(dir_path, .Platform$file.sep, "submission_", baseline, ".zip")
   zip::zip(zipfile= zip_program
                  , files= target_file
                  , mode = "cherry-pick"
   )
   if(dir.exists("attachement")) {
      zip::zip_append(
            zipfile = zip_program
            , files= paste0("attachement", .Platform$file.sep)
         , mode = "cherry-pick"
      )
   } 
                  

   while (!file.exists(zip_program)) {
   Sys.sleep(1)
   }
   zip::zip_list(zip_program)
   unlink("attachement", recursive = TRUE) # will delete directory called 'mydir'

   # print(x = zip_program)
}


## python baselin : 
file = paste0(h3_p_path, "baseline_lm.py")
target_file = paste0(dir_path, .Platform$file.sep, "program.py")
file.copy(file,target_file )


dir.create(file.path("attachement/"), showWarnings = FALSE)
for ( file in c("attachement/additionnal_script.py")     ){
      copy_file(file)
}


zip_program <- paste0(dir_path, .Platform$file.sep, "submission_", "lm_py", ".zip")
zip::zip(zipfile= zip_program
                , files= target_file
                , mode = "cherry-pick"
                )

if(dir.exists("attachement")) {
      zip::zip_append(
            zipfile = zip_program
            , files= paste0("attachement", .Platform$file.sep)
         , mode = "cherry-pick"
      )
}

while (!file.exists(target_file)) {
  Sys.sleep(1)
}

zip::zip_list(zip_program)
unlink("attachement", recursive = TRUE) # will delete directory called 'mydir'

   # print(x = zip_program)