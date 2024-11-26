# FROM mambaorg/micromamba:1.5.8

# # WORKDIR /app


# COPY environment/environment-r.yml .

# RUN micromamba env create -f environment-r.yml && micromamba clean --all --yes


# SHELL ["micromamba", "run", "-n", "h3", "/bin/bash", "-c"]

# RUN echo 'micromamba activate h3' >> ~/.bashrc

# ENV PATH /opt/conda/bin:$PATH





# FROM mambaorg/micromamba:1.5.8
FROM mambaorg/micromamba:2.0.3
RUN micromamba create -n h3_final
# RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn
RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base  python=3.10 r-rmarkdown r-prettydoc r-seurat r-clue r-coda.base r-ggpubr bioconductor-complexheatmap bioconductor-mofa2 r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-fmsb r-BiocManager numpy pandas rpy2 r-combinat scikit-learn
# RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn
# RUN micromamba run -n h3_final pip install smgantt==0.0.5
RUN micromamba clean --all --yes
RUN echo 'micromamba activate h3_final' >> ~/.bashrc
ENV PATH /opt/conda/bin:$PATH


### Participants requested pacakges
## Install R packages
RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r r-nnls r-mixOmics r-RGCCA r-bigsnpr  r-NMF r-fastICA r-ggplot2  r-CCA r-FactoMineR r-seurat r-velocyto.R 
#
RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r  r-monocle3 r-RcppML r-JADE r-tidyverse r-data.table r-ggrepel r-Seurat r-keras r-rstan r-bnlearn r-ranger r-randomForest r-tensorflow  r-glmnet r-tree r-RWeka r-e1071  r-RSNNS r-caret  r-rgenoud r-kernlab r-rpart  r-mlr3 r-BART r-BayesTree  r-gbm r-elasticnet r-ctv r-ggpubr r-dplyr  r-pheatmap  r-future  r-devtools r-assertr r-assertthat


## Intall Pyton packages
# RUN micromamba run -n h3_final micromamba  install -y -c bioconda -c conda-forge pandas, matplotlib, stabilized-ica, numpy, scipy, scanpy, squidpy, anndata, seaborn, torch, torch_geometric, umap-learn, keras, os, libtorch, omicverse, ucdeconvolve, tensorflow,  inmoose, scikit-learn, statsmodels, nltk, request, xgboost, biopython, pytest, pandera, chardet, codecarbon, pyarrow, pytables, openpyxl, coverage, ruff, pyspark, networkx, MOWGLI


SHELL ["micromamba", "run", "-n", "h3_final", "/bin/bash", "-c"]
RUN Rscript -e 'install.packages( pkgs = "zip", repos = "https://cloud.r-project.org")'
RUN Rscript  -e 'BiocManager::install("ComplexHeatmap")'
RUN Rscript  -e 'BiocManager::install("Biobase")'

ENTRYPOINT ["micromamba", "run", "-n", "h3_final"]



USER root
RUN apt-get update && apt-get install -y --fix-missing r-base 
RUN apt-get update && apt-get upgrade -y && apt-get install -y gzip




# mamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat scikit-learn 


## not installed : 
# r-DESeq2 r-ProDenICA
# r-citcdf r-MAST 
# r-scDD r-SigEMD 
# r-summarizedexperiment -> does not exist
# r-consica  -> does not exist
# r-RcppML 
# r-NNLM -> to check !   -> will prevent other library to be installed 
# r-D3E
# r-DESingle
# r-SCDE
# r-parallel 
# r-keras3
# r-rethinking
#  r-torch    r - nnlm ?  r-monocle3 
# r-rminer
# r-DoubleML  r nnlm ? 
 #  r-bartMachine -> r-nnlm 


 # r-tidyverse r-data.table 
# mamba install -y -c bioconda -c conda-forge -c r  r-ggrepel r-Seurat r-keras r-rstan r-bnlearn r-ranger 
# mamba install -y -c bioconda -c conda-forge -c r  r-randomForest r-tensorflow  r-glmnet
# mamba install -y -c bioconda -c conda-forge -c r r-tree r-RWeka r-e1071 
# mamba install -y -c bioconda -c conda-forge -c r  r-RSNNS r-caret 
# mamba install -y -c bioconda -c conda-forge -c r r-rgenoud r-kernlab r-rpart 
# mamba install -y -c bioconda -c conda-forge -c r  r-mlr3 r-BART
# mamba install -y -c bioconda -c conda-forge -c r  r-BayesTree 
# mamba install -y -c bioconda -c conda-forge -c r   r-gbm r-elasticnet
# mamba install -y -c bioconda -c conda-forge -c r   r-ctv r-ggpubr r-dplyr 
# mamba install -y -c bioconda -c conda-forge -c r r-pheatmap  r-future 
# mamba install -y -c bioconda -c conda-forge -c r r-devtools r-assertr r-assertthat






# mamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base python=3.10 r-rmarkdown r-prettydoc r-seurat r-clue r-coda.base r-ggpubr bioconductor-complexheatmap bioconductor-mofa2 r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-fmsb r-BiocManager numpy pandas rpy2 r-combinat scikit-learn