

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

# cp data/mixes_data.rds starting_kit/mixes_data.rds
# cp data/reference_data.rds starting_kit/reference_data.rds

# cp data/mixes_data.rds input_data/mixes_data.rds
# cp data/reference_data.rds input_data/reference_data.rds

# cp data/ground_truth.rds ground_truth/ground_truth.rds

# cp data/public_data_rna.rds starting_kit/public_data_rna.rds
# cp data/public_data_rna.rds input_data/public_data_rna.rds

# cp data/cancer_type.rds input_data/cancer_type.rds
# cp data/input_k_value.rds input_data/input_k_value.rds

# cp data/ground_truth.rds ground_truth/ground_truth.rds

# exit 1

else

# echo "At least one argument exists, cloning data from  "
echo "At least one argument exists, migrating real data. \n 
This script will only copy the files from the project hadaca3_private, so make sure they exist and they are up to date. "  

echo $1

###  create the data with the script 
# git@gricad-gitlab.univ-grenoble-alpes.fr:hadaca3/hadaca3_private.git
# cd ~/projects
# rm -rf hadaca3_private
# git clone $1
# cd hadaca3_private

# cd ~/projects/hadaca3_private

# mamba env create -f 01_generate_data_condaenv_LL_06-05-24.yml
# conda activate hadaca3
# Rscript -e "rmarkdown::render('01_generate_data.Rmd',params=list(args = myarg))"
# Rscript -e "rmarkdown::render('01_generate_data.Rmd')"

# path_data="../hadaca3_private/"
path_data=~/projects/hadaca3_private/

# cp ~/projects/hadaca3_private/mixes_data.rds starting_kit/mixes_data.rds
# cp ~/projects/hadaca3_private/reference_data.rds starting_kit/reference_data.rds

# cp ~/projects/hadaca3_private/mixes_data.rds input_data/mixes_data.rds
# cp ~/projects/hadaca3_private/reference_data.rds input_data/reference_data.rds

# cp ~/projects/hadaca3_private/ground_truth.rds ground_truth/ground_truth.rds
fi

echo "$path_data"
# echo "$path_data"mixes_data.rds starting_kit/mixes_data.rds

cp "$path_data"mixes_data.rds starting_kit/mixes_data.rds
cp "$path_data"reference_data.rds starting_kit/reference_data.rds
cp "$path_data"mixes_data.rds input_data/mixes_data.rds
cp "$path_data"reference_data.rds input_data/reference_data.rds
cp "$path_data"ground_truth.rds ground_truth/ground_truth.rds
