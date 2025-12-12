
FROM mambaorg/micromamba:2.0.3

# COPY environment/env_final_pyr.yml .

# RUN micromamba env create -f env_final_pyr.yml && micromamba clean --all --yes
RUN micromamba env create -n h3_final

# RUN micromamba run -n h3_final micromamba install -y  -c bioconda -c conda-forge -c r r-base python=3.9 r-rmarkdown r-seurat r-clue r-coda.base r-ggpubr bioconductor-complexheatmap bioconductor-mofa2 r-viridis r-magrittr r-dplyr r-nnls graphviz r-tictoc  graphviz python-kaleido tenacity plotly r-bisquerna r-extraDistr r-MASS r-EPIC r-fmsb bioconductor-toast bioconductor-omicade4 r-mixomics r-mixkernel rpy2 scikit-learn keras tensorflow bioconductor-viper bioconductor-ADImpute r-WGCNA r-see r-ggfortify scanpy bioconda::bioconductor-graph  bioconda::r-wgcna  bioconda::bioconductor-edger bioconda::bioconductor-rgraphviz

RUN micromamba run -n h3_final micromamba install -y  -c bioconda -c conda-forge -c r bioconductor-rhdf5 r-base python=3.9 r-rmarkdown r-seurat r-coda.base  bioconductor-complexheatmap r-dplyr r-nnls graphviz  graphviz python-kaleido tenacity plotly scikit-learn keras tensorflow bioconductor-viper r-ggfortify scanpy  bioconda::bioconductor-rgraphviz


RUN micromamba run -n h3_final micromamba clean --all -y


SHELL ["micromamba", "run", "-n", "h3_final", "/bin/bash", "-c"]
RUN Rscript -e 'install.packages( pkgs = "zip", repos = "https://cloud.r-project.org")'

ENTRYPOINT ["micromamba", "run", "-n", "h3_final"]

RUN micromamba run -n h3_final micromamba clean --all -y


USER root
RUN apt-get update && apt-get install -y --fix-missing r-base 
RUN apt-get update && apt-get upgrade -y && apt-get install -y gzip
RUN apt-get autoremove

