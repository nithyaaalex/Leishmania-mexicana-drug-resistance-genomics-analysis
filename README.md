Grade: A3; Analysing genomics data using UNIX command line to find SNPs involved in drug resistance

Input required:
1. Paired-end fastq files with phred64 encoding.
2. Leishmania mexicana reference genome: L. mexicana MHOM/GT/2001/U1103.


What the code does:
1. Data processing involved trimming low-quality reads followed by alignment of the reads to the reference genome. (in the trimming_alignment.sh)
2. Finds single nucleotide polymorphisms, which are then used to find all variants in both samples. (snp_calling.sh)
3. The ploidy of the overall genome is estimated. (in ploidy_analysis.py)
4. Next, the variants were filtered to only keep SNPs of high quality.
5. Of these SNPs, those that were unique to the AmpB resistant line, present in a gene, and causing a missense or nonsense mutation 
would be helpful to see any underlying mechanism for resistance, so the pool was filtered further.
6. Finally, the list of genes in which these SNPs were found was submitted to TriTrypDB for understanding which pathways these genes were involved in.
Steps 4, 5 and 6 were implemented in snp_analysis.sh.
