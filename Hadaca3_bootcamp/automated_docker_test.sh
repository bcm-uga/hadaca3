





# echo "Building Docker"
# cd docker/codabench_hadaca3_light
# sudo docker build -t hombergn/hadaca3_light .  >> logs
# cd -
# echo "Docker created"

# docker_name=hombergn/hadaca3_light
# docker_name=hombergn/hadaca3_pyr
# docker_name=hombergn/hadaca3_final
# docker_name=hombergn/hadaca3_finalv2
# docker_name=hombergn/hadaca3_finalv3
docker_name=hombergn/hadaca3_final_light

echo 
echo 
echo generate baselines.

rm -rf starting_kit
mkdir starting_kit


echo 
echo 
echo "prepare data"
bash generate_data.sh
# sh generate_data.sh real
echo 'data preparation Finished'


cd baselines_functions
bash generate_baselines.sh
cd ..


# 


echo 
echo 
echo "Create submission program"
cd starting_kit/
rm -rf submissions
# Rscript submission_script.R >> logs
# Rscript submission_script.R 
python submission_script.py   
cd ..
echo "Done"

# exit

echo 
echo 
echo "Preparing data to score localy"
sh prepare2score_locally.sh
echo 'data migrated'



echo 
echo 

echo "Running ingestion Program, super user (sudo) is needed to run docker."
sudo docker run --rm  -v $PWD/ingestion_program:/app/program   -v $PWD/test_output/res:/app/output  -v $PWD/starting_kit/submissions:/app/ingested_program  -v $PWD/data/:/data  -v $PWD/public_data/input_data/:/app/input_data/ -w /app/program $docker_name Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program #>> logs
echo "Ingestion progam done"

echo 
echo 
echo "Running Scoring Program"
sudo docker run --rm  -v $PWD/scoring_program:/app/program -v $PWD/utils/:/app/utils/  -v $PWD/test_output:/app/output   -v $PWD/test_output:/app/input  -w /app/program -v $PWD/data:/app/data  $docker_name  Rscript /app/program/scoring.R /app/input /app/output /app/program #>> logs
echo "Scoring program done"


echo "Test if the output file scores.txt exist"
filename='test_output/scores.txt'
if [ -f $filename ]; then
    echo 'SUCESS! The result file exists.'
else
    echo 'FAILURE! The file does not exist.'
    exit 1
fi

sudo chown $USER test_output/detailed_results.html

echo "Cleaning"
sh clean.sh 1>> logs 2>> logs
echo 'DONE'


