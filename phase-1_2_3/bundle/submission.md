# Submission               
                           
This section describes the step-by-step submission process, if a part of the process stays unclear try the FAQ page. 

## Simple submission process using R

1. Download the `strarting_kit.zip` file

To download the dataset for this project, follow these steps:

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit` file.

2. On your local machine, unzip the starting_kit.zip.
 
The unziped starting_kit directory contains now following files:

- `submission_script.R`, an R script to use/modify to generate a submission using R.
- `submission_script.py`, a python script to use/modify to generate a submission using python.
- `mixes_smoothies_fruits.rds`, an RDS file embedding a `data.frame` describing **mixture data**, *i.e*, smoothies that you want to estimate composition.
- `reference_fruits.rds`, -> an RDS file embedding a `data.frame` describing **references data**, *i.e.*, typical vitamines profiles of fruits used in smoothies recipes.
 
3. Go to the starting kit directory and run the appropriate submission script:

```
cd starting_kit
Rscript submission_script.R
```

It generates the files:

- `zip_program`, a zip file containing your code,
-` zip_results`, a zip file containing your estimation of receipies.

There is other ways to execute `submission_script.R`, for exemple in an R console in a terminal or in RStudio.
Execution description for `submission_script.py` is available in the following section.
Another section showcases a way to execute the submission script throught a docker image.


4. Next, submit either your code archive (zip_program) or your results archive (zip_results) through the *My Submission* section on the Codabench website. On the *My Submission* page, the status of your submission will progress through the following stages: > *Submitting* > *Submitted* > *Running* > *Finished*.

5. Now you are ready to improve performance with **your own code**.

Edit the `submission_script.R` to replace the baseline method by the method of your choice, *i.e.*, modify the code inside the `program` function, located between the tags:

```
## 
## YOUR CODE BEGINS/ENDS HERE 
##
```	


## Submission process using python (beta)

You can also generate `zip_program` and `zip_results` folders using the `submission_script.py` by executing the following commands:

```
cd starting_kit
python submission_script.py
```

Then follow the steps 4 and 5 described in the previous section.


## Submission process using docker container (beta)


1. Install docker, and setup your dockerhub account
   
2. Get the last docker image and run it, if you want to edit the code in interactive mode, within the hadaca3 docker environment.

```
cd starting_kit
sudo docker pull hombergn/hadaca3_pyr
sudo docker run -it -v .:/hadaca3 -w /hadaca3 hombergn/hadaca3_pyr R
source("submission_script.R")
chown -R $USER submissions #if necessary
```

Alternatively, run the following commande to execute the `submission_script`:

```
sudo docker run -v .:/hadaca3 -w /hadaca3  hombergn/hadaca3_pyr Rscript submission_script.R
```

and regain ownership of the files generated with:

```
sudo chown -R $USER submissions
```




