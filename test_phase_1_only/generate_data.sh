

Phase_1_dataset_name="insilicopseudobulk"
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
nb_datasets=2
echo "Creating fake data because there is no argument"

Rscript generate_fake_data.R  $((nb_datasets )) 

path_data="data/"


else
### Using Real data
echo "At least one argument exists, migrating real data. \n 
This script will only copy files from the project hadaca3_private, so make sure they exist and they are up to date."  
echo $1


Rscript prepare_real_data.R 

path_data="data/"

# path_data=~/projects/hadaca3_private/

fi

mkdir input_data_phase1
mkdir ground_truth_phase1

### moving reference file which is common to all datasets
cp "$path_data"reference_data/reference_pdac.rds input_data/reference_pdac.rds
cp "$path_data"reference_data/reference_pdac.rds input_data_final/reference_pdac.rds
cp "$path_data"reference_data/reference_pdac.rds input_data_phase1/reference_pdac.rds
rm -rf "$path_data"reference_data/ 


dataset_phase1="$path_data"$Phase_1_dataset_name"1/mixes1_"$Phase_1_dataset_name"_pdac.rds"
dataset_phase1_gt="$path_data"$Phase_1_dataset_name"1/groundtruth1_"$Phase_1_dataset_name"_pdac.rds"

cp "$dir"$dataset_phase1 input_data_phase1/
cp "$dir"$dataset_phase1_gt ground_truth_phase1/




for dir in "$path_data"*1/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    cp "$dir"/mixes* input_data/
    cp "$dir"/groundtruth* ground_truth/
done

for dir in "$path_data"*2/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    # echo "${dir##*/}"    # print everything after the final "/"
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

mkdir starting_kit_phase1/data/
cp -r input_data_phase1/* starting_kit_phase1/data/

# cp "$path_data"mixes_data.rds starting_kit/mixes_data.rds
# cp "$path_data"reference_data.rds starting_kit/reference_data.rds