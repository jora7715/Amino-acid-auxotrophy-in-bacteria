#!/bin/bash
set -eu

# Set parameters
domain="archaea" # change this as well as in format_data.R
out_dir="output/"${domain}
#file_to_split="file.test.txt"
file_to_split="file."${domain}".txt"
out_split="split_files"

#adds a header to echo, for a better console output overview
echoWithHeader() {
  echo " *** [$(date '+%Y-%m-%d %H:%M:%S')]: $*"
}

echoDuration() {
  duration=$(printf '%02dh:%02dm:%02ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))
  echoWithHeader "Done in: $duration!"
}

# Generate file with all orgs
Rscript create_orgs_file.R

# Make the directories
mkdir -p ${out_split}
mkdir -p ${out_dir}

# Split data in smaller chunks
split -l 100 --additional-suffix .txt "${file_to_split}" "${out_split}/${file_to_split%txt}"

# Run Gapmind and remove excess files
for file in ${out_split}/"file."${domain}.*".txt"; do
  echoWithHeader "  - Starting analysis of $file..."
  cd /data/jensent/miniconda3/envs/Gapmind
  #echo ${file}
  gap_out=$(echo ${file##*/} | sed 's/.txt//')
  #echo "${gap_out}"
  mkdir -p $out_dir/${gap_out}
  bin/buildorgs.pl -out $out_dir/${gap_out}/orgs -orgfile $file
  bin/gapsearch.pl -orgs $out_dir/${gap_out}/orgs -set aa -out $out_dir/${gap_out}/aa.hits -nCPU 10
  bin/gaprevsearch.pl -orgs $out_dir/${gap_out}/orgs -hits $out_dir/${gap_out}/aa.hits -curated tmp/path.aa/curated.faa.udb -out $out_dir/${gap_out}/aa.revhits -nCPU 10
  bin/gapsummary.pl -orgs $out_dir/${gap_out}/orgs -set aa -hits $out_dir/${gap_out}/aa.hits -rev $out_dir/${gap_out}/aa.revhits -out $out_dir/${gap_out}/aa.sum
  cd $out_dir/${gap_out}
  find . -type f -not -name "orgs.org" -not -name "aa.sum.rules" -print0 | xargs -0  -I {} rm -v {}
  echoDuration
done

# Find all files for aggregation
cd /data/jensent/miniconda3/envs/Gapmind
echoWithHeader "  - Finding all files..."
find ${out_dir} -mindepth 1 -maxdepth 2 -type f -name "aa.sum.rules" -exec tail +2 {} \; >> "output/"${domain}"_all_aa.sum.rules.txt"
find ${out_dir} -mindepth 1 -maxdepth 2 -type f -name "orgs.org" -exec tail +2 {} \; >> "output/"${domain}"_all_orgs.txt"

# Format output data
Rscript format_data.R

