#!/bin/bash

#SBATCH --account=def-nklujan
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=8G
#SBATCH --mail-user=sarah.babaei@mail.utoronto.ca
#SBATCH --mail-type=ALL

module load fastp

#set variable names for the paths to our input and output folders
#the input folder should be the folder that contains the sequences you want to trim
#the output folder should be the foldet that the trimmed sequences will output to
#paste the full paths between the quotation marks
INPUT=""
OUTPUT=""

mkdir -p "$OUTPUT/reports_polyG"

for fq in "$INPUT"/*fq.gz; do
	sample=$(basename "$fq" .fq.gz)
	fastp --in1 "$fq" \
		--out1 "$OUTPUT/${sample}_polyG.fq.gz" \
		--trim_poly_g \
		--thread 4 \
		--html "$OUTPUT/reports_AE/${sample}.html" \
		--json "$OUTPUT/reports_AE/${sample}.json"
done
