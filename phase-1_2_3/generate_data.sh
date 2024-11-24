

# echo $1

# the folder data is also created insite the generate_data.R
echo cean data first 
sh clean.sh
echo cleaning done. 


mkdir input_data
mkdir input_data_final
# for i in $(seq 1 $nb_datasets); do mkdir input_data/input_data_$i ;  done ; 
# for i in $(seq 1 $nb_datasets); do mkdir input_data_final/input_data_$i ;  done ; 

mkdir ground_truth
mkdir ground_truth_final
mkdir data

#Test if argument exist

# if [ $# -lt 1 ]
if [false]
then
nb_datasets=9
echo "Creating fake data because there is no argument"

Rscript generate_fake_data.R  $((nb_datasets )) 

path_data="data/"


else
### Using Real data
echo "At least one argument exists, migrating real data. \n 
This script will only copy files from the project hadaca3_private, so make sure they exist and they are up to date."  
echo $1

# h3_p_path="~/projects/hadaca3_private/"
# cur_path=$PWD

# cd $h3_p_path
# cmd_snakemake_clean="snakemake --cores 8 -s 00_run_pipeline.py -p clean"
# # cmd_snakemake_build="snakemake --cores 8 -s 00_run_pipeline.py -p "
# cmd_snakemake_build="snakemake --cores 4 -s 00_run_pipeline.py -p --resources mem_mb=16000 --max-jobs-per-second 1 generate_data"

# $cmd_snakemake_clean 
# $cmd_snakemake_build 

## This script anonymise the datasets and move them to the folder data. 
# Rscript prepare_real_data.R  $((nb_datasets )) 


Rscript prepare_real_data.R 

path_data="data/"

# path_data=~/projects/hadaca3_private/

fi


### moving reference file which is common to all datasets

cp "$path_data"reference_data/reference_pdac.rds input_data/reference_pdac.rds
cp "$path_data"reference_data/reference_pdac.rds input_data_final/reference_pdac.rds
rm -rf "$path_data"reference_data/ 


for dir in "$path_data"*1/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    # echo "${dir##*/}"    # print everything after the final "/"
    # echo $dir
    cp "$dir"/mixes* input_data/
    cp "$dir"/groundtruth* ground_truth/
done

for dir in "$path_data"*2/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    # echo "${dir##*/}"    # print everything after the final "/"
    # echo $dir
    cp "$dir"/mixes* input_data_final/
    cp "$dir"/groundtruth* ground_truth_final/
done


# for i in  $(seq 1 $nb_datasets);
# do
#     echo "Number $i"

#     cp "$path_data""$i"/mixes_data_"$i".rds input_data/
#     cp "$path_data""$i"/ground_truth_"$i".rds ground_truth/
    
# done

# for i in  $(seq $((nb_datasets+1)) $((nb_datasets * 2)));
# do
#     echo "Number $i"
#     num=$((i -nb_datasets ))
#     cp "$path_data""$i"/mixes_data_"$i".rds input_data_final/mixes_data_"$num".rds
#     cp "$path_data""$i"/ground_truth_"$i".rds ground_truth_final/ground_truth_"$num".rds
# done

mkdir starting_kit/data/
cp -r input_data/* starting_kit/data/

# cp "$path_data"mixes_data.rds starting_kit/mixes_data.rds
# cp "$path_data"reference_data.rds starting_kit/reference_data.rds