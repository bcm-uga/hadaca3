# rm -rf data
mkdir -p data

rm -rf participants
rm -rf platform
rm -rf starting_kit
mkdir -p participants/input_data
mkdir -p participants/ground_truth
mkdir -p platform/input_data
mkdir -p platform/ground_truth



base_url=http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/


#######
#get datas : 
#######
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



cd data
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
# files_mixes=(mixes1_insilicodirichletCopule_pdac.h5 mixes1_insilicodirichletEMFA_pdac.h5 mixes1_insilicopseudobulk_pdac.h5 mixes1_invitro_pdac.h5 mixes1_invivo_pdac.h5 mixes1_insilicodirichletNoDep_pdac.h5 mixes1_insilicodirichletNoDep4CTsource_pdac.h5 mixes1_insilicodirichletNoDep6CTsource_pdac.h5 mixes1_insilicodirichletEMFAImmuneLowProp_pdac.h5)
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletCopule_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletEMFA_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicopseudobulk_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_invitro_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_invivo_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep4CTsource_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletNoDep6CTsource_pdac.h5
# wget http://epimed.univ-grenoble-alpes.fr/downloads/dmzfch/hadaca3_framework/data/mixes1_insilicodirichletEMFAImmuneLowProp_pdac.h5

# for file in ${files_mixes[@]}; do 
#     # echo $url
#     # filename=$(basename "$file")
#     # echo $filename
#     if [ ! -f "$file" ]; then
#         echo "Downloading $file..."
#         wget $base_url$file
#     else
#         echo "Skipping $file (already exists)"
#     fi
# done 

for file_type in mixes groundtruth ; do 
    for mixes_nb in {1..2};  do 
        for key in "${!dic_datasets2short[@]}"; do
            complete_name="${file_type}${mixes_nb}_${dic_datasets2short[$key]}_pdac.h5"
            if [ ! -f "$complete_name" ]; then
                echo "Downloading $complete_name..."
                wget $base_url$complete_name
            else
                echo "Skipping $complete_name (already exists)"
            fi
        done
    done 
done 

# cd ../ground_truth
#TO ADD maybe ? 
# files_groundtruth=()
# for file in ${files_groundtruth[@]}; do 
#     # echo $url
#     file=$(basename "$url")
#     echo $file
#     if [ ! -f "$file" ]; then
#         echo "Downloading $file..."
#         wget $base_url$file
#     else
#         echo "Skipping $file (already exists)"
#     fi
# done 

cd ../ 


cd participants
# ln -s ../../data/ref.h5 ref.h5
# cd ../

#populating input_data folder. 
for mixes_nb in {1..2};  do 
    if [[ $mixes_nb == 1 ]]; then 
        cd  ../participants/input_data
        else
        cd ../platform/input_data

    fi
    ln -s ../../data/ref.h5 ref.h5
    for file_type in mixes groundtruth ; do 
        if [[ $file_type == "mixes" ]]; then 
            cd  ../input_data
        else
            cd ../ground_truth
        fi
        for key in "${!dic_datasets2short[@]}"; do
            # complete_name="mixes1_${dic_datasets2short[$key]}_pdac.h5"
            complete_name="${file_type}${mixes_nb}_${dic_datasets2short[$key]}_pdac.h5"
            short_name="${key}.h5"

            echo "Linking: $complete_name → $short_name"

            # Create a symbolic link (only if the target exists)
            if [[ -f "../../data/$complete_name" ]]; then
                ln -sf "../../data/$complete_name" "./$short_name"
            else
                echo "Warning: File ../../data/$complete_name not found, skipping..."
            fi
        done
    done 
    cd ..
done 

cd ..

# create ground_truth folder
# # cd ../ground_truth
# for key in "${!dic_datasets2short[@]}"; do
#     complete_name="groundtruth1_${dic_datasets2short[$key]}_pdac.h5"
#     short_name="groundtruth1_${key}_pdac.h5"

#     echo "Linking: $complete_name → $short_name"

#     # Create a symbolic link (only if the target exists)
#     if [[ -f "../data/$complete_name" ]]; then
#         ln -sf "../data/$complete_name" "./$short_name"
#     else
#         echo "Warning: File ../data/$complete_name not found, skipping..."
#     fi
# done




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


# rm -rf starting_kit
# rm -rf starting_kit_phase1


mkdir -p starting_kit/data/
mkdir -p starting_kit/ground_truth/

cp -r participants/input_data/* starting_kit/data/
cp -r participants/ground_truth/* starting_kit/ground_truth/

