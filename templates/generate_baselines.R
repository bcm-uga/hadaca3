
# # TODO implement phase reading 
# if (length(args) >=1) {
#     # Phase = as.character(eval(parse(text=))[2])
# } else {
#     Phase = "Phase_0"
# }

dir_h3_p = "~/projects/hadaca3_private/"
baselines_tables = 'starter_kit_baselines.R'

#  read the baselines to implement the dictionnary for each phase. 
source(paste0(dir_h3_p,baselines_tables))

baseline_file_prefix = "baseline_"


mainDir = "~/projects/hadaca3/templates/"
# create folder tmp
dir.create(file.path(mainDir, "tmp"), showWarnings = FALSE)
output_path = paste0(mainDir,"tmp/")

start_marker= "### Write programs Here !"


create_base_script <- function(dict, suffix_file){

    for (baseline in ls(dict)){

        baseline_file <- paste0(dir_h3_p,baseline_file_prefix,baseline,suffix_file)
        # print(baseline_file)
        lines_progam_to_add <- readLines(baseline_file)

        lines_templates_files = readLines(paste0(mainDir,"template_starter_kit/","template_submission_script",suffix_file))


        line_number_to_insert <- which(lines_templates_files == start_marker) 

        lines_templates_files =lines_templates_files[-line_number_to_insert]  #remove the line start_maker

        # Insert the new lines at the specified position
        lines_templates_files <- append(lines_templates_files, lines_progam_to_add, after = line_number_to_insert - 1)


        output_files <- paste0(output_path,dict[[baseline]])
        print(paste("output file generated:",output_files))

        # print(lines_templates_files)
        # Write the modified lines back to the file
        writeLines(lines_templates_files, output_files)
    }

}

create_base_script(dict_Phase_0,".R")
create_base_script(dict_Phase_0_py,".py")