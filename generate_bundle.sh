
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/
cd starting_kit/ ; zip  -FS  -r  ../bundle/starting_kit.zip *  -x \*submissions\* ; cd .. ; 


zip -FS -j -r  bundle/ground_truth.zip ground_truth/
zip -FS -j -r  bundle/input_data.zip input_data/


zip -FS -r -j bundle.zip bundle/


echo "Bundle.zip created, upload it on Codabench, under benchmark, management and upload"