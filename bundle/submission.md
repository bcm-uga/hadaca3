## How to generate a prediction of the data (R)?

[1] On your local machine, unzip the starting_kit.zip.
 
The unziped starting_kit directory contains now:

- A `submission_script.R` -> *to modify and to use to submit your code*
- a `data` folder that includes: 
* The `data/reference_data.rds` -> *reference data, i.e. typical molecular profiles of expected cell types*
*  The `data/mixes_data.rds` -> *mixes from which you will estimate cell type proportions (matching RNA and DNA methylation data)*
- A `submission_script.py` -> *not useful for R users*
 
[2] Choose your way of executing `submission_script.R`  
 - From terminal run `Rscript submission_script.R` 
 - Launch an R console and execute the following command : `source("submission_script.R")`
 - Run the `submission_script.R` in RStudio/ Vscode


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
Please note that this challenge was primarily designed with R in mind, and as such, R functionality and compatibility have been tested more extensively than those in Python. When using Python, keep in mind that your scripts will need to interact with R data, which requires the rpy2 library. To facilitate this, a Conda environment has been provided. For more details, please refer to the "Conda Environment" chapter under "Troubleshooting".

[1] On your local machine, unzip the starting_kit.zip.
 
The unzipped starting_kit directory contains now:

- A `submission_script.py` -> *to modify and to use to submit your code*
- a `data` folder that includes: 
* The `data/reference_data.rds` -> *reference data, i.e. typical molecular profiles of expected cell types*
*  The `data/mixes_data.rds` -> *mixes from which you will estimate cell type proportions (matching RNA and DNA methylation data)*
- A `submission_script.R` -> *not useful for python users*
 
[2] Choose your way of executing `submission_script.py`  
 - From terminal run `python submission_script.py` 
 - Launch an interactive python shell by executing : `python -i submission_script.py`
 - Run the `submission_script.py` in Spider/ Vscode


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

## Troubleshooting

### Conda environnement: 

A conda evnironnement is provided follow this steps to install and activate it: 
- retrieve the file environment-r.yml from github : [environment-r.yml](https://github.com/bcm-uga/hadaca3/blob/main/docker/codabench_hadaca3_pyr/environment/environment-r.yml) : 
- `wget https://raw.githubusercontent.com/bcm-uga/hadaca3/main/docker/codabench_hadaca3_pyr/environment/environment-r.yml`
- and run: `conda env create -f environment-r.yml && conda activate h3`


### Logs on Codabench

If your submission fails on Codabench, don't panic—review the logs! You can access them via the Codabench user interface:

1. Go to the "Submission" tab and scroll to the end of the page to find your submission.
2. Click on the row corresponding to your submission.
3. Select the "Logs" tab.
4. Browse the various types of logs available: `stdout`, `stderr`, `Ingestion stdout`, and `Ingestion stderr`, for both the ingestion and scoring steps.

### Running Submissions Locally with Docker

To speed up the debugging process and avoid the full submission workflow, you can run your submission program locally using **FAKE** data. The fake data serves two purposes: first, it allows testing without relying on the actual scoring program (which requires the ground truth), and second, it speeds up computation.

To test locally, follow these steps:

1. Clone the challenge repository:
   ```
   git clone https://github.com/bcm-uga/hadaca3.git
   cd hadaca3
   ```
2. Set up the environment and activate it:
   ```
   conda env create -f environment-r.yml && conda activate h3
   ```
3. Run the automated Docker test script:
   ```
   sh automated_docker_test.sh
   ```

Please note that this script will use the `submission_script.R` from the `hadaca3/starting_kit/` folder. **Ensure that your script is placed inside the `hadaca3/starting_kit/` folder or modify the existing script at `hadaca3/starting_kit/submission_script.R`**.


The script `automated_docker_test.sh` first executes the R submission script locally, then re-executes it within the Docker container (ingestion phase), followed by running the scoring program.

If you wish to test each step independently or run the Python script locally, refer to the `README.md` in the `hadaca3` GitHub repository.