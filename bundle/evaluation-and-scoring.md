**How is the scoring metric computed?**

The matrix D of shape (N patients, M probes) is provided to the participants (*public data*). 

Participants have to estimate the proportion matrix $A$ given the model D = T A, with T the cell-type profiles (k cell types, M variables) and A the cell-type proportion per patients (N patients, k cell types).

During this benchmark, they have to submit a reproductible script (with their implemented solution) that compute A. 

The **score** (discriminating metric) will be computed on the estimated proportion matrix (matrix $A$). The metric is a combination of row-correlation, column-correlation and mean absolute error between ground truth and estimate.