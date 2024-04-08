## Stage 'base' : starting Docker image
FROM debian:unstable
# FROM debian:unstable as base
# FROM r-base:latest
# FROM raphbacher/codalabsurvival

## Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV R_LIBS=/usr/local/lib/R/site-library

## System
# RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN  apt-get -y	update && apt-get -y upgrade && apt-get -y install apt-utils 
# RUN apt-get -y install curl python python-setuptools
RUN apt-get -y install curl python3-pip  python-wheel r-base libcurl4-openssl-dev libgsl-dev libssh2-1-dev libssl-dev libxml2-dev && apt-get clean && apt-get auto-clean && apt-get -y auto-remove
RUN  apt-get -y install pandoc && apt-get clean && apt-get auto-clean && apt-get -y auto-remove

## Stage 'pythonPackages' : Python packages
# FROM base as pythonPackages

RUN  pip install mofapy mofapy2 pandas sklearn umap

## Stage 'rBase' : R base packages
# FROM pythonPackages as rBasePackages

RUN  Rscript -e 'install.packages(pkgs = c("devtools", "remotes", "BiocManager"), repos = "https://cloud.r-project.org"); update.packages(ask = FALSE); BiocManager::install(ask = FALSE); remotes::update_packages(upgrade = "always")'

## Stage 'rPackages' : R packages
# FROM rBasePackages as rPackages

RUN  Rscript -e 'install.packages(pkgs = "ade4", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "Biobase")'
RUN  Rscript -e 'BiocManager::install(pkgs = "biomaRt")'
RUN  Rscript -e 'devtools::install_github(repo = "andquintero/bratwurst", ref = "dev_hdsu", upgrade = "always")' ## NMF package from the laboratory of doncevic@stud.uni-heidelberg.de
RUN  Rscript -e 'install.packages(pkgs = "caret", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "CellMixS")'
RUN  Rscript -e 'BiocManager::install(pkgs = "cellTree")'
# RUN  Rscript -e 'install.packages(pkgs = "CIBERSORT")' ## Licence required : https://github.com/jason-weirather/CIBERSORT
RUN  Rscript -e 'BiocManager::install(pkgs = c("ComplexHeatmap", "ConsensusClusterPlus") )'
RUN  Rscript -e 'install.packages(pkgs = c("circlize", "ClassDiscovery", "cluster", "combinat", "cowplot", "data.table", "DataExplorer"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "UrszulaCzerwinska/DeconICA", upgrade = "always")'
RUN  Rscript -e 'BiocManager::install(pkgs = "DeconRNASeq")'
RUN  Rscript -e 'devtools::install_github(repo = "rosedu1/deconvSeq", upgrade = "always")'
RUN  Rscript -e 'BiocManager::install(pkgs = "DESeq2")'
RUN  Rscript -e 'install.packages(pkgs = c("doMC", "dplyr", "dynamicTreeCut", "e1071"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "BRL-BCM/EDec", upgrade = "always")'
RUN  Rscript -e 'BiocManager::install(pkgs = "edgeR")'
RUN  Rscript -e 'BiocManager::install(pkgs = "EpiDISH")'
RUN  Rscript -e 'install.packages(pkgs = c("elasticnet", "enrichR", "factoextra", "FactoMineR", "fastICA", "flashClust", "foreach"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("gage", "gageData", "GenomicFeatures", "GenomicRanges", "GEOquery", "fgsea") )'
RUN  Rscript -e 'install.packages(pkgs = c("ggcorrplot", "ggExtra", "ggfortify", "ggmosaic", "ggplot2", "ggpubr", "ggrepel", "ggsignif", "ggthemes", "glmnet", "gplots", "gProfileR"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("goProfiles", "GSVA", "impute") )'
RUN  Rscript -e 'install.packages(pkgs = c("gridExtra", "gtools", "heatmap.plus", "heatmaply"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "ica", repos = "https://cloud.r-project.org")' ## repos = "https://CRAN.R-project.org/package=ica"
RUN  Rscript -e 'remotes::install_github("icbi-lab/immunedeconv", upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "InfiniumPurify", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "IRanges")'
RUN  Rscript -e 'install.packages(pkgs = "JADE", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "janitor", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "leaps", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "limma")'
RUN  Rscript -e 'install.packages(pkgs = "limSolve", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "ERGlass/lrcde.dev", build_vignettes = TRUE, upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "lsei", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "lumi")'
RUN  Rscript -e 'remotes::install_github("ebecht/MCPcounter",ref="master", subdir="Source", upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "MASS", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "Matrix", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "matrixStats", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "bcm-uga/medepir", upgrade = "always")'
RUN  Rscript -e 'BiocManager::install(pkgs = "MineICA")'
RUN  Rscript -e 'BiocManager::install(pkgs = "minfi")'
# RUN  Rscript -e 'install.packages(pkgs = "mixOmics", repos = "https://cloud.r-project.org")' ## NOT AVAILABLE FOR R 3.6.1
RUN  Rscript -e 'install.packages(pkgs = "mlr", repos = "https://cloud.r-project.org")'
# RUN  Rscript -e 'devtools::install_github(repo = "bioFAM/MOFA", build_opts = c("--no-resave-data"), upgrade = "always")' ## REQUIRED : mofapy (python)
RUN  Rscript -e 'BiocManager::install(pkgs = "MOFA")'
RUN  Rscript -e 'devtools::install_github(repo = "bioFAM/MOFA2/MOFA2", build_opts = c("--no-resave-data --no-build-vignettes"), upgrade = "always")' ## REQUIRED : mofapy2 (python)
RUN  Rscript -e 'devtools::install_github(repo = "xuranw/MuSiC", upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "NMF", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "NNLM", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "nnls", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "org.Hs.eg.db")'
RUN  Rscript -e 'install.packages(pkgs = "outliers", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "party", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "gdurif/pCMF", subdir="pkg", ref="prod", upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "pheatmap", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "piano")'
RUN  Rscript -e 'install.packages(pkgs = "plotrix", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "plsgenomics")'
RUN  Rscript -e 'install.packages(pkgs = "plyr", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "preprocessCore")'
RUN  Rscript -e 'install.packages(pkgs = "PresenceAbsence", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "quadprog", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "randomForest", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "RColorBrewer", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "RefFreeEWAS", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "reshape", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "reshape2", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "rGREAT")'
RUN  Rscript -e 'install.packages(pkgs = "rio", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "rmarkdown", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "rnaseqGene")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("RnBeads", "RnBeads.hg19", "RnBeads.mm10", "RnBeads.hg38"), dependencies = TRUE, quiet = TRUE)'

