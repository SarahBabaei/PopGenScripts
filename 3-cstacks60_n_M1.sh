#!/bin/bash

#SBATCH --account=def-nklujan
#SBATCH --cpus-per-task=32
#SBATCH --time=10:00:00
#SBATCH --mem=64000M
#SBATCH --mail-user=sarah.babaei@mail.utoronto.ca
#SBATCH --mail-type=ALL

#designate all sample IDs to a single variable called files, each sample should be in the directory, and the filename should match this designation except for the extension, e.g., 'sample_2' = 'sample_2.fastq.gz'
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

#load required modules
module load StdEnv/2023
module load stacks/2.67

# -n — Number of mismatches allowed between sample loci when build the catalog (default 1).
#here, vary 'n' across M-1, M, and M+1 (because my optimized 'M' value = 2, I will iterate over 1, 2, and 3 here), with 'm' and 'M' set to the optimized value based on prior visualizations (here 'm' = 3, and 'M'=2).

for i in {1..3}
do
#create a directory to hold this unique iteration:
mkdir stacks_n$i
#run ustacks with n equal to the current iteration (1-3) for each sample, m = 3, and M=1
id=1
for sample in $files
do
    ustacks -f ${sample}.fq.gz -o stacks_n$i -i $id -m 3 -M 1 -p 32
    let "id+=1"
done
cstacks -n $i -P stacks_n$i -M popmap_panmictic.txt -p 32
sstacks -P stacks_n$i -M popmap_panmictic.txt -p 32
tsv2bam -P stacks_n$i -M popmap_panmictic.txt -t 32
gstacks -P stacks_n$i -M popmap_panmictic.txt -t 32
populations -P stacks_n$i -M popmap_panmictic.txt --vcf -t 32
done
