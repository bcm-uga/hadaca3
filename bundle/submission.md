## How to generate a prediction of the data?

[1] On your local machine, unzip the starting_kit.zip. Then open R in the starting_kit directory, (e.g. open submission_script.R with RStudio).
 
The unziped starting_kit directory contains now:

- A `submission_script.R` -> *to modify and to use to submit your code*
- The `public_data_met.rds` -> *DNA methylation D matrix*
-The `public_data_rna.rds` -> *transcriptome D matrix*
 
[2] In the R console launch the following command (or run the `submission_script.R` in RStudio):
		 
		source("submission_script.R")

[3] The code of the  `submission_script.R`  generates the files:
- `zip_program`  -> *for code submission, script format*
-` zip_results`  -> *for result submission, table format*

Edit the `submission_script.R` to replace the baseline method by the method of your choice. 

1) First, define the type of data you want to use to estimate tumor heterogeneity:
		 data_test <- readRDS(file = "public_data_rna.rds") #Comment if you want to predict from methylome data
		#data_test <- readRDS(file = "public_data_met.rds") #Uncomment if you want to predict from methylome data

2) Then, edit the code inside the following chunk (i.e. the `program` function): 
    
		## 
		## YOUR CODE BEGINS HERE 
		##
		
		##
		## YOUR CODE ENDS HERE
		## 

	Don't forget to specify the `program` function parameter `k`, which corresponds to the number of cell types you want to estimate. It is set to `k=3` by default.

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