RUN  Rscript -e 'install.packages(pkgs = "scales", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("scater", "SCnorm", "scran") )'
RUN  Rscript -e 'install.packages(pkgs = "Seurat", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "SingleCellExperiment")'
RUN  Rscript -e 'BiocManager::install(pkgs = "SingleR")'
RUN  Rscript -e 'install.packages(pkgs = "stringr", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "SummarizedExperiment")'
RUN  Rscript -e 'BiocManager::install(pkgs = "survcomp")'
RUN  Rscript -e 'install.packages(pkgs = "survival", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "survminer", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = "sva")'
RUN  Rscript -e 'BiocManager::install(pkgs = "TCGAbiolinks")'
RUN  Rscript -e 'devtools::install_github(repo = "jinghan1018/tensorICA", upgrade = "always")'
RUN  Rscript -e 'install.packages(pkgs = "tibble", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "tidylog", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "tidyverse", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("topGO", "TxDb.Hsapiens.UCSC.hg19.knownGene") )'
RUN  Rscript -e 'install.packages(pkgs = "umap", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "UpSetR", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "viridis", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'install.packages(pkgs = "WGCNA", repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'devtools::install_github(repo = "cit-bioinfo/WISP", upgrade = "always")'
RUN  Rscript -e 'BiocManager::install(pkgs = "affy"); devtools::install_github(repo = "fchuffar/epimedtools", upgrade = "always")'
RUN  Rscript -e 'devtools::install_github(repo = "lutsik/MeDeCom", ref = "devel", upgrade = "always")' ## REQUIRED : RnBeads
RUN  Rscript -e 'devtools::install_github(repo = "lutsik/FactorViz", upgrade = "always")' ## REQUIRED : MedeCom, RnBeads
RUN  Rscript -e 'devtools::install_github(repo = "lutsik/DecompPipeline", upgrade = "always")' ## REQUIRED : 'MeDeCom', 'RnBeads'
RUN  Rscript -e 'devtools::install_github(repo = "ctlab/linseed")'

RUN pip install --upgrade tensorflow==2.0.0-alpha0 numpy
RUN  Rscript -e 'install.packages(pkgs = c("Rtsne", "kableExtra", "fpc", "rngtools"), repos = "https://cloud.r-project.org")'
RUN  Rscript -e 'BiocManager::install(pkgs = c("rtracklayer", "BiocParallel", "GSEABase", "GenomicInteractions", "EnsDb.Hsapiens.v75", "Homo.sapiens", "ggbio", "YAPSA") )'
RUN  Rscript -e 'BiocManager::install(pkgs = "csSAM"); install.packages(pkgs = "http://bioconductor.org/packages/3.7/bioc/src/contrib/BiocInstaller_1.30.0.tar.gz", type = "source"); install.packages(pkgs = "http://web.cbio.uct.ac.za/~renaud/CRAN/src/contrib/CellMix_1.6.2.tar.gz", type = "source")'