# How do I start?           
                           

This section provides you a dataset description and the baseline methods suggested by the organizer

                           
## Data   

**Data source**

- Reference data

The organizer are providing an example of reference data for pdac tissue. 3 reference data are avaibale : bulk RNA-Seq, bulk methylation and single-cell RNA-seq.

    - bulk RNA-Seq
    - bulk methylation
    - single-cell RNA-seq : for the 3 
- 

**Data description**

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
       reference = readRDS("reference_pdac.rds")

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

> reference$ref_scRNA$ref_sc_peng$counts[101:105,101:105]
5 x 5 sparse Matrix of class "dgCMatrix"
              T1_TACAGTGTCAGCTCGG T1_TACCTTATCTCGCTTG T1_TACGGATGTCAGTGGA T1_TACGGGCGTACTTGAC T1_TAGTGGTAGGGAGTAA
KCNAB2                          .                   .                   .                   .                   .
RPL22                          10                   6                   5                   2                  11
RP1-120G22.11                   .                   .                   .                   .                   .
RNF207                          .                   .                   .                   .                   .
ICMT                            .                   .                   .                   .                   .

```

The data has the folloing structure:
```
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


```

In Phase 2, multiple datasets are provided, each with different characteristics. These datasets are labeled as follows:

- `VITR` : *in vitro* mixtures of pure cell types
- `VIVO` : real *in vivo* bulk samples
- `SBN5` : *in silico simulation* of pseudo-bulk from simulated single-cell data, for 5 cell-types
- `SDN5` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 5 cell-types
- `SDN4` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 4 cell-types
- `SDN6` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 6 cell-types
- `SDE5` : *in silico simulation*, using a Dirichlet distribution, with EMFA dependence, for 5 cell-types
- `SDEL` : *in silico simulation*, using a Dirichlet distribution, with EMFA dependence, for 5 cell-types including one with very low proportions
- `SDC5` : *in silico simulation*, using a Dirichlet distribution, with copula dependence, for 5 cell-types


Since `VITR` is an in vitro mixtures, the true proportions of each cell type in each sample are controlled and therefore the ground truth can be assumed to be known.

For the `VIVO` dataset, we don't know the ground truth. However, we have a proxy for the relative proportions of cancer cell types, as measured on histological slides. Since we only have a partial ground truth, we can only compute correlation metrics on the cancer types.

The principle of the `SBN5` pseudo bulk simulation is based on how bulk samples are obtained in reality. The global gene expression or DNA methylation in a bulk sample is from a multitude of heterogeneous cell. Single cell technology can produce gene expression or DNA methylation of one cell, so a *in silico* mixture of such data from different cell population with known proportions of each cell type produce a pseudo-bulk sample.

For all further *in silico* simulated datasets, the ground truth is obtained from a Dirichlet distribution with different set of parameters, chosen to generate a ground truth close to the *in vitro* ground truth. The first data set is a basic simulation procedure with no explicit dependence or correlation introduce between genes and CpG probes. Based on this simple simulation, we produce two other datasets: with only four cell types from reference to generate samples for the first one, and with one more cell type than reference for the second one.

Last three *in silico* simulation introduce dependence structure between genes and CpG probes. These dependences are estimated from the *in vitro* dataset by two different approaches :

- EMFA : We estimate a factor model of the conditionnal variance-covariance matrix of *in vitro* data. The factor model is estimated by an Expectation-Maximisation algorithm (https://doi.org/10.1198/jasa.2009.tm08332)
- Copula : Capolas can caracterise characterise various complex forms of dependence, such as non-linear or tail dependence between multiple variables. We estimate the empirical copula of the residsual between *in vitro* bulk samples and *in vitro* references (https://doi.org/10.18637/jss.v021.i04).

The dataset `SDEL` is derived from the EMFA simulation procedure, but with very low proportion for one cell type.


## Baselines                 

TO DO HUGO

A baseline is a simple approach designed to address the problem raised by the challenge â€” in this case, deconvolution. It serves as a straightforward method that is easy to understand and provides a foundation for further improvements.
The starting kit contains 3 baselines.

**submission_script.R** - This baseline uses a non-negative least squares deconvolution algorithm (`nnls::nnls` function) to estimate the mixture composition, for each cell type, and then integrate the two results by averaging them (`mean` function) .

**submission_script_installpkgcran.R** - This script demonstrates how to install a new package from CRAN if needed.

**Submission_script.py** (beta) - This Python script replicates the baseline approach from submission_script.R for Python users. 
