


rm -rf test_output
mkdir -p test_output/res/
mkdir -p test_output/ref


cd test_output/ref/ 
ln -s ../../platform/ground_truth/*  .
cd ../../

cd test_output/res/ 
ln -s -r ../../starting_kit/data/* .
cd ../../

# cd starting_kit/submissions
# ln -s ../attachement/* .
# cd ../../
# cp starting_kit/submissions/prediction.rds test_output/res/ 


echo "READY"