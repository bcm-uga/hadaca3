print('Begining of real data migration')




dic_datasets2short <- list(
  invitro = "VITR" , 
  invivo = "VIVO" , 
  insilicopseudobulk = "SBN5" , 
  insilicodirichletNoDep = "SDN5" , 
  insilicodirichletNoDep4CTsource = "SDN4" , 
  insilicodirichletNoDep6CTsource = "SDN6" , 
  insilicodirichletEMFA = "SDE5" , 
  insilicodirichletEMFAImmuneLowProp = "SDEL" , 
  insilicodirichletCopule =  "SDC5" 
)

path_data="~/projects/hadaca3_private/"


# source(paste0(path_data,"datasets.R"))
datasets = lapply(read.csv(paste0(path_data,"datasets.csv"), header = FALSE, comment.char = "#", col.names = c("datasets", "names_dataset")),trimws)[["datasets"]]

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

        target_mix_dataset_name = paste0('mixes',phase,'_',dic_datasets2short[[dataset]],'_pdac.rds')
        target_ground_truth_name = paste0('groundtruth',phase,'_',dic_datasets2short[[dataset]],'_pdac.rds')

        dir_name = paste0("data/",dic_datasets2short[[dataset]],phase,"/")
        dir.create(dir_name, showWarnings = FALSE)


        # file.copy(from = paste0(path_data,"01_mixes/filtered", mix_dataset_name),   # Copy files
        file.copy(from = paste0(path_data,"01_mixes/", mix_dataset_name),   # Copy files
            to = paste0(dir_name,target_mix_dataset_name))

        file.copy(from = paste0(path_data, "01_groundtruth/",ground_truth_name),   # Copy files
            to = paste0(dir_name,target_ground_truth_name))

    }
}

## copy the reference. 
reference_name = "reference_pdac.rds"

dir_name = paste0("data/reference_data/")
dir.create(dir_name, showWarnings = FALSE)

# file.copy(from = paste0(path_data,"01_references/filtered", reference_name),   # Copy files
file.copy(from = paste0(path_data,"01_references/", reference_name),   # Copy files
        to = paste0("data/", paste0("/reference_data/",reference_name)))



# datasets = c("VITR", "VIVO", "SBN5", "SDN5", "SDN4", "SDN6", "SDE5", "SDEL", "SDC5")


# dir_name = paste0(input, .Platform$file.sep, "ref", .Platform$file.sep)
# groundtruh_list = list.files(dir_name,pattern="groundtruth*")

# # print(groundtruh_list)


# dic_longnames2short =list()

# ground_truth= list()
# score = list()
# for (groundthruth_name in groundtruh_list){
  
#   gt_list = unlist(strsplit(groundthruth_name, "_"))
#   methods_name =  gt_list[2]
#   phase =  substr(gt_list[1], nchar(gt_list[1]), nchar(gt_list[1]))

#   dataset_name = paste0("mixes",phase,"_",methods_name,'_pdac.rds')

#   dic_longnames2short[[dataset_name]] = dic_datasets2short[[methods_name]]