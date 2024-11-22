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
RUN micromamba run -n h3_final micromamba install -y -c anaconda -c bioconda -c conda-forge -c r r-base snakemake=7.32.4 python=3.9 r-rmarkdown r-prettydoc r-seurat r-clue bioconductor-complexheatmap r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-BiocManager numpy pandas rpy2 r-infotheo r-combinat
# RUN micromamba run -n h3_final pip install smgantt==0.0.5
RUN micromamba clean --all --yes
RUN echo 'micromamba activate h3_final' >> ~/.bashrc
ENV PATH /opt/conda/bin:$PATH


### Participants requested pacakges
## Install R packages
RUN micromamba run -n h3_final micromamba install -y -c bioconda -c conda-forge -c r r-nnls r-mixOmics r-RGCCA r-bigsnpr  r-NMF r-fastICA r-ggplot2  r-CCA r-FactoMineR r-seurat r-velocyto.R 
#r-monocle3 r-RcppML 
# r-JADE r-NNLM r-citcdf 
#r-MAST r-scDD r-SigEMD 
#r-DESingle r-SCDE r-D3E r-tidyverse r-data.table r-parallel 
#r-ggrepel r-Seurat r-keras r-rstan r-bnlearn r-ranger r-randomForest r-tensorflow r-keras3 r-rethinking r-glmnet r-torch r-RSNNS r-caret r-rpart r-tree r-RWeka r-e1071 r-rgenoud r-kernlab r-DoubleML r-rminer r-mlr3 r-BART r-bartMachine r-BayesTree r-gbm r-elasticnet r-ctv r-ggpubr r-dplyr r-tidyr r-plotly r-consICA r-pheatmap r-SummarizedExperiment r-future r-devtools r-assertr r-assertthat

## not installed : 
# r-DESeq2 r-ProDenICA




###pandas was not imported uplaoded correctly.  no numpy... wtf...

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




# # Python requirements
# FROM debian:11.0

# RUN apt update --fix-missing

# # # Install anaconda
# # RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
# #     libglib2.0-0 libxext6 libsm6 libxrender1 \
# #     git mercurial subversion
# # RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
# #     wget --quiet https://repo.continuum.io/archive/Anaconda3-2022.05-Linux-x86_64.sh && \
# #     /bin/bash /Anaconda3-2022.05-Linux-x86_64.sh -b -p /opt/conda && \
# #     rm /Anaconda3-2022.05-Linux-x86_64.sh

# # RUN apt-get install -y curl grep sed dpkg tini

# ENV PATH /opt/conda/bin:$PATH
# ENV R_LIBS=/usr/local/lib/R/site-library

# # C#, R, etc. requirements
# RUN apt-get update && apt-get install -y --fix-missing r-base 
# #mono-runtime libgomp1 libc6

# # Fix for 'xgboost' missing
# # RUN conda install libgcc
# #RUN conda install -c conda-forge tensorflow

# # RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" > /etc/apt/sources.list && \
# #     apt-get update 
#     # apt-get -y -t testing install python3.9 python3-pip

# RUN apt-get install gzip
# RUN  apt-get -y install pandoc && apt-get clean && apt-get auto-clean && apt-get -y auto-remove

# # RUN pip3 install \
# #         theano==1.0.5 \
# #         Cython==0.29.30 \
# #         numpy==1.22.4 \
# #         scipy==1.8.1 \
# #         scikit-learn==1.1.1 \
# #         pandas==1.4.2 \
# #         pyyaml==6.0 \
# #         imutils==0.5.4 \
# #         numba==0.55.2 \
# #         tensorflow==2.9.1


# RUN  Rscript -e 'install.packages(pkgs = "BiocManager")'

# RUN  Rscript -e 'BiocManager::install(pkgs = "Biobase")'
# RUN  Rscript -e 'install.packages(pkgs = "zip")'
# RUN Rscript -e 'install.packages(pkgs=c("utf8", "farver", "labeling", "munsell", "R6", "viridisLite", "fansi", "pillar", "pkgconfig", "cli", "glue", "lifecycle", "magrittr", "rlang", "stringi", "vctrs", "iterators", "gtable", "isoband", "scales", "tibble", "withr", "plyr", "Rcpp", "registry", "rngtools", "stringr", "digest", "gridBase", "colorspace", "RColorBrewer", "foreach", "doParallel", "ggplot2", "reshape2"))'
# RUN Rscript -e 'install.packages(pkgs=c("fs", "rappdirs", "base64enc", "cachem", "fastmap", "memoise", "mime", "sass", "highr", "bslib", "evaluate", "fontawesome", "htmltools", "jquerylib", "jsonlite", "knitr", "tinytex", "xfun", "yaml"))'
# RUN Rscript -e 'install.packages(pkgs=c( "combinat",  "rmarkdown", "clue","infotheo"))'

# RUN  Rscript -e 'install.packages(pkgs = "NMF", repos = "https://cloud.r-project.org")'

# RUN Rscript -e 'install.packages(pkgs=c( "bitops",  "caTools", "gplots","viridis"))'

# COPY environment/requirements.txt .

# RUN pip3 install --no-cache-dir -r requirements.txt

