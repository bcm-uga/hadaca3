
# hadaca 3 - Health Data Challenge

HADACA 3 is the third edition of a Health Data Challenge, organized by the PEPR Santé Numérique (M4DI axis) and the University Grenoble-Alpes data challenges hub (TIMC, IAB and GRICAD). It will take place from December 2nd to 6th, 2024,


The goal of this challenge is to explore and potentially discover new methods to resolve deconvolution problems.

The HADACA 3 challenge begins with a bulk dataset in the form of a matrix, containing the expression profiles of k different cells. Participants are required to retrieve the expression type of each cell using any available methods, such as machine learning.

Participants will submit their method in the form of an R program, which will then be ingested and scored using a ground truth matrix. In the final phase of this challenge, the best method submitted by each participant will be evaluated on a different dataset. The aim of this final phase is to ensure the method is not overfitted.

## Download git 

```
cd ~ && mkdir projects
cd ~/projects
git clone git@github.com:bcm-uga/hadaca3.git
cd hadaca3
```


## Generate a submission 

```
cd starting_kit
Rscript submission_script.R

```


## Run Script locally 

Once "submissions" folder created by the submission script inside starting kit, you can test locally the ingestion and scoring program. 

```
cd ~/projects/hadaca3
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

```

## Build bundle and deploy on codabench

```
cd ~/projects/hadaca3

sh generate_bundle.sh
```

Log in codabench website, then from the benchmark dropdown menu select Management. 
Select upload and select the bundle.zip created earlier. 




## Docker image 


### Build docker images
```
cd docker/codabench_hadaca3_light

sudo docker build -t hombergn/hadaca3_light .

#see existing images 
sudo docker images 


# log in on docker hub (the username here is hombergn)
sudo docker login -u  hombergn

# rename image if necessary  
#sudo docker tag light_hadaca hombergn/hadaca3_light 

#upload on dockerhub
sudo docker push hombergn/hadaca3_light:latest

#Single command to build and push. 
sudo docker build -t hombergn/hadaca3_light .  && sudo docker push hombergn/hadaca3_light:latest
```



### Run docker image locally

First prepare the submission by creating 

```
cd ~/projects/hadaca3
sh prepare2score_locally.sh
```

```
sudo docker run --rm  \
    -v /home/hombergn/projects/hadaca3/ingestion_program:/app/program  \
    -v /home/hombergn/projects/hadaca3/test_output/res:/app/output  \
    -v /home/hombergn/projects/hadaca3/starting_kit/submissions:/app/ingested_program  \
    -w /app/program \ 
    -v /home/hombergn/projects/hadaca3/input_data:/app/input_data \
    hombergn/hadaca3_light \
    Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
```

```
sudo docker run --rm  -v /home/hombergn/projects/hadaca3/ingestion_program:/app/program  -v /home/hombergn/projects/hadaca3/test_output/res:/app/output  -v /home/hombergn/projects/hadaca3/starting_kit/submissions:/app/ingested_program  -w /app/program  -v /home/hombergn/projects/hadaca3/input_data:/app/input_data hombergn/hadaca3_light Rscript /app/program/ingestion.R /app/program /app/input_data /app/output /app/ingested_program
```


```
sudo docker run --rm \
    -v /home/hombergn/projects/hadaca3/scoring_program:/app/program \
    -v /home/hombergn/projects/hadaca3/test_output:/app/output \
    -w /app/program 
    -v /home/hombergn/projects/hadaca3/test_output:/app/input \
    hombergn/hadaca3_light \
    Rscript /app/program/scoring.R /app/input /app/output /app/program
```
 ```   
sudo docker run --rm  -v /home/hombergn/projects/hadaca3/scoring_program:/app/program  -v /home/hombergn/projects/hadaca3/test_output:/app/output  -w /app/program  -v /home/hombergn/projects/hadaca3/test_output:/app/input  hombergn/hadaca3_light  Rscript /app/program/scoring.R /app/input /app/output /app/program

```
