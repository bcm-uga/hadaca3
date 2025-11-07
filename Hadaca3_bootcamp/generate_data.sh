# rm -rf data
mkdir -p data

rm -rf input_data
rm -rf ground_truth
rm -rf reference
mkdir -p input_data
mkdir -p ground_truth
mkdir -p reference

#######
#get datas : 
#######

cd data
base_url=http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/
# cd reference
files_ref=(ref.h5)
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/ref.h5

for file in ${files_ref[@]}; do 
    # echo $url
    # filename=$(basename "$file")
    # echo $filename
    if [ ! -f "$file" ]; then
        echo "Downloading $file..."
        wget $base_url$file
    else
        echo "Skipping $file (already exists)"
    fi
done 



# cd ../input_data
# ln -s ../reference_data/ref.h5 input_data/ref.h5

#downloading mixes.
files_mixes=(mixes1_insilicodirichletCopule_pdac.h5 mixes1_insilicodirichletEMFA_pdac.h5 mixes1_insilicopseudobulk_pdac.h5 mixes1_invitro_pdac.h5 mixes1_invivo_pdac.h5 mixes1_insilicodirichletNoDep_pdac.h5 mixes1_insilicodirichletNoDep4CTsource_pdac.h5 mixes1_insilicodirichletNoDep6CTsource_pdac.h5 mixes1_insilicodirichletEMFAImmuneLowProp_pdac.h5)
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletCopule_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletEMFA_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicopseudobulk_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_invitro_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_invivo_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep4CTsource_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep6CTsource_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletEMFAImmuneLowProp_pdac.h5

for file in ${files_mixes[@]}; do 
    # echo $url
    # filename=$(basename "$file")
    # echo $filename
    if [ ! -f "$file" ]; then
        echo "Downloading $file..."
        wget $base_url$file
    else
        echo "Skipping $file (already exists)"
    fi
done 


# cd ../ground_truth
#TO ADD maybe ? 
files_groundtruth=()
for file in ${files_groundtruth[@]}; do 
    # echo $url
    file=$(basename "$url")
    echo $file
    if [ ! -f "$file" ]; then
        echo "Downloading $file..."
        wget $base_url$file
    else
        echo "Skipping $file (already exists)"
    fi
done 

cd ../ 
cd input_data
ln -s ../data/ref.h5 ref.h5


# ### moving reference file which is common to all datasets
# cp "$path_data"reference_data/reference_pdac.rds input_data/reference_pdac.rds
# rm -rf "$path_data"reference_data/ 


# dataset_phase1="$path_data"$Phase_1_dataset_name"1/mixes1_"$Phase_1_dataset_name"_pdac.rds"

# echo $dataset_phase1
# dataset_phase1_gt="$path_data"$Phase_1_dataset_name"1/groundtruth1_"$Phase_1_dataset_name"_pdac.rds"
# echo $dataset_phase1_gt


# cp "$dir"$dataset_phase1 input_data_phase1/
# cp "$dir"$dataset_phase1_gt ground_truth_phase1/


declare -A dic_datasets2short=(
    [VITR]="invitro"
    [VIVO]="invivo"
    [SBN5]="insilicopseudobulk"
    [SDN5]="insilicodirichletNoDep"
    [SDN4]="insilicodirichletNoDep4CTsource"
    [SDN6]="insilicodirichletNoDep6CTsource"
    [SDE5]="insilicodirichletEMFA"
    [SDEL]="insilicodirichletEMFAImmuneLowProp"
    [SDC5]="insilicodirichletCopule"
)


# echo "Datasets: ${!dic_datasets2short[@]}"
for key in "${!dic_datasets2short[@]}"; do
    complete_name="mixes1_${dic_datasets2short[$key]}_pdac.h5"
    short_name="${key}.h5"

    echo "Linking: $complete_name → $short_name"

    # Create a symbolic link (only if the target exists)
    if [[ -f "../data/$complete_name" ]]; then
        ln -sf "../data/$complete_name" "./$short_name"
    else
        echo "Warning: File ../data/$complete_name not found, skipping..."
    fi
done

# create ground_truth folder
cd ../ground_truth
for key in "${!dic_datasets2short[@]}"; do
    complete_name="groundtruth1_${dic_datasets2short[$key]}_pdac.h5"
    short_name="groundtruth1_${key}_pdac.h5"

    echo "Linking: $complete_name → $short_name"

    # Create a symbolic link (only if the target exists)
    if [[ -f "../data/$complete_name" ]]; then
        ln -sf "../data/$complete_name" "./$short_name"
    else
        echo "Warning: File ../data/$complete_name not found, skipping..."
    fi
done

# for dir in "$path_data"*1/     # list directories in the form "/tmp/dirname/"
# do
#     dir=${dir%*/}      # remove the trailing "/"
#     cp "$dir"/mixes* input_data/
#     cp "$dir"/groundtruth* ground_truth/
# done

# for dir in "$path_data"*2/     # list directories in the form "/tmp/dirname/"
# do
#     dir=${dir%*/}      # remove the trailing "/"
#     # echo "${dir##*/}"    # print everything after the final "/"
#     cp "$dir"/mixes* input_data_final/
#     cp "$dir"/groundtruth* ground_truth_final/
# done


# # rm -rf starting_kit
# # rm -rf starting_kit_phase1


# mkdir starting_kit/data/
# cp -r input_data/* starting_kit/data/

# mkdir starting_kit_phase1/data/
# cp -r input_data_phase1/* starting_kit_phase1/data/
