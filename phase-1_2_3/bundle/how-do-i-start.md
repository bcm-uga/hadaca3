# How do I start?           
                           

This section will give you a description of the dataset and baseline methods suggested by the organizers.

                           
## Data   


### Provided cell population reference data


The organizers provide cell population reference profiles for PDAC (pancreatic cancer). Three reference datasets are available: **bulk RNAseq of isolated cell populations, bulk methylation profiles of isolated cell populations and single-cell RNAseq**. All references are using publicly available data. Each reference type contains 5 cell types: immune cells (immune), fibroblasts (fibro), endothelial cells (endo), and classical (classic) and basal-like (basal) tumor cells. 

  \- **bulk RNAseq cell populations**:  immune cells and fibroblasts transcriptomic profiles were retrieved from the GTEx Analysis V10 ([GTEx portal](https://www.gtexportal.org/home/downloads/adult-gtex/bulk_tissue_expression), link to paper [1](https://www.liebertpub.com/doi/full/10.1089/bio.2015.0032) [2](https://www.nature.com/articles/ng.2653)), endothelial cell transcriptomic profiles were retrieved from GEO [GSE135123](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE135123) (link to [paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC6890669/)). Basal-like and classical tumor cell transcriptomic profiles were retrieved from [this paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC6082139/). **Preprocess**: this reference data has been normalized using edgeR.

  
  \- **bulk methylation profiles of cell populations**: Immune and fibroblasts methylation profiles cells were retrieved from [link to paper](from https://doi.org/10.1186/s12859-021-04381-4). Endothelial cell methylation profiles were retrieved from [GSE82234](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE82234), [link to paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC5242294/).
Basal-like and classical cells methylation profiles were retrieved from [this paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC6082139/). **Preprocess**: this reference dataset consists of aggregated beta value profiles without specific batch effect correction.

  \- **single-cell RNAseq**: 3 datasets were retrieved. For Peng et al. the 5 cell types are present (link to [paper](https://www.nature.com/articles/s41422-019-0195-y) and [download](https://ngdc.cncb.ac.cn/gsa/browse/CRA001160)). For Baron et al. only endothelial, immune and fibroblast population are present (link to [paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC5228327/#S26title) and [download](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE84133)). For Raghavan et al, basal-like, classical, endothelial and immune cell populations are present (link to [paper](https://www.cell.com/cell/fulltext/S0092-8674(21)01332-5?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS0092867421013325%3Fshowall%3Dtrue) and [download](https://singlecell.broadinstitute.org/single_cell/study/SCP1644/microenvironment-drives-cell-state-plasticity-and-drug-response-in-pancreatic-cancer)). **Preprocess**: this reference dataset consists of aggregated beta value profiles without specific batch effect correction.


All references are contained in the file `data/reference_pdac.rds`. This object is a list with the following elements:

  \- **ref_bulkRNA**: bulk RNAseq pure cell populations
  
  \- **ref_met**: bulk methylation profiles of pure cell populations
  
  \- **ref_scRNA**: single-cell RNAseq reference datasets from 3 differents studies; Peng, Baron and Raghavan, each including the data (counts) and associated metadata, i.e. the sample and the cell type.

Example to load and inspect the reference data:

```       
## read reference data
> reference = readRDS("data/reference_pdac.rds")
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

> names(reference$ref_scRNA)
[1] "ref_sc_peng"     "ref_sc_baron"    "ref_sc_raghavan"

> reference$ref_scRNA$ref_sc_peng$counts[101:105,1:5]
5 x 5 sparse Matrix of class "dgCMatrix"
              T1_AAAGTAGAGTCGTACT T1_AAGACCTGTCTGGTCG T1_AAGCCGCCAGTAAGAT T1_AAGTCTGAGCAAATCA T1_AATCCAGTCTCCTATA
KCNAB2                          .                   .                   .                   .                   .
RPL22                           2                   6                   5                   9                   2
RP1-120G22.11                   .                   .                   .                   .                   .
RNF207                          .                   .                   .                   .                   .
ICMT                            1                   .                   .                   .                   .

> reference$ref_scRNA$ref_sc_peng$metadata[1:5,]
                    cell_type sample
T1_AAAGTAGAGTCGTACT    immune     T1
T1_AAGACCTGTCTGGTCG      endo     T1
T1_AAGCCGCCAGTAAGAT      endo     T1
T1_AAGTCTGAGCAAATCA    immune     T1
T1_AATCCAGTCTCCTATA     fibro     T1


```


### Bulk mixture data to deconvolve (PHASE 1)
  
The bulk mixture dataset contains DNA methylation and RNAseq data for 30 matched samples. Each bulk sample is a mixture of the 5 cell populations: immune cells (immune), fibroblasts (fibro), endothelial cells (endo), and classical (classic) and basal-like (basal) cancer cells. This dataset consist of in silico simulation using a Dirichlet distribution, with correlation between features, for 5 cell types.

Each mixture is a list of 2 elements:

```
- mix_rna: Matrix with dimension nb_genes x 30 (gene x sample)
- mix_met: Matrix with dimension nb_probes x 30 (probe x sample)
```

Example to load and inspect the data:
```
## read mixture data
> mixes = readRDS("data/mixes1_insilicodirichletEMFA_pdac.rds")
> dim(mixes$mix_rna)
    [1] 15908    30
> dim(mixes$mix_met)
    [1] 23724    30
> mixes$mix_rna[1:5,1:5]
                [,1]        [,2]       [,3]       [,4]        [,5]
A1BG      175.672119  192.545376 159.730514 178.485733  222.423391
A1BG-AS1  267.621892  260.162802 141.181363 208.780955  289.865525
A1CF        2.366686    6.427183   7.452182   4.166786    2.354932
A2M      1188.737986 1555.621759 945.910236 822.971807 2455.294006
A2M-AS1    16.578611   15.646713  13.846738  14.359070   16.605442
> mixes$mix_met[1:5,1:5]
                 [,1]       [,2]       [,3]      [,4]       [,5]
cg00000109 0.75610815 0.74979232 0.75328176 0.7513898 0.77448260
cg00000165 0.05747755 0.06266522 0.02914655 0.0528465 0.04592764
cg00000236 0.77793411 0.78411988 0.73972585 0.7964341 0.78363719
cg00000321 0.55275824 0.51767339 0.51584411 0.6112040 0.47065240
cg00000363 0.39013598 0.44852883 0.48662104 0.4155861 0.46907377
```


### Bulk mixture data to deconvolve (PHASE 2)

In Phase 2, multiple datasets are provided, each with different characteristics. These datasets are labelled as follows:

- `VITR` : *in vitro* mixtures of pure cell types
- `VIVO` : real *in vivo* bulk samples
- `SBN5` : *in silico simulation*, pseudo-bulk from simulated single-cell data, for 5 cell types
- `SDN5` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 5 cell types
- `SDN4` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 4 cell types
- `SDN6` : *in silico simulation*, using a Dirichlet distribution, without correlation between features, for 6 cell types
- `SDE5` : *in silico simulation*, using a Dirichlet distribution, with EMFA dependence, for 5 cell types
- `SDEL` : *in silico simulation*, using a Dirichlet distribution, with EMFA dependence, for 5 cell types including one with very low proportions
- `SDC5` : *in silico simulation*, using a Dirichlet distribution, with copula dependence, for 5 cell types

Since `VITR` is an *in vitro* mixture, the true proportions for each cell type in each sample are controlled and therefore the ground truth can be assumed to be reliable.

For the `VIVO` dataset, we do not know the ground truth. However, we have a proxy for the relative proportions of the cancer cell types, as measured on histological slides. Since we have a partial ground truth, we can only compute correlation metrics on the cancer types.

The principle of the `SBN5` pseudo-bulk simulation is based on how bulk samples are sequenced in real life. The global gene expression or DNA methylation in a bulk sample is measured from a multitude of heterogeneous cells. Single-cell technology measures gene expression or DNA methylation in one cell, so an *in silico* mixture of single-cell data of different cell types in known proportions produces a pseudo-bulk sample.

For all further *in silico* simulated datasets, the ground truth is generated based on a Dirichlet distribution with different sets of parameters, chosen to generate proportions close to the *in vitro* ones. The first dataset `SDN5` is a basic simulation with no explicit dependence or correlation introduced between genes and CpG probes. Based on this simple simulation, we produced two other datasets: one with only 4 cell types `SDN4`, and one with 6 cell types `SDN6`, while there are 5 cell types in the reference used for the reference-based deconvolution.

The last 3 *in silico* simulations introduce a dependence structure between genes and CpG probes. These dependences are estimated from the *in vitro* dataset by two different approaches:

- EMFA `SDE5` : We estimate a factor model of the conditionnal variance-covariance matrix in the *in vitro* data. The factor model is estimated by an Expectation-Maximisation algorithm (https://doi.org/10.1198/jasa.2009.tm08332)
- Copula `SDC5`: Copulas characterise the type of dependence, such as non-linear or tail dependence, between multiple variables. We estimate the empirical copula of the residuals between *in vitro* bulk samples and *in vitro* references (https://doi.org/10.18637/jss.v021.i04).

The dataset `SDEL` is derived from the EMFA simulation procedure, but with very low proportion for one cell type.


## Baselines                 

A baseline is a simple approach designed to address the problem raised by the challenge, in this case multi-omic deconvolution. It serves as a straightforward method that is easy to understand and provides a foundation for further improvements.
The starting kit contains 5 baselines.

**submission_script.R** - This baseline uses a non-negative least squares deconvolution algorithm (`nnls::nnls` function) to estimate the mixture composition, for each cell type, of from transcriptomic data.

**submission_script_nnlsmultimodal.R** - This baseline uses a non-negative least squares deconvolution algorithm (`nnls::nnls` function) to estimate the mixture composition, for each cell type, and then integrate the two results by averaging them (`mean` function).

**submission_script_nnlsmultimodalSource.R** - This script demonstrates how to source an other script R or rds file if needed.

**submission_script_installpkgcran.R** - This script demonstrates how to install a new package from CRAN if needed.

**Submission_script.py** (beta) - This Python script replicates the baseline approach from submission_script.R for Python users.  
