

args <- commandArgs(trailingOnly = TRUE)
print(length(args))
print(args)
if (length(args) >=1) {
    Phase = args[1]
} else {
    Phase = "Phase_0"
}

print(Phase)

dir_h3_p = "~/projects/hadaca3_private/"
baselines_tables = 'starter_kit_baselines.R'

#  read the baselines to implement the dictionnary for each phase. 
source(paste0(dir_h3_p,baselines_tables))

baseline_file_prefix = "baseline_"


# mainDir = paste0("~/projects/hadaca3/templates/",Phase,"/")
mainDir = "~/projects/hadaca3/templates/"
# create folder tmp
dir.create(file.path(mainDir, "tmp"), showWarnings = FALSE)
output_path = paste0(mainDir,"tmp/")

start_marker= "### Write programs Here !"


copy_file <- function(file){
    file_to_take = file.path(dir_h3_p,file)
    target = file.path(output_path,file)
    file.copy( file_to_take ,target,overwrite =TRUE)
}

create_base_script <- function(dict_name, suffix_file){

    dict = get(dict_name)
    for (baseline in ls(dict)){

        baseline_file <- paste0(dir_h3_p,baseline_file_prefix,baseline,suffix_file)
        # print(baseline_file)
        lines_progam_to_add <- readLines(baseline_file)
        
        Phase_dir = "Phase_1_2_3"
        if(Phase =="Phase_0"){Phase_dir= Phase}

        lines_templates_files = readLines(paste0(mainDir,"template_starter_kit/",Phase_dir,"/template_submission_script",suffix_file))


        line_number_to_insert <- which(lines_templates_files == start_marker) 

        lines_templates_files =lines_templates_files[-line_number_to_insert]  #remove the line start_maker

        # Insert the new lines at the specified position
        lines_templates_files <- append(lines_templates_files, lines_progam_to_add, after = line_number_to_insert - 1)


        output_files <- paste0(output_path,dict[[baseline]])
        print(paste("output file generated:",output_files))

        # print(lines_templates_files)
        # Write the modified lines back to the file
        writeLines(lines_templates_files, output_files)

        if(identical(baseline,"nnlsmultimodalSource") )  {
            dir.create(file.path(output_path, "attachement/"), showWarnings = FALSE)
            for ( file in c("attachement/link_gene_CpG.R","attachement/probes_features.rds")     ){
                copy_file(file)
            }
        }
        if(identical(suffix_file,".py"))  {
            dir.create(file.path(output_path, "attachement/"), showWarnings = FALSE)
            for ( file in c("attachement/additionnal_script.py")     ){
                copy_file(file)
            }
        }
    }
}

# create_base_script(dict_Phase_0,".R")
# create_base_script(dict_Phase_0_py,".py")

dict_name_R = paste0("dict_",Phase)
dict_name_py = paste0("dict_",Phase,"_py")

create_base_script(dict_name_R,".R")
create_base_script(dict_name_py,".py")