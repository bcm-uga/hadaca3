

h3_p_path = "~/projects/hadaca3_private/"




#  Generate a zip file with the prediction
if ( !dir.exists(paths = "submissions") ) {
    dir.create(path = "submissions")
}


source(paste0(h3_p_path,"baselines.R"))

for (baseline in baselines){
   file = paste0(h3_p_path, "baseline_",baseline,".R")
   file.copy(file, paste0("submissions", .Platform$file.sep, "program.R"))

   zip_program <- paste0("submissions", .Platform$file.sep, "submission_", baseline, ".zip")
   zip::zip(zipfile= zip_program
                  , files= paste0("submissions", .Platform$file.sep, "program.R")
                  , mode = "cherry-pick"
                  )

   zip::zip_list(zip_program)
   # print(x = zip_program)
}
