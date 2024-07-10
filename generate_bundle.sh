
type Rscript >/dev/null 2>&1 || { echo >&2 "Rscript requiered but it's not installed.  Aborting."; exit 1; }


echo "generate data"
sh generate_data.sh $1
# sh generate_data.sh real
echo 'data generated'

# Zip folder 
echo "create bunlde.zip"
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/
cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit.zip *  -x \*submissions\* ; cd .. ; 


zip -FS -j -r  bundle/ground_truth.zip ground_truth/



# number_dataset=4
# for i in  $(seq 1 $number_dataset);
# do
#     zip -FS -j -r  bundle/input_data_"$i".zip input_data/input_data_"$i"
# done 

cd input_data/
zip -FS -r  ../bundle/input_data.zip *
cd .. 

# zip -FS -r bundle/input_data.zip input_data/

cd input_data_final/
zip -FS -r  ../bundle/input_data_final.zip *
cd .. 

zip -FS -r -j bundle.zip bundle/


echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"