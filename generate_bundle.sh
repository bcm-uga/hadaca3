
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/
zip -FS -j -r  bundle/starting_kit.zip starting_kit/  -x \*submissions\*


zip -FS -j -r  bundle/ground_truth.zip ground_truth/
zip -FS -j -r  bundle/input_data.zip input_data/


zip -FS -r -j bundle.zip bundle/
