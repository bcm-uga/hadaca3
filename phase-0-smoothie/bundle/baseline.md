# Baselines

A baseline is a simple approach designed to address the problem at hand—in this case, deconvolution. It serves as a straightforward method that is both easy to comprehend and provides a foundation for further improvements.
The starting kit provides 3 baseslines.

## Submission_script.R 

This baseline uses a linear model (`lm` function) to estimate the fruit composition (`lm` function).
For improved estimation, you can comment out line 24 and uncomment line 25 to apply a non-negative least squares deconvolution algorithm (`nnls::nnls` function).

## submission_script_installpkgcran.py

This script demonstrates how to install a new package if needed.

## Submission_script.py  (Beta)

This Python script replicates the baseline approach from submission_script.R for Python users. 

