**How to generate a prediction of the data?**

[2] On your local machine, unzip the starting_kit.zip. Then open R in the starting_kit directory, (e.g. open submission_script.R with RStudio).
 
The unziped starting_kit directory contains now:

- A `submission_script.R` -> *to modify and to use to submit your code*
- The `public_data_met.rds` -> *DNA methylation D matrix*
-The `public_data_rna.rds` -> *transcriptome D matrix*
 
[3] In the R console launch the following command (or run the `submission_script.R` in RStudio):
		 
		source("submission_script.R")

[4] The code of the  `submission_script.R`  generates the files:
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

**How to submit your results ?**

[5] Now, let’s submit your code (`zip_program`) or your result (`zip_results` ) in the *My Submission* menu of the challenge.

1) fill the metadata 
2) select the task you want to submit to and 
3) upload your submission files

On the  *My Submission* webpage,  the STATUS of your submission will go through the following steps :
 -> Submitting > Submitted > Running > Finished
