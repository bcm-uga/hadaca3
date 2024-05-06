
sudo rm -rf test_output
mkdir -p test_output/res/
mkdir test_output/ref
cp ground_truth/ground_truth.rds  test_output/ref/ground_truth.rds 


cp -r starting_kit/modules starting_kit/submissions
# cd starting_kit/submissions && ln -s ../modules/ modules && cd ../..

echo "READY"