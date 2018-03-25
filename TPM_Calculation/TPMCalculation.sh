#!/bin/bash

# Calulate the TPM value for each RNA-Seq data
# Run jobs on slurm matchine

# $1=genome (e.g. human)

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=1-00:00
#SBATCH --mem=16GB

# Notification configuration
#SBATCH --mail-type=END                                        
#SBATCH --mail-type=FAIL                                       
#SBATCH --mail-user=lu.zeng@adelaide.edu.au  

# Load Softwares
module load Trim_Galore/0.4.1-foss-2015b
module load RSEM/1.3.0-foss-2015b
module load Bowtie2/2.2.6-foss-2015b 
module load SRA-Toolkit/2.7.0-centos_linux64
module load fastqc/0.11.4  
 
# Extract the uniq names without _1/2.fastq.gz(for pair-end RNA-Seq data)
FILES=($(ls ./| rev | cut -c 12- | rev | uniq))
# Extract the uniq names without _1_val_1.fq.gz (for pair-end RNA-Seq data)
FILES2=($(ls ./ | rev | cut -c 15- | rev | uniq))
# Extract the uniq names without _1_trimmed.fq.gz (for sing-end RNA-Seq data)
FILES3=($(ls ./ | rev | cut -c 17- | rev | uniq))

# Download RNA-Seq data
cd /data/rc003/lu/transcriptome/$1/
wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRRxxx/SRRxxxxx/*.sra

# Transfer sra format to fastq format
for i in *.sra
do
fastq-dump.2.7.0 -I --split-files $1/$i
done

# Check the quality of RNA-Seq data
mkdir qc
for i in *.fastq
do
    echo $i
    fastqc -o $1/qc/ $1/$i
done

# Adapter trimming the fastq files 
# and then check the RNA-Seq data quality 
mkdir /data/rc003/lu/transcriptome/$1/trim
trim_galore --stringency 6 -o /data/rc003/lu/transcriptome/$1/trim/ --paired -fastqc_args "-t 8" /data/rc003/lu/transcriptome/$1/${FILES3[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz /data/rc003/lu/transcriptome/$1/${FILES3[$SLURM_ARRAY_TASK_ID]}_2.fastq.gz
# strigency: overlap with adapter sequence required to trim a sequences, default is '1', the lower the number
# the lower strigency

# For single-end RNA-Seq data
mkdir /data/rc003/lu/transcriptome/$1/trim
trim_galore --clip_R1 5 --three_prime_clip_R1 5 -o $/data/rc003/lu/transcriptome/$1/trim/ -fastqc_args "-t 8" /data/rc003/lu/transcriptome/$1/${FILES2[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz

# Make directory to store RSEM output
mkdir /data/rc003/lu/transcriptome/$1/RSEM/

# Then prepare rsem reference
~/RSEM-1.3.0/rsem-prepare-reference --gtf /data/rc003/lu/transcriptome/gtf_files/$1.gtf --bowtie2 --bowtie2-path /apps/software/Bowtie2/2.2.6-foss-2015b/bin/ /data/rc003/lu/transcriptome/genomes/$1.fa /data/rc003/lu/transcriptome/$1/$1_index/$1Genome

# Then calculate the gene expression (TPM), including pair-end and single-end data
# Pair-end
~/RSEM-1.3.0/rsem-calculate-expression -p 8 --bowtie2 --paired-end /data/rc003/lu/transcriptome/$1/trim/${FILES3[$SLURM_ARRAY_TASK_ID]}_1_val_1.fq.gz /data/rc003/lu/transcriptome/$1/trim/${FILES3[$SLURM_ARRAY_TASK_ID]}_2_val_2.fq.gz /data/rc003/lu/transcriptome/$1/$1_index/$1Genome /data/rc003/lu/transcriptome/$1/RSEM/${FILES3[$SLURM_ARRAY_TASK_ID]}
# Single-end
~/RSEM-1.3.0/rsem-calculate-expression -p 8 --bowtie2 /data/rc003/lu/transcriptome/$1/trim/${FILES2[$SLURM_ARRAY_TASK_ID]}_1_trimmed.fq.gz /data/rc003/lu/transcriptome/$1/$1_index/$1Genome /data/rc003/lu/transcriptome/$1/RSEM/${FILES2[$SLURM_ARRAY_TASK_ID]}
