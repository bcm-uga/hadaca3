print('Begining of real data migration')

# Get the command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Print the arguments
print("arguments are:")
print(args)

if (length(args) >=1) {
    nb_datasets = as.numeric(args[1])
    print(paste0("The number of datasets to generate is ",toString(nb_datasets)))
} else {
    nb_datasets = 2
    print(paste0("no argument is given, we set the number of datasets to the defaults number: ",nb_datasets))
}


path_data="~/projects/hadaca3_private/"


source(paste0(path_data,"datasets.R"))
print(datasets)
while (length(datasets) < nb_datasets*2 ){
    datasets <- c(datasets,datasets)
}

dir.create("data/", showWarnings = FALSE)

i = 1
for(dataset in datasets){
    mix_dataset_name = paste0('mixes_',dataset,'_pdac.rds')
    ground_truth_name = paste0('groundtruth_',dataset,'_pdac.rds')
    
    dir_name = paste0("data/",i,"/")
    dir.create(dir_name, showWarnings = FALSE)

    file.copy(from = paste0(path_data, mix_dataset_name),   # Copy files
          to = paste0("data/", paste0(i,"/mixes_data_",i,".rds")))

    file.copy(from = paste0(path_data, ground_truth_name),   # Copy files
          to = paste0("data/", paste0(i,"/ground_truth_",i,".rds")))

    # paste0("reference_data_","$i",".rds")
    i = i +1 
}



## copy the reference. 
reference_name = "reference_pdac.rds"

dir_name = paste0("data/reference_data/")
dir.create(dir_name, showWarnings = FALSE)

file.copy(from = paste0(path_data, reference_name),   # Copy files
        to = paste0("data/", paste0("/reference_data/",reference_name)))
