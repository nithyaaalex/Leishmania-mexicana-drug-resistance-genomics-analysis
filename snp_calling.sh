#!/bin/bash -l

############# SLURM SETTINGS #############

#SBATCH --account=project0026 # the project account - don't change this
#SBATCH --job-name=snpcalling_step1_alex # give your job a name!
#SBATCH --partition=nodes # we are using CPU nodes - don't change this
#SBATCH --time=0-04:00:00 # how long do we expect this job to run?
#SBATCH --mem=4G # how much memory do we want?
#SBATCH --nodes=1 # how many nodes do we want?
#SBATCH --ntasks=1 # how many tasks are we submitting?
#SBATCH --cpus-per-task=2 # how many CPUs do we want for each task?
#SBATCH --ntasks-per-node=1 # how many tasks do we want to run on each node?
#SBATCH --mail-user=nithyashree1608@gmail.com # email address for notifications
#SBATCH --mail-type=END # mail me when my jobs ends
#SBATCH --mail-type=FAIL # mail me if my jobs fails

############# CODE #############
#we are assuming diploid organism - from ploidy analysis
bamaddrg -b /mnt/data/project0026/student_data/2933044s/lab1/LmexWT.sorted.bam -s WT -b /mnt/data/project0026/student_data/2933044s/lab1/LmexAmpB.sorted.bam -s AmpB | freebayes  -f /mnt/data/project0026/student_data/2933044s/pathogenPolyomicsData/Reference/TriTrypDB-25_LmexicanaMHOMGT2001U1103.fa -p 2 --stdin --vcf /mnt/data/project0026/student_data/2933044s/lab2/mySNPs.vcf

