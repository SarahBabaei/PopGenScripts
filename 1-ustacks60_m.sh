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

# Build loci de novo in each sample for the single-end reads only.
# -M — Maximum distance (in nucleotides) allowed between stacks (default 2).
# -m — Minimum depth of coverage required to create a stack (default 3).
#here, we will vary m from 3-7, and leave all other paramaters default

for i in {3..7}
do
#create a directory to hold this unique iteration:
mkdir stacks_m$i
#run ustacks with m equal to the current iteration (3-7) for each sample
id=1
for sample in $files
do
    ustacks -f ${sample}.fq.gz -o stacks_m$i -i $id -m $i -p 15
    let "id+=1"
done
## Run cstacks to compile stacks between samples. Popmap is a file in working directory called 'popmap.txt'
cstacks -P stacks_m$i -M popmap_panmictic.txt -p 32
## Run sstacks. Match all samples supplied in the populati0n map against the catalog.
sstacks -P stacks_m$i -M popmap_panmictic.txt -p 32
## Run tsv2bam to transpose the data so it is stored by locus, instead of by sample.
tsv2bam -P stacks_m$i -M popmap_panmictic.txt -t 32
## Run gstacks: build a paired-end contig from the metapopulation data (if paired-reads provided),
## align reads per sample, call variant sites in the population, genotypes in each individual.
gstacks -P stacks_m$i -M popmap_panmictic.txt -t 32
## Run populations completely unfiltered and output unfiltered vcf, for input to the RADstackshelpR package
populations -P stacks_m$i -M popmap_panmictic.txt --vcf -t 32
done
