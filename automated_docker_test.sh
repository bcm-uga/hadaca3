echo "Building Docker"
cd docker/codabench_hadaca3_light
sudo docker build -t hombergn/hadaca3_light .
cd -
echo "\n\nDocker created\n\n"

echo "\n\nCreate submission program\n\n"
cd starting_kit/
Rscript submission_script.R
cd - 
echo "\n\nDone"

echo "\n\nPreparing data\n\n"
sh prepare2score_locally.sh


echo "\n\nRunning ingestion Program\n\n"
sudo docker run --rm  -v /home/hombergn/projects/hadaca3/ingestion_program:/app/program  -v /home/hombergn/projects/hadaca3/test_output/res:/app/output  -v /home/hombergn/projects/hadaca3/starting_kit/submissions:/app/ingested_program  -w /app/program  -v /home/hombergn/projects/hadaca3/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
echo "\n\nIngestion progam done\n\n"


echo "\n\nRunning Scoring Program\n\n"
sudo docker run --rm  -v /home/hombergn/projects/hadaca3/ingestion_program:/app/program  -v /home/hombergn/projects/hadaca3/test_output/res:/app/output  -v /home/hombergn/projects/hadaca3/starting_kit/submissions:/app/ingested_program  -w /app/program  -v /home/hombergn/projects/hadaca3/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
echo "\n\nScoring program done\n\n"


echo "Test if the result exist"
filename='test_output/res/results_1.rds'
if [ -f $filename ]; then
    echo 'SUCCES The result file exists.'
else
    echo 'FAILURE ! The file does not exist.'
fi


echo "\nnCleaning"
sh clean.sh
echo 'DONE'


