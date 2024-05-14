
##Parameters
Seed = 42 

DEBUG = FALSE
#Number of cells types  /!\ change also cell_name_list
k = 5 
#Number of Probes
nb_probes = 30
#number of observations
nb_genes = 200
nb_met_sondes = 300

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


cell_name_list =  c("endo" ,   "fibro"  , "immune" , "classic" ,"basal" )

# cancer_type
# cancer_type = "paad"


if (exists("Seed")){
    set.seed(seed = Seed)
} 

#######################################################
### Generate proportion matrix A with dim: k*nb_probes
#######################################################

#function to generate proporition for one probe: 
#In order to have have k random numbers that sum to 1 
# we create k random numbers and divide each of them by their sum.
proportion_4_1_probe <-
    function(k,min=0,max=1){
        m = runif(k,min,max)
    return(m/sum(m))  
}

# A =  matrix(rep(proportion_4_1_probe(k), each=nb_probes), nrow=nb_probes)

create_ground_truth = function(nb_probes,k,min=0,max=1){
    return(replicate(nb_probes,proportion_4_1_probe(k,min,max)))
}

A = create_ground_truth(nb_probes,k)
rownames(A) = cell_name_list

if (DEBUG){print(A)}


#######################################################
### Generate reference matrix T with dim:  nb_genes*k
#######################################################


#Function to generate normal data between min and max here 0 and 1. 
rtnorm <- function(n, mean = 0.5, sd = 0.3, min = 0, max = 1) {
    bounds <- pnorm(c(min, max), mean, sd)
    u <- runif(n, bounds[1], bounds[2])
    qnorm(u, mean, sd)
}

T_met = replicate(k,rtnorm(nb_met_sondes ) )
T_rna = replicate(k,rtnorm(nb_genes, mean = rna_mean, sd= rna_sd, min = rna_min, max=rna_max ) )

colnames(T_met) = cell_name_list
colnames(T_rna) = cell_name_list

if (DEBUG){
    print(head(T_met))
    print(head(T_rna))
    }



#######################################################
### Generate the Bulk matrix D with dim: nb_genes*nb_probes
#######################################################

if (DEBUG){print(cat("dim T:",dim(T_met),"\ndim A:",dim(A)))} 

D_met = T_met%*%A
D_rna = T_rna%*%A

if (DEBUG){
    print(cat(head(D_met),"\ndim D_met:",dim(D_met)))
    print(cat(head(D_rna),"\ndim D_rna:",dim(D_rna)))
    } 


# function to add noise on D matrix
add_noise = function(data, mean = 0, sd = 0.05, val_min = 0, val_max = 1){
  noise = matrix(rnorm(prod(dim(data)), mean = mean, sd = sd), nrow = nrow(data))
  datam = data + noise
  datam[datam < val_min] = data[datam < val_min]
  datam[datam > val_max] = data[datam > val_max]
  return(datam)
}

D_met = add_noise(D_met)
D_rna = add_noise(D_rna)

if (DEBUG){
    print("\nD_rna with noise:\n") 
    print(head(D_rna))
    print("\nD_met with noise:\n") 
    print(head(D_met))
    } 

### Write the results into rds files.  

dir.create("data/", showWarnings = FALSE)

D= list()
D[[name_D_rna]]= D_rna
D[[name_D_met]]= D_met

T = list()
T[[name_T_met]]= T_met
T[[name_T_rna]]= T_rna



saveRDS(D, file = paste0("data/", name_D,".rds"))
saveRDS(T, file = paste0("data/", name_T,".rds"))
saveRDS(A, file = paste0("data/",name_A,".rds"))


### Read data 

if (DEBUG){
    print(readRDS(file = paste0("data/", name_D,".rds")) )
    print(readRDS(file = paste0("data/", name_T,".rds")) )
    print(readRDS(file = paste0("data/",name_A,".rds" )) )
}