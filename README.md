# hadaca 3 - Health Data Challenge

HADACA 3 is the third edition of a Health Data Challenge, organized by the PEPR Santé Numérique (M4DI axis) and the University Grenoble-Alpes data challenges hub (TIMC, IAB and GRICAD). It will take place from December 2nd to 6th, 2024,

The goal of this challenge is to explore and potentially discover new methods to resolve deconvolution problems.

The HADACA 3 challenge begins with a bulk dataset in the form of a matrix, containing the expression profiles of k different cells. Participants are required to retrieve the expression type of each cell using any available methods, such as machine learning.

Participants will submit their method in the form of an R program, which will then be ingested and scored using a ground truth matrix. In the final phase of this challenge, the best method submitted by each participant will be evaluated on a different dataset. The aim of this final phase is to ensure the method is not overfitted.

## Download git 

```
cd ~ && mkdir projects
cd ~/projects
git clone .../hadaca3.git
cd hadaca3
```

## Build bundle and deploy on codabench

```
#cd bunlde/
#zip ../bundle.zip * 
#cd ..

zip -FS -r -j bundle.zip bundle/*

```

Log in codabench website, then from the benchmark dropdown menu select Management. 
Select upload and select the bundle.zip created earlier. 



## Docker image 

```
cd docker/codabench_legacy

sudo docker build -t ombresocial/hadaca3_ligth .

sudo docker images #see existing images 


# upload on docker hub
sudo docker login -u  ombresocial

#sudo docker tag light_hadaca ombresocial/hadaca3_ligth # rename image if necessary  
sudo docker push ombresocial/hadaca3_ligth:latest

#Single command 
sudo docker build -t ombresocial/hadaca3_ligth . sudo docker push ombresocial/hadaca3_ligth:latest


```


