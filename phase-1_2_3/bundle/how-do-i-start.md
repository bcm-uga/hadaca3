# How do I start?           
                           

This section provides you a dataset description and the baseline methods suggested by the organizer

                           
## Data   

**Data source**

TO DO LUCIE

**Data description**

TO DO LUCIE

The challenge provides bulk mixtures for deconvolution, with two types of mixed omics data available for estimating cell type proportions in these mixtures:

    an RNA-seq data matrix
    a METHepic data matrix.

The corresponding file, `data/mixes_data_1.rds`, contains a list of matching DNAmethylation and RNA-seq bulk data for 30 samples.

Example to load and inspect the data:

```
## read mixture data
 mixes = readRDS("data/mixes_data_1.rds")
       dim(mixes$mix_rna)
       [1] 21104    30
dim(mixes$mix_met)
       [1] 824678     30
```
Additionally, reference matrices are provided, including:

    Bulk RNA-seq references (for pure cell types)
    METHepic references (methylation data for pure cell types)
    Single-cell RNA-seq references

The reference data is contained in the file reference_pdac.rds. This file is a list with the following components:

    2 bulk reference datasets: RNA-seq and Methylation (Met)
    1 single-cell RNA-seq reference dataset, which includes both the data and associated metadata. The single-cell dataset is itself a list of 3 components containing:
        Gene expression data (counts)
        Metadata (cell labels)

The RNA-seq reference data has been normalized using edgeR.

The methylation reference data consists of beta values.

The single-cell RNA-seq data has been processed according to the following steps.

Example to load and inspect the reference data:

```       
## read reference data
       references = readRDS("reference_pdac.rds")

       # format of bulk RNA references
       colnames(reference$ref_bulkRNA)
       [1] "endo"    "fibro"   "immune"  "classic" "basal"
       dim(reference$ref_bulkRNA)
       [1] 21104     5

       # format of methylome references
       > colnames(reference$ref_met)
       [1] "endo"    "fibro"   "immune"  "classic" "basal"  
       > dim(reference$ref_met)
       [1] 824678      5

       # format of scRNAseq references
       > dim(referencerefscRNArefscRNAcounts) # 23376 gene expression for 20146 cells
       [1] 23376      20146
       > dim(referencerefscRNArefscRNAmetadata) # cell labels
       [1] 20146      1
       > table(referencerefscRNArefscRNAmetadata[,1])
       [1] basal classic    endo   fibro  immune 
           2036    2178    8874    3946    3112 
```

In Phase 2, multiple datasets are provided, each with different characteristics. These datasets are labeled as follows:

TO DO HUGO

- `VIVO` : real in vivo bulk samples
- `VITR`: in vitro mixtures of pure cell types
- `SBN5` : in silico simulation of pseudo-bulk from simulated single-cell data, for 5 cell-types
- `SDN4` : in silico simulation, using a Dirichlet distribution, without correlation between features, for 4 cell-types
- `SDN5` : in silico simulation, using a Dirichlet distribution, without correlation between features, for 5 cell-types
- `SDN6` : in silico simulation, using a Dirichlet distribution, without correlation between features, for 6 cell-types
- `SDE5` : in silico simulation, using a Dirichlet distribution, with EMFA correlation, for 5 cell-types
- `SDEL` : in silico simulation, using a Dirichlet distribution, with EMFA correlation, for 5 cell-types including one with very low proportions
- `SDC5` : in silico simulation, using a Dirichlet distribution, with copule correlation, for 5 cell-types

## Baselines                 

TO DO HUGO

A baseline is a simple approach designed to address the problem raised by the challenge â€” in this case, deconvolution. It serves as a straightforward method that is easy to understand and provides a foundation for further improvements.
The starting kit contains 3 baselines.

**submission_script.R** - This baseline uses a non-negative least squares deconvolution algorithm (`nnls::nnls` function) to estimate the mixture composition, for each cell type, and then integrate the two results by averaging them (`mean` function) .

**submission_script_installpkgcran.R** - This script demonstrates how to install a new package from CRAN if needed.

**Submission_script.py** (beta) - This Python script replicates the baseline approach from submission_script.R for Python users. 
