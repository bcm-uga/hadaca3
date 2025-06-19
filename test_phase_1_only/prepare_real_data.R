print('Begining of real data migration')

# # Get the command line arguments
# args <- commandArgs(trailingOnly = TRUE)

# # Print the arguments
# print("arguments are:")
# print(args)

# if (length(args) >=1) {
#     nb_datasets = as.numeric(args[1])
#     print(paste0("The number of datasets to generate is ",toString(nb_datasets)))
# } else {
#     nb_datasets = 2
#     print(paste0("no argument is given, we set the number of datasets to the defaults number: ",nb_datasets))
# }


path_data="~/projects/hadaca3_private/"


# source(paste0(path_data,"datasets.R"))
# cat(datasets, "\n")
datasets = lapply(read.csv(paste0(path_data,"datasets.csv"), header = FALSE, comment.char = "#", col.names = c("datasets", "names_dataset")),trimws)[["datasets"]]


# while (length(datasets) < nb_datasets*2 ){
#     datasets <- c(datasets,datasets)
# }

dir.create("data/", showWarnings = FALSE)

i = 1

### Phase 1 or 2 TODO improve this code
phase =1
for (phase in 1:2){
    for(dataset in datasets){
        # print(dataset)
        mix_dataset_name = paste0('mixes',phase,'_',dataset,'_pdac.rds')
        message("copying ",mix_dataset_name)
        ground_truth_name = paste0('groundtruth',phase,'_',dataset,'_pdac.rds')
        dir_name = paste0("data/",dataset,phase,"/")
        dir.create(dir_name, showWarnings = FALSE)


        file.copy(from = paste0(path_data,"01_mixes/filtered", mix_dataset_name),   # Copy files
            to = paste0(dir_name,mix_dataset_name))

        file.copy(from = paste0(path_data, "01_groundtruth/filtered",ground_truth_name),   # Copy files
            # to = paste0("data/", paste0(i,"/ground_truth_",i,".rds")))
            to = paste0(dir_name,ground_truth_name))

        # paste0("reference_data_","$i",".rds")
        # i = i +1 
        # break
    }
    # break
}

## copy the reference. 
reference_name = "reference_pdac.rds"

dir_name = paste0("data/reference_data/")
dir.create(dir_name, showWarnings = FALSE)

file.copy(from = paste0(path_data, "01_references/filtered",reference_name),   # Copy files
        to = paste0("data/", paste0("/reference_data/",reference_name)))
