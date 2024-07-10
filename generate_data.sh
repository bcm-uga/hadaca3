

# echo $1

# the folder data is also created insite the generate_data.R
echo cean data first 
sh clean.sh
echo cleaning done. 

number_dataset=4



mkdir input_data
mkdir input_data_final
for i in $(seq 1 $number_dataset); do mkdir input_data/input_data_$i ;  done ; 
for i in $(seq 1 $number_dataset); do mkdir input_data_final/input_data_$i ;  done ; 
# for i in {1..$number_dataset}; do mkdir input_data_$i ;  done ; 
mkdir ground_truth

#Test if argument exist

if [ $# -lt 1 ]
then
echo "Creating fake data because there is no argument"

mkdir data
Rscript generate_fake_data.R  $((number_dataset * 2)) 

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

cp "$path_data"ground_truth/ground_truth.rds ground_truth/ground_truth.rds


# for i in {1..$number_dataset}; 
for i in  $(seq 1 $number_dataset);
do
    echo "Number $i"
    cp "$path_data""$i"/mixes_data_"$i".rds input_data/input_data_"$i"/mixes_data.rds
    cp "$path_data""$i"/reference_data_"$i".rds input_data/input_data_"$i"/reference_data.rds
    # cp "$path_data""$i"/mixes_data_"$i".rds input_data/input_data_"$i"/mixes_data_"$i".rds
    # cp "$path_data""$i"/reference_data_"$i".rds input_data/input_data_"$i"/reference_data_"$i".rds
done

for i in  $(seq $((number_dataset+1)) $((number_dataset * 2)));
do
    echo "Number $i"
    num=$((i -number_dataset ))
    cp "$path_data""$i"/mixes_data_"$i".rds input_data_final/input_data_"$num"/mixes_data.rds
    cp "$path_data""$i"/reference_data_"$i".rds input_data_final/input_data_"$num"/reference_data.rds
done

cp -r input_data/* starting_kit/

# cp "$path_data"mixes_data.rds starting_kit/mixes_data.rds
# cp "$path_data"reference_data.rds starting_kit/reference_data.rds