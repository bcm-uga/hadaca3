Baseline can be found on the `submission_script.R` contained in the `starting_kit`.

## NNLS baseline

We propose a baseline that executes the following steps:

[1] Run the NNLS deconvolution algorithm on RNA mix using bulk RNA-seq reference data to generate an estimate of the proportion matrix.

[2] Run the NNLS deconvolution algorithm on methylation mix using bulk methylation reference data to generate an estimate of the proportion matrix.

[3] Average the two estimates to generate a prediction of the proportion matrix.
