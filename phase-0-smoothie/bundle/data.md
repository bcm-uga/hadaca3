
## Data overview

The smoothies (16 vitamine composition of 10 mixtures) to be deconvoluted are simulated **in silico** using fruit profiles (vitamine composition of each fruit).
The aim of the challenge is to find the recipie of each smoothie (i.e. the exact fruit composition)

## Dataset description


- `mixes_smoothies_fruits.rds`, a list of vitamine profile for each mixture (i.e. smoothie)
```
       # read mixture data
       mixes_smoothies_fruits = readRDS("mixes_smoothies_fruits.rds")
        > dim(mixes_smoothies_fruits)
       [1] 16      10
       > head(mixes_data)
              recipe1   recipe2   recipe3   recipe4   recipe5   recipe6   recipe7   recipe8   recipe9  recipe10
       vitA  6.650470  6.694573  6.582355  6.677148  6.643805  6.704423  6.591504  6.673194  6.668364  6.611238
       vitB  7.674811  7.655906  7.645350  7.677391  7.683614  7.677787  7.699136  7.695464  7.674429  7.658877
       vitC  8.187849  8.211621  8.135790  8.202203  8.198663  8.223203  8.211619  8.243838  8.222894  8.204213
       vitD  8.965874  8.965408  8.993825  8.984302  8.968818  8.953174  8.932130  8.955594  8.950091  8.986707
       vitE  9.978462  9.974023  9.954346  9.965816  9.973725  9.968195  9.964777  9.955478  9.969285  9.958483
       vitF 10.963016 10.949701 10.948256 10.967036 10.962113 10.978180 10.967397 10.983815 10.977263 10.960471
```  
- `reference_fruits.rds`, a list of vitamine composition for each fruit 

```
       # read reference data
       reference_fruits = readRDS("reference_fruits.rds")

       # format of references
       > colnames(reference_fruits)
       [1] "Apple" "Banan" "Orang" "Grape" "Mango" "Straw" "Pinea" "Blueb" "Water" "Peach"
       > rownames(smoothies)
       [1] "vitA" "vitB" "vitC" "vitD" "vitE" "vitF" "vitG" "vitH" "vitI" "vitJ" "vitK" "vitL" "vitM"
       [14] "vitN" "vitO" "vitP"
       > dim(reference_fruits)
       [1] 16      10
       > head(reference_data)
              Apple     Banan     Orang     Grape     Mango     Straw     Pinea     Blueb     Water     Peach 
       vitA  6.539159  6.820179  6.807355  6.700440  6.392317  6.700440  6.741467  6.714246  6.584963  6.523562 
       vitB  7.577429  7.607330  7.636625  7.636625  7.734710  7.721099  7.700440  7.727920  7.721099  7.651052 
       vitC  8.049849  8.266787  8.312883  8.169925  8.184875  8.204571  8.219169  8.257388  8.224002  8.108524 
       vitD  9.027906  8.936638  9.033423  9.014020  8.954196  8.933691  9.000000  8.918863  8.861087  9.014020 
       vitE  9.960002  9.977280  9.948367  9.980140  9.912889  9.975848  9.992938  9.957102  9.991522  9.958553 
       vitF 10.965063 10.934428 10.966505 10.941048 10.918863 11.011926 10.970106 11.034111 10.980854 10.942515 
```
  
## Data Download

To download the dataset for this project, follow these steps :

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit`.
