
type Rscript >/dev/null 2>&1 || { echo >&2 "Rscript requiered but it's not installed.  Aborting."; exit 1; }



#PULL both repo 
Current_folder=$PWD


echo "pulling from "$PWD
git pull

path_data=~/projects/hadaca3_private/

cd $path_data
echo "pulling from "$path_data
git pull

cd $Current_folder

echo "generate data"

#Should be a seperate script ? 
mkdir input_data
mkdir ground_truth
# mdkir starting_kit/
cp "$path_data"groundtruth1_smoothies_fruits.rds ground_truth/groundtruth_smoothies_fruits.rds
cp "$path_data"mixes1_smoothies_fruits.rds input_data/mixes_smoothies_fruits.rds
cp "$path_data"reference_fruits.rds input_data/reference_fruits.rds


mkdir starting_kit
rm -r starting_kit/*
cp -r input_data/* starting_kit/
# sh generate_data.sh $1
# sh generate_data.sh real
echo 'data generated'

# Zip folder 
echo "create bunlde.zip"
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/

#Phase_0 is useless for now 
Rscript ~/projects/hadaca3/templates/generate_baselines.R Phase_0  
cp ~/projects/hadaca3/templates/tmp/* starting_kit/
rm -r ~/projects/hadaca3/templates/tmp/ 
cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit_smoothie.zip *  -x \*submissions\* ; cd .. ; 


zip -FS -j -r  bundle/ground_truth.zip ground_truth/

cd input_data/
zip -FS -r  ../bundle/input_data.zip *
cd .. 

zip -FS -r -j bundle-smoothie.zip bundle/


echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"
