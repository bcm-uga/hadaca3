## Introduction

Cellular heterogeneity in biological samples is a key factor that determines disease progression, but also influences biomedical analysis of samples and patient classification. 

At the molecular level, the cellular composition of tissues is difficult to assess and quantify, as it is hidden within the bulk molecular profiles of samples (average profile of millions of cells), with all cells present in the tissue contributing to the recorded signal. Despite great promise, conventional computational approaches to quantifying cellular heterogeneity from mixtures of cells have encountered difficulties in providing robust and biologically relevant estimates.

Here, our focus will be on reference-based approaches, which are gaining increasing popularity. While each method presents its own set of advantages and limitations, all are inherently constrained by the quality of the reference data employed. We hypothesize that existing algorithms could be enhanced by leveraging multimodal data integration to improve the quality of references.

The objective of the HADACA3 challenge will be **to enhance existing cell-type deconvolution models by integrating multimodal datasets as reference data.**

## Program

**Phase 1:** Toy deconvolution challenge to test the Codabench framework and familiarize with the platform and dataset.

		
**Phase 2:** Estimation of cell type heterogeneity from pancreatic adenocarcinoma matching bulk methylomes and transcriptomes using the following references profiles, for five different cell types (endothelial cells, fibroblasts, immune cells, cancer cells basal-like, cancer cells classic-like) :

- bulk RNA-seq references
- DNAm references 
- single-cell RNA-seq profiles 

**Phase 3:** Auto-migration from phase 2 best methods and evalution on previously unseen validation dataset.
