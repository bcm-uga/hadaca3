## Data source

Public data :  *to be completed later*

Private data :  *to be completed later*

## Data generation

The cell-type proportion matrices (ground truth) are simulated by a Dirichlet distribution. 
Simulated mixes were obtained using a convolution of the cell-type proportion matrix with the reference matrix of the corresponding omic data. 
Finally, Gaussian noise was added to the matrix of convoluted methylation profiles.

       # R function to generate cell-type proportion matrices using Dirichlet distribution
       ground_truth = gtools::rdirichlet(n = n, alpha = alpha) # with n the number of sample to generate, and alpha a vector of targeted proportion
       # Convolution of references and proportion
       mix_rna = reference_rna %*% ground_truth
       # Function to generate gaussian noise
       noise = matrix(rnorm(prod(dim(data)), mean = mean, sd = sd), nrow = nrow(data)) # with data corresponding to the simulated mixes, and mean and standard deviation (sd) representing the parameters of the noise

## Data description

### Phase 1 : 

 *to be completed later*

### Phase 2 : 

- mixes_data.rds, a list of matching DNAmethylation and RNAseq bulk data, for 30 samples

       # read mixes data
       mixes = readRDS("mixes_data.rds")
       dim(mixes$mix_rna)
       [1] 18749    30
       dim(mixes$mix_met)
       [1] 824678     30
  
  
- reference_data.rds, a list of 2 bulk references : RNA and Met and 1 single cell count data and associated metadata  .

       # read reference data
       references = readRDS("reference_data.rds")

       # format of bulk RNA references
       colnames(reference$ref_bulkRNA)
       [1] "endo"    "fibro"   "immune"  "classic" "basal"
       dim(reference$ref_bulkRNA)
       [1] 18749     5

       # format of methylome references
       > colnames(reference$ref_met)
       [1] "endo"    "fibro"   "immune"  "classic" "basal"  
       > dim(reference$ref_met)
       [1] 824678      5

       # format of scRNAseq references


### Phase 3 : 

The validation dataset of phase 3 are ketp private to avoid overfitting.

## Data Download

To download the dataset for this project, follow these steps :

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit`.
