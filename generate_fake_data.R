
print('Begining of fake data generation')

# Get the command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Print the arguments
print("arguments are:")
print(args)

if (length(args) >=1) {
    nb_datasets = as.numeric(args[1])
    print(paste0("The number of datasets to generate is ",toString(nb_datasets)))
} else {
    nb_datasets = 1
    print("no argument is given, we therefor create only one dataset. ")
}

##Parameters
Seed = 42 

DEBUG = FALSE
# DEBUG = TRUE

#Number of cells types  /!\ change also cell_name_list
k = 5 
cell_name_list =  c("endo" ,   "fibro"  , "immune" , "classic" ,"basal" )
#Number of Probes
nb_probes = 30
#number of observations
nb_genes = 200
nb_met_sondes = 300

nb_genes = 20
nb_met_sondes = 30

#Rna expression 
rna_min = 0 
rna_max = 1e6
rna_mean = 5e4
rna_sd = 2e3

##Names 
name_A = 'ground_truth'
name_T = 'reference_data'
name_D = 'mixes_data'

name_T_rna= 'ref_bulkRNA'
name_T_met= 'ref_met'

name_D_met= "mix_met"
name_D_rna= "mix_rna"



# cancer_type
# cancer_type = "paad"


if (exists("Seed")){
    set.seed(seed = Seed)
} 

#######################################################
### Generate proportion (ground_truth) matrix A with dim: k*nb_probes
#######################################################

#function to generate proporition for one probe: 
#In order to have have k random numbers that sum to 1 
# we create k random numbers and divide each of them by their sum.
proportion_4_1_probe <-
    function(k,min=0,max=1){
        m = runif(k,min,max)
    return(m/sum(m))  
}

create_ground_truth = function(nb_probes,k,min=0,max=1){
    A = replicate(nb_probes,proportion_4_1_probe(k,min,max))
    rownames(A) = cell_name_list
    return(A)
}


#######################################################
### Generate reference matrix T with dim:  nb_genes*k
#######################################################


#Function to generate normal data between min and max here 0 and 1. 
rtnorm <- function(n, mean = 0.5, sd = 0.3, min = 0, max = 1) {
    bounds <- pnorm(c(min, max), mean, sd)
    u <- runif(n, bounds[1], bounds[2])
    qnorm(u, mean, sd)
}


create_ref_matrix <- function(k,nb_met_sondes, rna_mean,rna_sd,rna_min,rna_max){
    T_met = replicate(k,rtnorm(nb_met_sondes ) )
    T_rna = replicate(k,rtnorm(nb_genes, mean = rna_mean, sd= rna_sd, min = rna_min, max=rna_max ) )
    colnames(T_met) = cell_name_list
    colnames(T_rna) = cell_name_list

    # if (DEBUG){
    #     print(head(T_met))
    #     print(head(T_rna))
    #     }

    return(list(T_met=T_met,T_rna=T_rna))
}






#######################################################
### Generate the Bulk matrix D with dim: nb_genes*nb_probes
#######################################################

# if (DEBUG){print(cat("dim T:",dim(T_met),"\ndim A:",dim(A)))} 

# function to add noise on D matrix
add_noise = function(data, mean = 0, sd = 0.15, val_min = 0, val_max = 1){
  noise = matrix(rnorm(prod(dim(data)), mean = mean, sd = sd), nrow = nrow(data))
  datam = data + noise
  datam[datam < val_min] = data[datam < val_min]
  datam[datam > val_max] = data[datam > val_max]
  return(datam)
}

create_bulk <- function(Ref_m,A,mean = 0, sd = 0.05, val_min = 0, val_max = 1){
    D_met = Ref_m$T_met%*%A
    D_rna = Ref_m$T_rna%*%A
    D_met = add_noise(D_met)
    print('RNA')
    D_rna = add_noise(D_rna,sd = 1500, val_min = 0, val_max = 100000)
    # if (DEBUG){
    #     print("\nD_met with noise:\n") 
    #     print(head(D_met))
    #     print("\nD_rna with noise:\n") 
    #     print(head(D_rna))
    # } 
    return(list(D_met=D_met,D_rna=D_rna))
}

# 


### Write the results into rds files.  
dir.create("data/", showWarnings = FALSE)
write_to_disk <- function(Ref_m, Bulk_m,dataset_name){
    D= list()
    D[[name_D_rna]]= Bulk_m$D_rna
    D[[name_D_met]]= Bulk_m$D_met

    T = list()
    T[[name_T_met]]= Ref_m$T_met
    T[[name_T_rna]]= Ref_m$T_rna


    dir_name = paste0("data/",dataset_name,'/')

    dir.create(dir_name, showWarnings = FALSE)

    saveRDS(D, file = paste0(dir_name, name_D,"_",dataset_name,".rds"))
    saveRDS(T, file = paste0(dir_name, name_T,"_",dataset_name,".rds"))
    # saveRDS(A, file = paste0(dir_name, name_A,"_",dataset_name,".rds"))
}

write_to_disk <- function(Ref_m, Bulk_m,dataset_name){
    D= list()
    D[[name_D_rna]]= Bulk_m$D_rna
    D[[name_D_met]]= Bulk_m$D_met

    T = list()
    T[[name_T_met]]= Ref_m$T_met
    T[[name_T_rna]]= Ref_m$T_rna


    dir_name = paste0("data/",dataset_name,'/')

    dir.create(dir_name, showWarnings = FALSE)

    saveRDS(D, file = paste0(dir_name, name_D,"_",dataset_name,".rds"))
    saveRDS(T, file = paste0(dir_name, name_T,"_",dataset_name,".rds"))
    # saveRDS(A, file = paste0(dir_name, name_A,"_",dataset_name,".rds"))
}


## Generate the ground truth: 
A = create_ground_truth(nb_probes,k)
dir_name = paste0("data/ground_truth/")
dir.create(dir_name, showWarnings = FALSE)
saveRDS(A, file = paste0(dir_name, name_A,".rds"))

for (dataset_name in 1:nb_datasets){

    dataset_name = toString( dataset_name)
    print(paste0("generating dataset:",dataset_name ))

    Ref_m = create_ref_matrix(k,nb_met_sondes, rna_mean,rna_sd,rna_min,rna_max)
    Bulk_m  =create_bulk(Ref_m,A)

    write_to_disk(Ref_m,Bulk_m,dataset_name)

    if (DEBUG){
        ### re Read data 
        dir_name = paste0("data/",dataset_name,'/')
        print(head(readRDS(file = paste0(dir_name, name_D,"_",dataset_name,".rds")) ))
        print(head(readRDS(file = paste0(dir_name, name_T,"_",dataset_name,".rds"))) )
    }
}

# print(readRDS(file = paste0(dir_name,name_A,".rds" )) )

print('fin du script')

