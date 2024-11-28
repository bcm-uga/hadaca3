FROM mambaorg/micromamba:2.0.3
# RUN micromamba create -n h3_final
# # RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn
# RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base  python=3.10 r-rmarkdown r-prettydoc r-seurat r-clue r-coda.base r-ggpubr bioconductor-complexheatmap bioconductor-mofa2 r-viridis r-magrittr r-dplyr r-nnls r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-fmsb r-BiocManager numpy pandas rpy2 r-combinat scikit-learn
# # RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn
# # RUN micromamba run -n h3_final pip install smgantt==0.0.5
# RUN micromamba clean --all --yes
# RUN echo 'micromamba activate h3_final' >> ~/.bashrc
# ENV PATH /opt/conda/bin:$PATH


# ### Participants requested pacakges
# ## Install R packages
# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r r-nnls r-mixOmics r-RGCCA r-bigsnpr  r-NMF r-fastICA r-ggplot2  r-CCA r-FactoMineR r-seurat r-velocyto.R 
# #


# RUN micromamba run -n h3_final micromamba clean --all -y


# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r  r-monocle3 r-RcppML  
# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r r-data.table r-ggrepel r-keras  r-JADE 
# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r  r-rstan r-bnlearn r-ranger r-randomForest r-tensorflow  
# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r  r-glmnet r-tree r-RWeka r-e1071  r-RSNNS r-caret  r-rgenoud r-kernlab 
# RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r  r-rpart  r-mlr3 r-BART r-BayesTree  r-gbm r-elasticnet r-ctv r-ggpubr r-dplyr  r-pheatmap  r-future  r-devtools r-assertr r-assertthat


# ## Intall Pyton packages
# RUN micromamba run -n h3_final micro mamba  install -y -c bioconda -c conda-forge pandas matplotlib scipy scanpy squidpy anndata seaborn   umap-learn 
# RUN micromamba run -n h3_final micromamba  install -y -c bioconda -c conda-forge  keras libtorch omicverse tensorflow  inmoose statsmodels nltk request xgboost 
# RUN micromamba run -n h3_final micromamba  install -y -c bioconda -c conda-forge  biopython pytest pandera chardet codecarbon pyarrow pytables openpyxl coverage ruff pyspark networkx 







COPY environment/env_final_pyr.yml .

RUN micromamba env create -f env_final_pyr.yml && micromamba clean --all --yes



RUN micromamba run -n h3_final micromamba clean --all -y











SHELL ["micromamba", "run", "-n", "h3_final", "/bin/bash", "-c"]
RUN Rscript -e 'install.packages( pkgs = "zip", repos = "https://cloud.r-project.org")'
RUN Rscript  -e 'BiocManager::install("ComplexHeatmap")'
RUN Rscript  -e 'BiocManager::install("Biobase")'

ENTRYPOINT ["micromamba", "run", "-n", "h3_final"]

RUN micromamba run -n h3_final micromamba clean --all -y


USER root
RUN apt-get update && apt-get install -y --fix-missing r-base 
RUN apt-get update && apt-get upgrade -y && apt-get install -y gzip
RUN apt-get autoremove



# mamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn 


## not installed : 
# r-DESeq2 
# r-ProDenICA
# r-citcdf 
# r-MAST 
# r-scDD 
# r-SigEMD 
# r-summarizedexperiment -> does not exist
# r-consica  -> does not exist
# r-RcppML 
# r-NNLM    -> will prevent other library to be installed 
# r-D3E
# r-DESingle
# r-SCDE
# r-parallel 
# r-keras3
# r-rethinking
# r-torch ->    r - nnlm ?  r-monocle3 
# r-rminer
# r-DoubleML  r nnlm ? 
#  r-bartMachine -> r-nnlm 
# r-tidyverse

## not installed python 
# stabilized-ica
# torch
#torch_geometric
# ucdeconvolve
#  MOWGLI

