Successful treatment of cancer is still a challenge and this is partly due to a wide heterogeneity of cancer composition across patient population. Unfortunately, accounting for such heterogeneity is very difficult. Clinical evaluation of tumor heterogeneity often requires the expertise of anatomical pathologists and radiologists.

This benchmark is dedicated to the quantification of intra-tumor heterogeneity using appropriate statistical methods on cancer omics data.

In particular, it focuses on estimating cell types and proportion in biological samples based on methylation and transcriptome data sets. The goal is to explore various statistical methods for source separation/deconvolution analysis (Non-negative Matrix Factorization, Surrogate Variable Analysis, Principal component Analysis, Latent Factor Models, …) using both RNA-seq and methylome data.
How to start ?

The goal of the benchmark is to quantify tumor heterogeneity : how many cell types are present and in which proportion?
You are provided with two simulated datasets from the same patient cohort (one transcriptome dataset, one methylone dataset).

**Challenge 1: Estimate cell type heterogeneity from prancreatic transcriptomes**

We assume D is a (MxN) transcriptome matrix composed of transcriptome value for N samples, at M genes. Each sample is constituted of K cell types. We assume the following model: D = T A

with T an unknown (MxK) matrix of K cell type-specific transcriptome reference profiles (composed of M sites), and A an unknown (KxN) proportion matrix composed of K cell type proportions for each sample.

Participants have to identify an estimate of A matrix. Teams are invited to propose inovative methods using RNAseq approaches to estimate A.

*  the transcriptome dataset is composed of 30 patients and 21566 genes, with cell types proportions highly variable between patients.
		
**Challenge 2: Estimate cell type heterogeneity from prancreatic methylomes**

We assume D is a (MxN) methylome matrix composed of methylome value for N samples, at M probes. Each sample is constituted of K cell types. We assume the following model: D = T A

with T an unknown (MxK) matrix of K cell type-specific methylome reference profiles (composed of M sites), and A an unknown (KxN) proportion matrix composed of K cell type proportions for each sample.

Participants have to identify an estimate of A matrix. Teams are invited to propose inovative methods using DNA methylation approaches to estimate A.

*  the methylome dataset is composed of 30 patients and 772316 methylation probes, with cell types proportions highly variable between patients.