# How do I start?           
                           

This section provides you a dataset description and the baseline methods suggested by the organizer

                           
## Data                     
                           
The smoothies (16 vitamine composition of 10 mixtures, embed in the file `mixes_smoothies_fruits.rds`) to be deconvoluted are simulated **in silico** using fruit profiles (vitamine composition of each fruit, embed in the file `reference_fruits.rds`).

```
# read mixture data
mixes_smoothies_fruits = readRDS("mixes_smoothies_fruits.rds")
> dim(mixes_smoothies_fruits)
[1] 16      10
> head(mixes_data)
       recipe1   recipe2   recipe3 ...
vitA  6.650470  6.694573  6.582355 ...
vitB  7.674811  7.655906  7.645350 ...
vitC  8.187849  8.211621  8.135790 ...
 ...       ...       ...       ...

# read reference data
reference_fruits = readRDS("reference_fruits.rds")
> dim(reference_fruits)
[1] 16      10
> head(reference_data)
       Apple     Banan     Orang   ...
vitA  6.539159  6.820179  6.807355 ...
vitB  7.577429  7.607330  7.636625 ...
vitC  8.049849  8.266787  8.312883 ...
...        ...       ...       ... ...
```
                             
## Baselines                 
                           
A baseline is a simple approach designed to address the problem raised by the challenge — in this case, deconvolution. It serves as a straightforward method that is easy to understand and provides a foundation for further improvements.
The starting kit contains 3 baselines.

**submission_script.R** - This baseline uses a linear model (`lm` function) to estimate the fruit composition.
For improved estimation, you can comment line 24 and uncomment line 25 to apply a non-negative least squares deconvolution algorithm (`nnls::nnls` function).

**submission_script_installpkgcran.R** - This script demonstrates how to install a new package from CRAN if needed.

**Submission_script.py** (beta) - This Python script replicates the baseline approach from submission_script.R for Python users. 

                           