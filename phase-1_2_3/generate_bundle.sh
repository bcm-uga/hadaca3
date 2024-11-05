
type Rscript >/dev/null 2>&1 || { echo >&2 "Rscript requiered but it's not installed.  Aborting."; exit 1; }


echo "generate data"
sh generate_data.sh $1
# sh generate_data.sh real
echo 'data generated'

# Zip folder 
echo "create bunlde.zip"
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/
cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit_phase2-3.zip *  -x \*submissions\* ; cd .. ; 


zip -FS -j -r  bundle/ground_truth.zip ground_truth/
zip -FS -j -r  bundle/ground_truth_final.zip ground_truth_final/




# cd input_data/
# zip -FS -r  ../bundle/input_data.zip *
# cd .. 

# cd input_data_final/
# zip -FS -r  ../bundle/input_data_final.zip *
# cd .. 

zip -FS -r -j bundle/input_data.zip input_data/
zip -FS -r -j bundle/input_data_final.zip input_data_final/

zip -FS -r -j bundle.zip bundle/


echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"