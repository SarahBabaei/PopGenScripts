#!/bin/bash

#SBATCH --account=def-nklujan
#SBATCH --cpus-per-task=4
#SBATCH --time=3:00:00
#SBATCH --mem=8G
#SBATCH --mail-user=sarah.babaei@mail.utoronto.ca
#SBATCH --mail-type=ALL

module load fastp

INPUT=""
OUTPUT=""

mkdir -p "$OUTPUT/reports_BF"

for fq in "$INPUT"/*fq.gz; do
	sample=$(basename "$fq" .fq.gz)
	fastp --in1 "$fq" \
		--out1 "$OUTPUT/${sample}_trimmed.fq.gz" \
		--trim_front1 12 \
		--max_len1 60 \
		--length_required 60 \
		--thread 4 \
		--html "$OUTPUT/reports_BF/${sample}.html" \
		--json "$OUTPUT/reports_BF/${sample}.json"
done
