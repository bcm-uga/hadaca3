
zip -FS -j -r  bundle/scoring_program.zip scoring_program/
zip -FS -j -r  bundle/ingestion_program.zip ingestion_program/
zip -FS -j -r  bundle/starting_kit.zip starting_kit/  -x \*submissions\*

zip -FS -r -j bundle.zip bundle/

# zip folder 