# How do I start?           
                           

This section provides you a dataset description and the baseline methods suggested by the organizer

                           
## Data   

**Data source**

TO DO LUCIE

**Data description**

TO DO LUCIE


Reference data for supervised deconvolution is a rds file of a list with the following structure: 

-ref_bulkRNA: Matrix with dimensions 27786 x 5 (gene x cell_type)

-ref_scRNA: List of 3 elements:
    -ref_sc_peng: List of 2 elements:
        counts: dgCMatrix with dimensions 24005 x 4976 (gene x cell)
        metadata: List of 2 elements:
          cell_type: Vector of 4976 elements in c("basal","classic","endo","fibro","immune")
          sample: Vector of 4976 elements in c("N1","N10","N11","N2","N3","N4","N5","N6","N7","N8","N9","T1","T10","T11","T12","T13","T14" "T15","T16","T17","T18","T19","T2","T20","T21","T22","T23","T24","T3","T4","T5","T6","T7","T8","T9")
    
    -ref_sc_baron: List of 2 elements:
        counts: dgCMatrix with dimensions 20125 x 551 (gene x cell) 
        metadata: List of 2 elements:
          cell_type: Vector of 551 elements in c("endo","fibro","immune")
          sample: Vector of 551 elements in c("h_1","h_2","h_3","h_4")
    
    - ref_sc_raghavan: List of 2 elements:
        counts: dgCMatrix with dimensions 18710 x 4953 (gene x cell)
        metadata: List of 2 elements:
          cell_type: Vector of 4953 elements in c("basal","classic","endo","immune")
          sample: Vector of 4953 elements c("met_2")
    
-ref_met: Matrix with dimensions 416830 x 5 (probe x cell_type)


> reference$ref_bulkRNA[1:5,]
               endo       fibro     immune     classic      basal
5S_rRNA  0.00000000  0.00000000 0.00000000  0.12377391 0.24216543
7SK      0.03452479  0.00000000 0.01654273  1.95287720 0.51918127
A1BG     0.10674770 10.27678539 6.19426480  0.16168673 0.08580523
A1BG-AS1 1.19123408  3.84204450 2.88999093  0.01559645 0.00000000
A1CF     0.00000000  0.04385526 0.03356041 34.38164078 0.52449554

> reference$ref_met[1:5,]
                endo     fibro    immune   classic     basal
cg00000029 0.5770137 0.4734866 0.6315287 0.1184762 0.0877167
cg00000109 0.8546109 0.8383937 0.8467374 0.8331711 0.8502325
cg00000165 0.2302060 0.1527960 0.4541206 0.6928373 0.5090004
cg00000236 0.8361639 0.8810673 0.8744915 0.8656830 0.8651425
cg00000321 0.3017272 0.7842141 0.4368221 0.5817505 0.2712210


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
