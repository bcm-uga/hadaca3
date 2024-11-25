# Overview                 
                           
Welcome to the *HADACA3* data challenge. 

The *Health Data Challenge (HADACA)* is a series of data challenges aimed at benchmarking deconvolution methods through crowdsourcing. The primary goal is to develop and improve deconvolution methods for biological data.

- The **first edition** took place in 2018, in collaboration with the Data Institute at University Grenoble-Alpes.
- The **second edition** was held in 2019, in partnership with the Ligue contre le Cancer and sponsored by EIT Health.
- The **third edition** is set for December 2024, in collaboration with the M4DI project, part of the PEPR Santé Numérique. Visit the official website for details: http://hadaca3.sciencesconf.org.
    
                           
**Aim of the challenge**     
                           
Cellular heterogeneity in tumors is a key factor that determines disease progression and influences biomedical analysis of samples and patient classification.

At the molecular level, the cellular composition of tissues is difficult to assess and quantify, as it is hidden within the bulk molecular profiles of samples (average profile of millions of cells), with all cells present in the tissue contributing to the recorded signal. Despite great promise, conventional computational approaches to quantifying cellular heterogeneity from mixtures of cells have encountered difficulties in providing robust and biologically relevant estimates.

Here, our focus will be on reference-based approaches, which are gaining increasing popularity. While each method presents its own set of advantages and limitations, all are inherently constrained by the quality of the reference data employed. Our hypothesis is that integrating multimodal data can improve the quality of the reference data and, in turn, enhance the performance of deconvolution algorithms.

The *HADACA3* challenge aims to improve existing cell-type deconvolution models by integrating multimodal datasets as reference data.

**Program**


**Phase 1**: 

- Objective: Estimate cell-type heterogeneity in pancreatic adenocarcinoma using matching bulk methylomes and transcriptomes from reference profiles.

- Dataset: A simulated dataset containing 5 different cell types (endothelial cells, fibroblasts, immune cells, basal-like cancer cells, and classic-like cancer cells).

- Reference Profiles: The following reference data will be provided:

    Bulk RNA-seq references (public pure cell-type transcriptomes).
    DNA methylation (DNAm) references (public pure cell-type methylation arrays).
    Single-cell RNA-seq profiles (public labeled data of cancerous and healthy pancreatic cells).
  
    
**Phase 2**:

- Objective: Same as Phase 1 but with different datasets, including:

        In silico simulations with diverse models, such as correlations between features (genes or CpG probes).
        In silico pseudo-bulk simulations.
        Simulations with missing or additional cell-types.
        In vitro mixtures.
        In vivo samples.

**Phase 3**:

- Objective: Transfer the best methods from Phase 2 and evaluate them on previously unseen validation datasets.

**Tutorial**

There is a playlist of YouTube videos to help you with your first steps on Codabench. 

 <iframe width="840" height="630" style="border:none;" allowfullscreen=""
src="https://www.youtube.com/embed/lvWF-ruQlvw?list=PLU1mBHFYvdQoq74OkE2nIuGv6BpsHv7jj">
</iframe> 

Enjoy the challenge!                           
