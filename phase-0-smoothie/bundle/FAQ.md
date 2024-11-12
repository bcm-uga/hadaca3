#  Frequently Ask question. 


**Submissions fail ?  -> Have a look at the logs on Codabench**

If your submission fails on Codabench, don't panic—review the logs! You can access them via the Codabench user interface:

1. Go to the "Submission" tab and scroll to the end of the page to find your submission.
2. Click on the row corresponding to your submission.
3. Select the "Logs" tab.
4. Browse the various types of logs available: `stdout`, `stderr`, `Ingestion stdout`, and `Ingestion stderr`, for both the ingestion and scoring steps.

**Cannot create your submissions ? Try interactive docker or conda environnement:  (Especially useful for python user !)**

A conda evnironnement is provided follow this steps to install and activate it: 
- retrieve the file environment-r.yml from github : [environment-r.yml](https://github.com/bcm-uga/hadaca3/blob/main/docker/codabench_hadaca3_pyr/environment/environment-r.yml) : 
- `wget https://raw.githubusercontent.com/bcm-uga/hadaca3/main/docker/codabench_hadaca3_pyr/environment/environment-r.yml`
- and run: `conda env create -f environment-r.yml && conda activate h3`


To run the docker interactively you can run with : 
 - `sudo docker run -it -v .:/hadaca3 -w /hadaca3 hombergn/hadaca3_pyr R`  and then `source("submission_script.R")` for the R version
 - `sudo docker run -it -v .:/hadaca3 -w /hadaca3 hombergn/hadaca3_pyr python` and then `import submission_script` for the python version.

Due to the usage of the super user (sudo) all files created by docker will be owned by root. In order to retrieve ownership, you can use this command : `sudo chown -R $USER submissions`.

Beware that Mac users with M1 processors might encounter problems. 


**How to run submissions ingestion and scoring locally with Docker ?**

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

**How to include an external file to be used in the submission script ?**
It is possible to include an external file that is sourced in the submission script and correctly included in the zip file to be submitted on the Codabench platform.
Beware, when unziped the file 'program.R' has to be on the current directory and not inside a folder. Aditionnal files can in other folder with the correct relative path 
