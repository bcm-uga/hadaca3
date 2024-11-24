print('Begining of real data migration')


path_data="~/projects/hadaca3_private/"


source(paste0(path_data,"datasets.R"))

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


        file.copy(from = paste0(path_data, mix_dataset_name),   # Copy files
            to = paste0(dir_name,mix_dataset_name))

        file.copy(from = paste0(path_data, ground_truth_name),   # Copy files
            to = paste0(dir_name,ground_truth_name))

    }
}

## copy the reference. 
reference_name = "reference_pdac.rds"

dir_name = paste0("data/reference_data/")
dir.create(dir_name, showWarnings = FALSE)

file.copy(from = paste0(path_data, reference_name),   # Copy files
        to = paste0("data/", paste0("/reference_data/",reference_name)))
