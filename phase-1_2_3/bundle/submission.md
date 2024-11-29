# Submission               
                           
This section describes the submission process step-by-step. If a part of the process stays unclear, you can check the FAQ page. 

## Simple submission process using R

1. Download the `starting_kit.zip` file

To download the files for this project, follow these steps:

 - Go on the challenge page,
 - Go the *Get started* menu,
 - Click on the *Files* tab,
 - Download the `starting_kit` file.

2. Unzip the starting_kit.zip on your local machine
 
The unzipped starting_kit directory contains the following files:

- `submission_script.R`, an R script that you will use/modify to generate a submission using R.
- `submission_script.py`, a python script to use/modify to generate a submission using python.
- `mixes_SOMETHING.rds`, an RDS file containing the **mixture data** to be deconvoluted.
- `reference_pdac.rds`, an RDS file containing the **reference data**, *i.e.*, typical molecular profiles of the cell types present in PDAC.
 
3. Go to the starting kit directory and run the appropriate submission script (R or python)

```
cd starting_kit
Rscript submission_script.R
```

It generates the files:

- `zip_program`, a zip file containing your code,
-` zip_results`, a zip file containing your estimation of the proportions.

There are other ways to execute `submission_script.R`, for exemple in an R console in the terminal or from RStudio.
The description on how to execute `submission_script.py` is in the following section.
Another section showcases a way to execute the submission script through a docker image.


4. Next, submit either your code archive (`zip_program`) or your results archive (` zip_results`) through the *My Submission* section on the Codabench website. On the *My Submission* page, the status of your submission will progress through the following stages: *Submitting* > *Submitted* > *Running* > *Finished*.

5. Now you can try and improve performance with **your own code**

Edit the `submission_script.R` to replace the baseline method by the method of your choice, *i.e.* modify the code inside the `program` function, between the tags:

```
## 
## YOUR CODE BEGINS/ENDS HERE 
##
```	


## Submission process using python (beta)

You can also generate the `zip_program` and `zip_results` files using the `submission_script.py` by executing the following commands:

```
cd starting_kit
python submission_script.py
```

Then follow steps 4 and 5 described above.


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
