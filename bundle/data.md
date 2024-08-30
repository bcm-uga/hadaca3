## Data source

Public data :  

- single-cell RNA-seq reference : BioProject PRJCA001063 (DIOI: 10.1038/s41422-019-0195-y)
  
Private data :  

- bulk RNA-seq reference : COMETH-lot1
- MethEPIC reference : COMETH-lot1
- in vitro mixtures : COMETH-lot1
- in vivo mixtures: COMETH-lot2
  
## Data generation

The mixtures to be deconvoluted are of three types: simulated **in silico**, mixed **in vitro**, or quantified **in vivo** by immunostaining. Several simulation models have been used. For participants wishing to generate their own mixtures for training purposes, here is an example of a simulation model based on a Dirichlet distribution.


In the following example, simulated mixtures were obtained using a convolution of the cell-type proportion matrix with the reference matrix of the corresponding omic data. Finally, Gaussian noise was added to the matrix of convoluted methylation profiles.

       # R function to generate cell-type proportion matrices using Dirichlet distribution
       ground_truth = gtools::rdirichlet(n = n, alpha = alpha) # with n the number of sample to generate, and alpha a vector of targeted proportion
       # Convolution of references and proportion
       mix_rna = reference_rna %*% ground_truth
       # Function to generate gaussian noise
       noise = matrix(rnorm(prod(dim(data)), mean = mean, sd = sd), nrow = nrow(data)) # with data corresponding to the simulated mixes, and mean and standard deviation (sd) representing the parameters of the noise

## Data description

### Phase 0 : 

Phase 0 is open before the challenge begins, allowing participants to become familiar with the platform and the concept of deconvolution. For more information, please visit here the [smoothie challenge](https://www.codabench.org/competitions/3569/?secret_key=d52c599a-c568-481d-aa7f-1e83936325e4).

### Phase 1 : 

During phase 1, an in vitro simulated mixture will be provided for deconvolution. The corresponding file name is `mixes_data.rds` 
Two types of mixed omics data are available to estimate the proportions of cell types in these mixtures: 
- an RNA-seq data matrix
- a METHepic data matrix.

The corresponding file name is `mixes_data.rds`. `mixes_data.rds` is a list of matching DNAmethylation and RNAseq bulk data, for 30 samples.

```
       # read mixes data
       mixes = readRDS("mixes_data.rds")
       dim(mixes$mix_rna)
       [1] 18749    30
       dim(mixes$mix_met)
       [1] 824678     30
```  

Reference matrices are also provided; they include pure lineage references in bulk RNA-seq and METHepic, as well as single-cell RNA-seq references. The corresponding file name is `reference_data.rds`

  
The corresponding file name is `reference_data.rds`. `reference_data.rds` is a list of 2 bulk references : RNA and Met and 1 single cell count data and associated metadata  .

```
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
       > dim(reference$scRNAseq$counts) # 23376 gene expression for 20146 cells
       [1] 23376      20146
       > dim(reference$scRNAseq$metadata) # cell labels
       [1] 20146      1
       > table(reference$scRNAseq$metadata[,1])
       [1] basal classic    endo   fibro  immune 
           2036    2178    8874    3946    3112 
```
  
### Phase 2 : 

Phase 2 is similar to Phase 1 but includes several types of mixtures to be deconvoluted (**in silico**, **in vitro**, and **in vivo**). The same references as in Phase 1 can be used for deconvolution. The mixtures to be deconvoluted are provided to the participants.

### Phase 3 : 

Phase 3 is similar to Phase 2 (same type of mixtures datasets), except that the mixtures are not available to the participants to prevent overfitting. Participants are invited to submit their best method developed in Phase 2 for Phase 3.

## Data Download

To download the dataset for this project, follow these steps :

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit`.
