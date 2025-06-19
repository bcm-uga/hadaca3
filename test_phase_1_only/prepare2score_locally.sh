
rm -rf test_output
mkdir -p test_output/res/
mkdir -p test_output/ref

cp ground_truth/*  test_output/ref/ 


cp -r starting_kit/modules starting_kit/submissions

# cp starting_kit/submissions/prediction.rds test_output/res/ 


echo "READY"