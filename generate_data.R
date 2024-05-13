
##Parameters

Seed = 42 

#Number of cells types
k = 5 
#Number of Probes
nb_probes = 30
#number of observations
nb_genes = 200

# cancer_type
cancer_type = "paad"

DEBUG = TRUE

if (exists("Seed")){
    set.seed(seed = Seed)
} 


### Generate proportion matrix A with dim: k*nb_probes

#function to generate proporition for one probe: 
#In order to have have k random numbers that sum to 1 
# we create k random numbers and divide each of them by their sum.
proportion_4_1_probe <-
    function(k){
        m = runif(k,0,1)
    return(m/sum(m))  
}

# A =  matrix(rep(proportion_4_1_probe(k), each=nb_probes), nrow=nb_probes) 
A = replicate(nb_probes,proportion_4_1_probe(k))
if (DEBUG){print(A)}

### Generate reference matrix T with dim:  nb_genes*k


#Function to generate normal data between min and max here 0 and 1. 
rtnorm <- function(n, mean = 0.5, sd = 0.3, min = 0, max = 1) {
    bounds <- pnorm(c(min, max), mean, sd)
    u <- runif(n, bounds[1], bounds[2])
    qnorm(u, mean, sd)
}

# T = matrix(rep(rtnorm(nb_genes ), each=k), nrow=k) 
# T= t(T) 
T = replicate(k,rtnorm(nb_genes ) )
if (DEBUG){print(T)}

### Generate the Bulk matrix D with dim: nb_genes*nb_probes
if (DEBUG){print(cat("dim T:",dim(T),"\ndim A:",dim(A)))} 


D= T%*%A
if (DEBUG){print(cat(D,"\ndim D:",dim(D)))} 


# function to add noise on D matrix
add_noise = function(data, mean = 0, sd = 0.05, val_min = 0, val_max = 1){
  noise = matrix(rnorm(prod(dim(data)), mean = mean, sd = sd), nrow = nrow(data))
  datam = data + noise
  datam[datam < val_min] = data[datam < val_min]
  datam[datam > val_max] = data[datam > val_max]
  return(datam)
}

D = add_noise(D)

if (DEBUG){print("\nD with noise:\n") 
    print (D)} 

### Write the results into rds files.  

dir.create("data/", showWarnings = FALSE)


saveRDS(D, file = "data/public_data_rna.rds")
saveRDS(T, file = "data/ground_truth.rds")
saveRDS(A, file = "data/proportion.rds")

saveRDS(k, file = "data/input_k_value.rds")
saveRDS(cancer_type, file = "data/cancer_type.rds")

###Current data 

if (DEBUG){
    print(readRDS(file = "data/public_data_rna.rds"))
    print(readRDS(file = "data/ground_truth.rds"))
    print(readRDS(file = "data/proportion.rds"))
    print(readRDS(file = "data/cancer_type.rds") )
    print(readRDS(file = "data/input_k_value.rds") )
}