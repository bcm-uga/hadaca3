#!/usr/bin/env bash
set -euo pipefail



# -------------------------------
# Directories and constants
# -------------------------------
template_dir="templates"
baseline_file_prefix="baseline_"
mainDir=".."
output_path="$mainDir/starting_kit"


start_marker="### Write programs Here !"

mkdir -p "$output_path"


# you can editi theses dictionnary to cahnge the function on each starting kit
declare -A dict_R=(
  ["lm"]="submission_script.R"
)

declare -A  dict_py=(
  ["lm"]="submission_script.py"
)

# -------------------------------
# Helper function: copy file to output
# -------------------------------
copy_file() {
    local file="$1"
    local src="$file"
    local dest="$output_path/$file"
    mkdir -p "$(dirname "$dest")"
    cp -f "$src" "$dest"
}

# -------------------------------
# Function: create base script
# -------------------------------
create_base_script() {
    local dict_name="$1"   # e.g. dict_Phase_0 or dict_Phase_0_py
    local suffix_file="$2" # .R or .py

    # Bash indirection to use variable by name
    local -n dict="$dict_name"

    for baseline in "${!dict[@]}"; do
        local baseline_file="${baseline_file_prefix}${baseline}${suffix_file}"

        local template_file="$template_dir/template_submission_script${suffix_file}"
        local output_file="$output_path/${dict[$baseline]}"

        echo "Generating: $output_file"

        # Insert baseline content into template
        awk -v marker="$start_marker" -v baseline_file="$baseline_file" '
            $0 == marker {
                while ((getline line < baseline_file) > 0) print line
                next
            }
            { print }
        ' "$template_file" > "$output_file"

        mkdir -p "$output_path/attachement"
        cp $mainDir/utils/* "$output_path/attachement/"

    done
}

# -------------------------------
# Run generation
# -------------------------------

create_base_script "dict_R" ".R"
create_base_script "dict_py" ".py"
