Baseline can be found on the `submission_script.R` contained in the `starting_kit`.



We proposed differents baselines all using [NNLS algorithm](https://en.wikipedia.org/wiki/Non-negative_least_squares). The problem of non-negative least square (NNLS) is based on the ordinary least squares (OLS) used for linear regression model, with a constraint of positivity on coefficients. In cellular deconvolution context, NNLS refers to the non-negative least square methodology with the added constraint of sum to one on coefficient, since they are considered as proportion of cell type among a sample.


## NNLS baseline

We propose a baseline that executes the following steps:

[1] Run the NNLS deconvolution algorithm only on RNA mix using bulk RNA-seq reference data to generate an estimate of the proportion matrix.

		
		prop = apply(mix[idx_feat,], 2, function(b, A) {
			tmp_prop = nnls::nnls(b=b, A=A)$x
			tmp_prop = tmp_prop / sum(tmp_prop) # Sum To One
			return(tmp_prop)
		}, A=ref[idx_feat,])  
		
		
With `A` the reference matrix (`ref`), `b` a bulk vector (a column from the bulk/mixture matrix `mix`) and `prop` the estimation of cell type proportion.


## NNLS multimodal baseline

We propose a baseline that executes the following steps:

[1] Run the NNLS deconvolution algorithm on RNA mix using bulk RNA-seq reference data to generate an estimate of the proportion matrix.

[2] Run the NNLS deconvolution algorithm on methylation mix using bulk methylation reference data to generate an estimate of the proportion matrix.

[3] Average the two estimates to generate a prediction of the proportion matrix.


## NNLS single-cell RNA baseline

We propose a baseline that executes the following steps:

[1] Aggregate single-cell data by averaging counts by gene to each cell type

[2] Run the NNLS deconvolution algorithm on RNA mix using the latter aggregated cingle-cell reference data to generate an estimate of the proportion matrix.


		
		ref_scRNA_centro = as.matrix(t(apply(ref_scRNA$counts, 1, function(x) {tapply(x, ref_scRNA$metadata, mean)})))
		



## NNLS multimodal source baseline

We propose a baseline that executes the following steps:

[1] Run the NNLS deconvolution algorithm on RNA mix using bulk RNA-seq reference data to generate an estimate of the proportion matrix.

[2] Select Only CpG's probes attached to a gene thanks to `probe_features.rds` (`source("baseline_scripts/link_gene_CpG.R")`).

[3] Run the NNLS deconvolution algorithm on the latter methylation mix subset using bulk methylation reference data to generate an estimate of the proportion matrix.

[4] Average the two estimates to generate a prediction of the proportion matrix.


		probes_feature = probes_feature[probes_feature$gene != "", ]
		
		
