
<!-- badges: start -->
[![Docker Image CI](https://github.com/bcm-uga/hadaca3/actions/workflows/submission_on_docker.yml/badge.svg?branch=data_generation_migration)](https://github.com/bcm-uga/hadaca3/actions/workflows/submission_on_docker.yml)
<!-- badges: end -->

# hadaca 3 - Health Data Challenge


HADACA 3 is the third edition of a Health Data Challenge, organized by the PEPR Santé Numérique (M4DI axis) and the University Grenoble-Alpes data challenges hub (TIMC, IAB and GRICAD). It will take place from December 2nd to 6th, 2024,


The goal of this challenge is to explore and potentially discover new methods to resolve deconvolution problems.

The HADACA 3 challenge begins with a bulk dataset in the form of a matrix, containing the expression profiles of k different cells. Participants are required to retrieve the expression type of each cell using any available methods, such as machine learning.

Participants will submit their method in the form of an R program, which will then be ingested and scored using a ground truth matrix. In the final phase of this challenge, the best method submitted by each participant will be evaluated on a different dataset. The aim of this final phase is to ensure the method is not overfitted.

# Scripts availabale and guide: 
Summary of scripts available: 
* `generate_fake_data.R`: R script to generates fake data. It does not take any argument. 
* `clean.sh`: Bash script that deletes temporary file and all data.
* `generate_data.sh`: Bash script that either take one argument and generates the real data or no argument and execute `generate_fake_data.R`.
* `prepare2score_locally.sh`: Bash script that generates temporary path and folder used by the ingestion and scoring program when executed locally. It depends on `clean.sh` and `generate_data.sh` and therefor **takes one optionnal argument** to either generates real data or fake. 
* **`automated_docker_test.sh`**: Bash script that test the ingestion and scoring program locally with the docker container. It **takes one optionnal argument** to either generates real data or fake and executes the following steps: 
    1. Build the docker image.
    2. Generates data with `generate_data.sh`.
    3. Run the submission script to generates a submission program. Note: It will create and use the latest `Program.R` inside the *submissions* folder of the local *startink_kit* folder.
    4. Prepare the data to be executed locally with; `prepare2score_locally.sh`.
    5. Execute the ingestion program on docker
    6. Execute the scoring program on docker with the prediction file created with the previous step.
    7. Test the existence of the output file *accuracy.rds*.  If this file exist: it is a sucess, otherwise it is a failure and the script stop here. In that case the file *logs* contain potentially usefull informations to debug.
    8. If the previous test was a sucess, `clean.sh` is exectued.
* **`generate_bundle.sh`**: Bash script that will generates data and creates *bundle.zip* with all its dependancies. *bundle.zip* is ready to be uploaded on Codabench, under benchmark, management and then the green bouton upload. It also **takes one optionnal argument** to either generates real or fake data.

## Download git:

```
cd ~ && mkdir projects
cd ~/projects
git clone git@github.com:bcm-uga/hadaca3.git
cd hadaca3
```


## Generate a submission:

```
cd starting_kit
Rscript submission_script.R
```

## Run Script locally:

/!\ This local test no longer works when using sourced files in program.R that call sub_programm in the folder modules.


Once "submissions" folder created by the submission script inside starting kit, you can test locally the ingestion and scoring program.

```
cd ~/projects/hadaca3
sh prepare2score_locally.sh

Rscript ingestion_program/ingestion.R \
    ingestion_program \
    input_data \
    test_output/res \
    starting_kit/submissions

Rscript scoring_program/scoring.R  \
    test_output \
    test_output \
    scoring_program


cd test_output
mkdir -p input/ref
mkdir -p input/res
cd input
cp ../ref/groundtruth_smoothies_fruits.rds ref/
cp ../res/prediction.rds res/


Rscript -e 'rmarkdown::render("../../scoring_program/detailed_results.Rmd")'
  

```

## Build bundle and deploy on codabench

The bundle **bundle.zip** is created with the script generate_bundle.sh
```
cd ~/projects/hadaca3
sh generate_bundle.sh
```

Log in codabench website, then from the benchmark dropdown menu select Management.

Select upload and select **bundle.zip** created earlier.

## Docker image 

### Build docker images

The docker named hadaca3_pyr also has impleted python as well.

```
cd docker/codabench_hadaca3_pyr

sudo docker build -t hombergn/hadaca3_pyr .

#see existing images 
sudo docker images 


# log in on docker hub (the username here is hombergn)
sudo docker login -u  hombergn

# rename image if necessary  
#sudo docker tag light_hadaca hombergn/hadaca3_light 

#upload on dockerhub
sudo docker push hombergn/hadaca3_light:latest
sudo docker push hombergn/hadaca3_pyr:latest

#Single command to build and push. 
sudo docker build -t hombergn/hadaca3_light .  && sudo docker push hombergn/hadaca3_light:latest
```



### Run docker image locally

Run all the test automatically with the script `automated_docker_test.sh`:
```
cd ~/projects/hadaca3
sh automated_docker_test.sh
```

Or test each step manualy with the following commands :

First prepare the docker submission with the script `prepare2score_locally.sh`

```
cd ~/projects/hadaca3
sh prepare2score_locally.sh
```

The following block is only there to show all arguments in a digestible way.
```
#sudo docker run --rm  \
#    -v $PWD/ingestion_program:/app/program  \
#    -v $PWD/test_output/res:/app/output  \
#    -v $PWD/starting_kit/submissions:/app/ingested_program  \
#    -w /app/program \ 
#    -v $PWD/input_data:/app/input_data \
#    hombergn/hadaca3_light \
#    Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
```

Run the follwing command to test the ingestion program using the docker.  
```
sudo docker run --rm  -v $PWD/ingestion_program:/app/program  -v $PWD/test_output/res:/app/output  -v $PWD/starting_kit/submissions:/app/ingested_program  -w /app/program  -v $PWD/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
```

This block is only there to show all arguments in a digestible way. 
```
#sudo docker run --rm \
#    -v $PWD/scoring_program:/app/program \
#    -v $PWD/test_output:/app/output \
#    -w /app/program 
#    -v $PWD/test_output:/app/input \
#    hombergn/hadaca3_light \
#    Rscript /app/program/scoring.R /app/input /app/output /app/program
```

Run the following command to test scoring program using dockers.
 ```   
sudo docker run --rm  -v $PWD/scoring_program:/app/program  -v $PWD/test_output:/app/output  -w /app/program  -v $PWD/test_output:/app/input  hombergn/hadaca3_light  Rscript /app/program/scoring.R /app/input /app/output /app/program

```
