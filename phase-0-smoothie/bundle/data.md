
## Data generation

The smoothies (16 vitamine composition of 10 mixtures) to be deconvoluted are simulated **in silico** using fruit profiles (vitamine composition of each fruit).
The aim of the challenge is to find the recipie of each smoothie (i.e. the exact fruit composition)

## Data description


- `mixes_smoothies_fruits.rds`, a list of vitamine profile for each mixture (i.e. smoothie)

       # read mixture data
       mixes_smoothies_fruits = readRDS("mixes_smoothies_fruits.rds")
        > dim(mixes_smoothies_fruits)
       [1] 16      10
  
  
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
```
  
## Data Download

To download the dataset for this project, follow these steps :

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit`.
