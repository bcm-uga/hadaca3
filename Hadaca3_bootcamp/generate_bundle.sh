

echo "generate data"
bash generate_data.sh
# sh generate_data.sh real
echo 'data generated'


cd baselines_functions
bash generate_baselines.sh
cd ..


# Zip folder 
# echo "create bunlde.zip"
# zip -FS -j -r  bundle/scoring_program.zip scoring_program/
# zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/



#### genereate empty input_data to load data challenge by hand
mkdir empty
touch empty/empty.txt
zip -FS -r -j bundle/input_data.zip empty/
# zip -FS -r -j bundle/input_data_phase3.zip empty/
# # zip -FS -r -j bundle/input_data_phase1.zip empty/

# #Genereate starter_kit_phase1_2_3
# # rm -rf starting_kit
# # mkdir starting_kit
# #  generate baselines :
# # rm -rf ~/projects/hadaca3/templates/tmp/
# # Rscript ~/projects/hadaca3/templates/generate_baselines.R Phase_1  
# # cp -R ~/projects/hadaca3/templates/tmp/* starting_kit/




# #### Put input data inside the bundle ! 

# # zip -FS -r -j bundle/input_data_phase2.zip input_data/
# # zip -FS -r -j bundle/input_data_phase3.zip input_data_final/
# # zip -FS -r -j bundle/input_data_phase1.zip input_data_phase1/


# zip -FS -j -r  bundle/ground_truth_phase2.zip ground_truth/
# zip -FS -j -r  bundle/ground_truth_phase3.zip ground_truth_final/
# zip -FS -j -r  bundle/ground_truth_phase1.zip ground_truth_phase1/








# # ##### generate starting_kit and input_data outisde bundle.zip
# # cd starting_kit_phase1/ ; zip  -FS  -r  ../bundle/starting_kit_phase1.zip *  -x \*submissions\* -x \*data\* ; cd .. ; 
# cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit_phase2-3.zip *  -x \*submissions\* -x \*data\* ; cd .. ; 

# # zip -FS -r -j input_data_phase2.zip input_data/
# # zip -FS -r -j input_data_phase3.zip input_data_final/
# # zip -FS -r -j input_data_phase1.zip input_data_phase1/

# cd starting_kit/ ; zip  -FS  -r  ../starting_kit.zip *  -x \*submissions\* ; cd .. ; 
# # cd starting_kit_phase1/ ; zip  -FS  -r  ../starting_kit_phase1.zip *  -x \*submissions\* ; cd .. ; 




# ###################  finalize and generate the final bundle
# zip -FS -r -j bundle.zip bundle/
# echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"





cd starting_kit
# python submission_script.py
Rscript submission_script.R
