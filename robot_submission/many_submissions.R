source("~/projects/hadaca3_private/baselines.R")

system("ln -s ../phase-1_2_3/input_data data")

for (baseline in baselines[-3]) {
  print(baseline)
  source(paste0("~/projects/hadaca3_private/baseline_", baseline, ".R"))
  source("../templates/template_starter_kit/Phase_1_2_3/template_submission_script.R")
  system(paste0("mv ", zip_program, " submissions/program_", baseline, ".zip"))
  system(paste0("rm ", zip_results))
}


## python submission : 
