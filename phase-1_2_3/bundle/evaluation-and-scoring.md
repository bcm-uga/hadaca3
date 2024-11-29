# Evaluation and Scoring   
                           
The **global score** is used to rank the different methods and is computed from the estimated proportion matrix. This score is a combination of several metrics measuring the accuracy of the estimations compared to the real proportions of several datasets: Pearson and Spearman correlations on the total matrix, on the columns (samples correlations) and on the rows (cell types correlations), Mean Absolute Error (MAE) and Root Mean Square Error (RMSE), and Aitchison distance. The combination is a weighted geometric mean, such that all correlations account for one third, all errors for a second third and the distance for the last third of the global score.

To see your score:

  - Go on *My Submission* menu.
  - When the status of your submission is finished, refresh the page and check your score.
  - If your are satifyed by your score, click on the green button 'add to leaderboard' to push it the leaderboard.
  - Click on the "eye" icon (Detailed Results) to get information on your method's results and performances.
  
By clicking on your submission in the submissions summary table, you will get access to:

  - details of your submission (downloaded)

    	- submitted files
    	- prediction results (ingestion output) 
     	- scoring results (scoring output) 
  
  - some execution logs
  - a submission metadata edition menu
  
Check the leaderboard in the *Results*  menu.

To compare your score with other participants, go to the challenge page and navigate to the *Leaderboard* or *Results* section. 
Here, you can see how your submission ranks.
