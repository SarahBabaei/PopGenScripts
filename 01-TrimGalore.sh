#!/bin/bash
#
#SBATCH --job-name=newseq3_cutadapt
#SBATCH --output=newseq3_cutadapt.txt
#SBATCH --error=newseq3_cutadapt.error
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=50000

#above is required for SLURM to read the job in. each line says something different, look at the flag (starts with --)
#for example, --cpus-per-task=1 allocates 1 CPU for this script to run on
#there are other flags and not all of these are needed, but these are what I like to use.

#Activate virtual environment in which cutadapt is installed
source ~/my_venv/bin/activate

#set variable names for the paths to our input and output folders
#the input folder should be the folder that contains the sequences you want to trim
#the output folder should be the foldet that the trimmed sequences will output to
#paste the full paths between the quotation marks
INPUT=""
OUTPUT=""


for fq in "$INPUT"/*fastq.gz
do
	echo "Processing $fq..."
	./trim_galore \
	--illumina \
	--gzip \
	--output_dir "$OUTPUT" \
	"$fq"
done

echo "Trimming complete. output saved to "$OUTPUT""
