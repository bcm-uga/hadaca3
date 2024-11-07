# Step-by-step submission process

If this page does not answer your questions try the FAQ page :) 

## Set up the docker container (optional)

1) Install docker, and setup your dockerhub account
   
2) Get the last docker image and run it:

```
docker pull hombergn/hadaca3_pyr
docker run -it -v .:/hadaca3 -w /hadaca3 hombergn/hadaca3_pyr R
```

## How to generate a prediction of the data (R)?

[1] On your local machine, unzip the starting_kit.zip.
 
The unziped starting_kit directory contains now:

- A `submission_script.R` -> *to modify and to use to submit your code*
- The `reference_fruits.rds` -> *reference data, i.e. typical vitamines profiles of expected fruits types*
- The `mixess_smoothies_fruits.rds` -> *mixes from which you will estimate fruits type proportions.
- A `submission_script.py` -> *not useful for R users*
 
[2] Choose your way of executing `submission_script.R`  
 - From terminal run `Rscript submission_script.R` 
 - Launch an R console and execute the following command : `source("submission_script.R")`
 - Run the `submission_script.R` in RStudio/ Vscode
 - From docker :`sudo docker run -v .:/hadaca3 -w /hadaca3  hombergn/hadaca3_pyr Rscript submission_script.R`  and regain ownership of the files generated with `sudo chown -R $USER submissions`


[3] The code of the  `submission_script.R`  generates the files:
- `zip_program`  -> *for code submission, script format*
-` zip_results`  -> *for result submission, table format*

Edit the `submission_script.R` to replace the baseline method by the method of your choice. 

Edit the code inside the following chunk (i.e. the `program` function):  

		## 
		## YOUR CODE BEGINS HERE 
		##
		
		##
		## YOUR CODE ENDS HERE
		## 



## How to generate a prediction of the data (Python)?
Please note that this challenge was primarily designed with R in mind, and as such, R functionality and compatibility have been tested more extensively than those in Python. When using Python, keep in mind that your scripts will need to interact with R data, which requires the rpy2 library. To facilitate this, a Conda environment has been provided. For more details, please refer to the "Conda Environment" chapter under the "FAQ" page.

[1] On your local machine, unzip the starting_kit.zip.
 
The unzipped starting_kit directory contains now:

- A `submission_script.py` -> *to modify and to use to submit your code*
- The `reference_fruits.rds` -> *reference data, i.e. typical vitamines profiles of expected fruits types*
- The `mixess_smoothies_fruits.rds` -> *mixes from which you will estimate fruits type proportions.
- A `submission_script.R` -> *not useful for python users*
 
[2] Choose your way of executing `submission_script.py`  
 - From terminal run `python submission_script.py` 
 - Launch an interactive python shell by executing : `python -i submission_script.py`
 - Run the `submission_script.py` in Spider/ Vscode
 - From docker : `sudo docker run -v .:/hadaca3 -w /hadaca3  hombergn/hadaca3_pyr python submission_script.py` and regain ownership of the files generated with `sudo chown -R $USER submissions`


[3] The code of the  `submission_script.R`  generates the files:
- `zip_program`  -> *for code submission, script format*
-` zip_results`  -> *for result submission, table format*

Edit the `submission_script.py` to replace the baseline method by the method of your choice. 

Edit the code inside the following chunk (i.e. the `program` function):

		## 
		## YOUR CODE BEGINS HERE 
		##
		
		##
		## YOUR CODE ENDS HERE
		## 

## How to submit your results ?

Now, let’s submit your code (`zip_program`) or your result (`zip_results` ) in the *My Submission* menu of the challenge.

On the  *My Submission* webpage,  the STATUS of your submission will go through the following steps :
 -> Submitting > Submitted > Running > Finished

## How to see your score ?

To view your score, go to the challenge page and navigate to the Leaderboard or Results section. Here, you can see how your submission ranks and compare your score with other participants.

[1] Go on *My Submission* menu 

[2] When the status of your submission is finished ( don't forget to refresh the page to update the status), click on the green button 'add to leaderboard' to see your score
  
By clicking on your submission in the submissions summary table, you will access to:

  - details of your submission (downloaded)
	-> submitted files, 
	-> prediction results (ingestion output) 
	-> scoring results (scoring outputs) 
			
  - some execution logs
  
  - a submission metadata edition menu
  
[3] Check the leaderboard in the *Results*  menu
