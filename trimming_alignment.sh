#!/bin/bash -l

############# SLURM SETTINGS #############

#SBATCH --account=project0026 # the project account - don't change this
#SBATCH --job-name=trimming_and_alignment # give your job a name!
#SBATCH --partition=nodes # we are using CPU nodes - don't change this
#SBATCH --time=0-102:00:00 # how long do we expect this job to run?
#SBATCH --mem=4G # how much memory do we want?
#SBATCH --nodes=1 # how many nodes do we want?
#SBATCH --ntasks=1 # how many tasks are we submitting?
#SBATCH --cpus-per-task=2 # how many CPUs do we want for each task?
#SBATCH --ntasks-per-node=1 # how many tasks do we want to run on each node?
#SBATCH --mail-user=nithyashree1608@gmail.com # email address for notifications
#SBATCH --mail-type=END # mail me when my jobs ends
#SBATCH --mail-type=FAIL # mail me if my jobs fails

############# CODE #############

input_dir="/mnt/data/project0026/student_data/2933044s/pathogenPolyomicsData/DNAseq/"
output_dir="/mnt/data/project0026/student_data/2933044s/lab1/"
ref_file="/mnt/data/project0026/student_data/2933044s/pathogenPolyomicsData/Reference/TriTrypDB-25_LmexicanaMHOMGT2001U1103.fa"
bowtie_index="/mnt/data/project0026/student_data/2933044s/lab1/LmexRef"

for read1 in ${input_dir}/*_1.fastq.gz #performs fastqc and trimming
do
  base=$(basename "${read1}" "_1.fastq.gz") #extracts the base name for setting read2 name too
  read2="${input_dir}/${base}_2.fastq.gz"
  fastqc -o ${output_dir} ${read1}
  fastqc -o ${output_dir} ${read2}
  trim_galore --phred64 -q 20 --paired ${read1} {read2} -o ${output_dir}
done

bowtie2-build  -f ${ref_file} LmexRef

for read1 in ${output_dir}/*_1_val_1.fq.gz #performs alignment and formats the output files into sorted bam files for further processing
do
  base=$(basename "${read1}" "_1_val_1.fq.gz") #extracts the base name for setting read2 name too
  read2="${input_dir}/${base}_2_val_2.fq.gz"
  bowtie2 -x ${bowtie_index} -1 ${read1}  -2 ${read2} -p 2 --phred64 -S "${output_dir}/${base}.sam" 2>"${output_dir}/log_file_align_${base}.txt"
  samtools view -buS "${output_dir}/${base}.sam" | samtools sort -T tmp.bam > ${base}.sorted.bam
  bamCoverage -b "${output_dir}/${base}.sorted.bam" -o "${output_dir}/${base}coverage.bg" --outFileFormat bedgraph
done

