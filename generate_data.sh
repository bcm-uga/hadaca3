

# echo $1

# the folder data is also created insite the generate_data.R
echo cean data first 
sh clean.sh
echo cleaning done. 

mkdir input_data
mkdir ground_truth

#Test if argument exist
if [ $# -lt 1 ]
then
echo "Creating fake data because there is no argument"

mkdir data
Rscript generate_fake_data.R >> logs

# Should we put the data migration inside the bundle generator script ? 

path_data="data/"


# exit 1

else

# echo "At least one argument exists, cloning data from  "
echo "At least one argument exists, migrating real data. \n 
This script will only copy files from the project hadaca3_private, so make sure they exist and they are up to date."  

echo $1


path_data=~/projects/hadaca3_private/

fi

echo "$path_data"
# echo "$path_data"mixes_data.rds starting_kit/mixes_data.rds

cp "$path_data"mixes_data.rds starting_kit/mixes_data.rds
cp "$path_data"reference_data.rds starting_kit/reference_data.rds

cp "$path_data"mixes_data.rds input_data/mixes_data.rds
cp "$path_data"reference_data.rds input_data/reference_data.rds

cp "$path_data"ground_truth.rds ground_truth/ground_truth.rds
