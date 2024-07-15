#!/bin/bash -l

############# SLURM SETTINGS #############

#SBATCH --account=project0026 # the project account - don't change this
#SBATCH --job-name=snp_analysis # give your job a name!
#SBATCH --partition=nodes # we are using CPU nodes - don't change this
#SBATCH --time=0-48:00:00 # how long do we expect this job to run?
#SBATCH --mem=4G # how much memory do we want?
#SBATCH --nodes=1 # how many nodes do we want?
#SBATCH --ntasks=1 # how many tasks are we submitting?
#SBATCH --cpus-per-task=2 # how many CPUs do we want for each task?
#SBATCH --ntasks-per-node=1 # how many tasks do we want to run on each node?
#SBATCH --mail-user=nithyashree1608@gmail.com # email address for notifications
#SBATCH --mail-type=END # mail me when my jobs ends
#SBATCH --mail-type=FAIL # mail me if my jobs fails

############# CODE #############
#this first filters snps only of good quality
vcffilter -f "QUAL > 20" -f "TYPE = snp" /mnt/data/project0026/student_data/2933044s/lab3/mySNPs.vcf>/mnt/data/project0026/student_data/2933044s/lab3/filteredSNPs.vcf 

#now seperately snps unique to each line into their own files
bcftools view -l 0  -s WT -c 1 /mnt/data/project0026/student_data/2933044s/lab3/filteredSNPs.vcf -o /mnt/data/project0026/student_data/2933044s/lab3/wtonly.vcf.gz 
bcftools view -l 0  -s AmpB -c 1 /mnt/data/project0026/student_data/2933044s/lab3/filteredSNPs.vcf -o /mnt/data/project0026/student_data/2933044s/lab3/ampbonly.vcf.gz 

#using the seperate files and using bcftools isec to find the complement of each file relative to the other. 
bcftools isec /mnt/data/project0026/student_data/2933044s/lab3/ampbonly.vcf.gz /mnt/data/project0026/student_data/2933044s/lab3/wtonly.vcf.gz -O v -p /mnt/data/project0026/student_data/2933044s/lab3/isec/

#annotating SNPs using snpEff
snpEff -Xmx4g ann -c /mnt/data/project0026/student_data/2933044s/lab3/SnpEff.config Lmex -no-intron -no SPLICE_SITE_REGION /mnt/data/project0026/student_data/2933044s/lab3/ampbunique.vcf > /mnt/data/project0026/student_data/2933044s/lab3/annotatedAmpB.vcf

#extract Non_Synonymous Variants only using snpsift and formatting the output
cat /mnt/data/project0026/student_data/2933044s/lab3/annotatedAmpB.vcf | vcfEffOnePerLine.pl | SnpSift extractFields - CHROM POS REF ALT "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].GENE" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "GEN[*].GT" | grep 'HIGH\|MODERATE' > finalsnpsift.tsv
