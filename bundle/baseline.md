The baseline can be found on the `submission_script.R` contained in the `starting_kit`.


We propose a baseline based on [NNLS algorithm](https://en.wikipedia.org/wiki/Non-negative_least_squares). The problem of Non-Negative Least Square (NNLS) is based on the Ordinary Least Squares (OLS) used for linear regression model, with a constraint of positivity on coefficients. In cellular deconvolution context, NNLS refers to the non-negative least square methodology with the added constraint of sum to one on coefficient, since they are considered as proportion of cell type among a sample.

Here is a simple example of code that performs a deconvolution using NNLS (Non-Negative Least Squares) on mixed samples.

		
		prop = apply(mix[idx_feat,], 2, function(b, A) {
			tmp_prop = nnls::nnls(b=b, A=A)$x
			tmp_prop = tmp_prop / sum(tmp_prop) # Sum To One
			return(tmp_prop)
		}, A=ref[idx_feat,])  
		
		
With `A` the reference matrix (`ref`), `b` a bulk vector (a column from the bulk/mixture matrix `mix`) and `prop` the estimation of cell type proportion.


## NNLS multimodal baseline provided in the submission_script.R

We propose a baseline that executes the following steps:

[1] Run the NNLS deconvolution algorithm on RNA mix using bulk RNA-seq reference data to generate an estimate of the proportion matrix.

[2] Run the NNLS deconvolution algorithm on methylation mix using bulk methylation reference data to generate an estimate of the proportion matrix.

[3] Average the two estimates to generate a prediction of the proportion matrix.


