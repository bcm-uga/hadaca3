
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
sh generate_data.sh $1
# sh generate_data.sh real
echo 'data generated'

# Zip folder 
echo "create bunlde.zip"
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/



#Genereate starter_kit_phase1_2_3
# rm -rf starting_kit
mkdir starting_kit
#  generate baselines :
rm -rf ~/projects/hadaca3/templates/tmp/
Rscript ~/projects/hadaca3/templates/generate_baselines.R Phase_1  
cp ~/projects/hadaca3/templates/tmp/* starting_kit/


# rm -rf starting_kit_phase1
mkdir starting_kit_phase1

rm -rf ~/projects/hadaca3/templates/tmp/
Rscript ~/projects/hadaca3/templates/generate_baselines.R Phase_1_only  
cp ~/projects/hadaca3/templates/tmp/* starting_kit_phase1/

rm -r ~/projects/hadaca3/templates/tmp/ 
cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit_phase2-3.zip *  -x \*submissions\* ; cd .. ; 

cd starting_kit_phase1/ ; zip  -FS  -r  ../bundle/starting_kit_phase1.zip *  -x \*submissions\* ; cd .. ; 


zip -FS -j -r  bundle/ground_truth.zip ground_truth/
zip -FS -j -r  bundle/ground_truth_final.zip ground_truth_final/
zip -FS -j -r  bundle/ground_truth_phase1.zip ground_truth_phase1/



zip -FS -r -j bundle/input_data.zip input_data/
zip -FS -r -j bundle/input_data_final.zip input_data_final/
zip -FS -r -j bundle/input_data_phase1.zip input_data_phase1/

zip -FS -r -j bundle.zip bundle/


echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"