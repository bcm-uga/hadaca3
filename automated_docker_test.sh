
type Rscript >/dev/null 2>&1 || { echo >&2 "Rscript requiered but it's not installed.  Aborting."; exit 1; }

# echo "Building Docker"
# cd docker/codabench_hadaca3_light
# sudo docker build -t hombergn/hadaca3_light .  >> logs
# cd -
# echo "Docker created"

echo "Generate data"
sh generate_data.sh $1
# sh generate_data.sh real
echo "data Generated"

echo "Create submission program"
cd starting_kit/
Rscript submission_script.R >> logs
cd - 
echo "Done"

echo "Preparing data"
sh prepare2score_locally.sh
echo 'data migrated'

echo "Running ingestion Program, super user (sudo) is needed to run docker."
sudo docker run --rm  -v $PWD/ingestion_program:/app/program  -v $PWD/test_output/res:/app/output  -v $PWD/starting_kit/submissions:/app/ingested_program  -w /app/program  -v $PWD/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program >> logs
echo "Ingestion progam done"


echo "Running Scoring Program"
# sudo docker run --rm  -v $PWD/ingestion_program:/app/program  -v $PWD/test_output/res:/app/output  -v $PWD/starting_kit/submissions:/app/ingested_program  -w /app/program  -v $PWD/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program >> logs 
sudo docker run --rm  -v $PWD/scoring_program:/app/program  -v $PWD/test_output:/app/output  -w /app/program  -v $PWD/test_output:/app/input  hombergn/hadaca3_light  Rscript /app/program/scoring.R /app/input /app/output /app/program >> logs
echo "Scoring program done"


echo "Test if the output file accuracy.rds exist"
filename='test_output/accuracy.rds'
if [ -f $filename ]; then
    echo 'SUCESS! The result file exists.'
else
    echo 'FAILURE! The file does not exist.'
    exit 1
fi


# echo "Cleaning"
# sh clean.sh 1>> logs 2>> logs
# echo 'DONE'


