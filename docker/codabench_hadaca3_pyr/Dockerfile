# Python requirements
# FROM debian:11.0
FROM mambaorg/micromamba:1.5.8

# WORKDIR /app


COPY environment/environment-r.yml .

RUN micromamba env create -f environment-r.yml && micromamba clean --all --yes


SHELL ["micromamba", "run", "-n", "h3", "/bin/bash", "-c"]

# RUN echo 'source /opt/conda/etc/profile.d/conda.sh && micromamba activate h3' >> ~/.bashrc
RUN echo 'micromamba activate h3' >> ~/.bashrc



ENV PATH /opt/conda/bin:$PATH
ENV R_LIBS=/usr/local/lib/R/site-library


ENTRYPOINT ["micromamba", "run", "-n", "h3"]

USER root
RUN apt-get update && apt-get upgrade -y && apt-get install -y gzip
# USER 1001