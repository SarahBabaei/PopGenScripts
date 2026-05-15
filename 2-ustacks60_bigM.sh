#!/bin/bash

#SBATCH --account=def-nklujan
#SBATCH --cpus-per-task=24
#SBATCH --time=24:00:00
#SBATCH --mem=32000M
#SBATCH --mail-user=sarah.babaei@mail.utoronto.ca
#SBATCH --mail-type=ALL

#load required modules
module load StdEnv/2023
module load stacks/2.67

#designate all sample ID's to a single variable called 'files', each sample should be in the directory, and the filename should match this designation except for the extension, e.g., 'sample_2' = 'sample_2.fq.gz'
files="T09336_beggini
T09344_beggini
T09345_beggini
T09392_beggini
T09393_beggini
T09395_beggini
T09396_beggini
T09487_beggini
T09834_beggini
V5424_beggini"

# -M — Maximum distance (in nucleotides) allowed between stacks (default 2).
# -m — Minimum depth of coverage required to create a stack (default 3).
#here, vary M from 1-8, and set m to the optimized value based on prior visualizations (here 3)

for i in {1..8}
do
#create a directory to hold this unique iteration:
mkdir stacks_bigM$i
#run ustacks with M equal to the current iteration (1-8) for each sample, and m set to the optimized value (here, m=3)
id=1
for sample in $files
do
    ustacks -f ${sample}.fq.gz -o stacks_bigM$i -i $id -m 3 -M $i -p 24
    let "id+=1"
done
cstacks -P stacks_bigM$i -M popmap_panmictic.txt -p 24
sstacks -P stacks_bigM$i -M popmap_panmictic.txt -p 24
tsv2bam -P stacks_bigM$i -M popmap_panmictic.txt -t 24
gstacks -P stacks_bigM$i -M popmap_panmictic.txt -t 24
populations -P stacks_bigM$i -M popmap_panmictic.txt --vcf -t 24
done
