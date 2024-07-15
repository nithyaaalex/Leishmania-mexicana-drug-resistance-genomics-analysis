"""
TODO:
Copy the bedfiles to your local computer (use whichever method you prefer, eg., scp or FileZilla) 
and use R or Python to try to answer the following questions:
Can you calculate the median coverage over the whole genome for each sample?
How about for each chromosome?
How variable are the median coverage values for each chromosome?  What does this tell you about the ploidy?
Can you represent this information as a violin plot?
Are there any chromosome for which you might wish to call SNPs with different settings to what you used above?
"""
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

with open('tmp.txt','w') as my_file:
    my_file.write(f"type,chromosome,coverage,ploidy\n")


def median_calc(list_of_values):
    n = len(list_of_values) 
    list_of_values.sort() 
    
    if n % 2 == 0: 
        median1 = list_of_values[n//2] 
        median2 = list_of_values[n//2 - 1] 
        median = (median1 + median2)/2
    else: 
        median = list_of_values[n//2] 
    return median

#so the columns in the coverage file are as such: 1. chromosome number 2. start 3. end 4. no. of reads
for file in ['LmexAmpBcoverage.bw','LmexWTcoverage.bw']: 
    with open(file) as coverage_input: #file open
        median_coverage_over_genome = []
        count = 0 
        chromosome_coverage = {}
        for line in coverage_input: #iterating over the lines
            chromosome, start, end, coverage = line.rstrip().split('\t')
            if chromosome != "LmxM.00":
                if chromosome not in chromosome_coverage:
                    chromosome_coverage[chromosome] = [(int(coverage))]
                else:
                    chromosome_coverage[chromosome].append(int(coverage))
                median_coverage_over_genome.append(int(coverage))
                count +=1
        median_coverage_over_genome = median_calc(median_coverage_over_genome)
        print(f"The median coverage over the whole genome for {file} is: {round(median_coverage_over_genome,2)}")
        for chromosome, coverage in chromosome_coverage.items():
            #print(f"The coverage for the chromosome {chromosome} from {file} is {(coverage[0]/coverage[1])/50}")
            median_coverage_over_chromosome = median_calc(coverage)
            ploidy = round(median_coverage_over_chromosome/(median_coverage_over_genome/2),2)
            if file == 'LmexAmpBcoverage.bw':
                with open('tmp.txt','a') as my_file:
                    my_file.write(f"ampB,{chromosome},{round(median_coverage_over_chromosome,2)},{ploidy}\n")
            else:
                with open('tmp.txt','a') as my_file:
                    my_file.write(f"wt,{chromosome},{round(median_coverage_over_chromosome,2)},{ploidy}\n")
        print(f"\n")




#gc double peak probably about organellar genome - equivalent of mitochondria probably does that - also in any other case this would be contamination, here it is a case of knowing your organism
#take home note about fastqc - just coz something failed doesn't mean the sequencing is bad - also it is made for dna so things will not work the same for rna 
#alignment percent is 83 - its ok coz reference isn't perfect + organellar genome is not in the assembly + this percentage will be consistent with all alignments of this organism - KNOW THE ORGANISM!!!
#concordantly perfect - pairs aligned on opp strands - correct direction - all gg
#discordantly imperfect - pairs - only one aligned or - btoh on same strand - or wrong direction(one or both)
#for viewing coverage in igv - rigt click on the track and set data range set the max to 20

coveragedata = pd.read_csv("tmp.txt",sep = ',')

sns.violinplot(data=coveragedata, x='type', y= 'coverage')
plt.savefig('violin_better.png')
plt.clf()

#so the following plots arent the way to do it - gotta plot the raw values directly 
wtcoverage = coveragedata[coveragedata["type"]=='wt']
print(wtcoverage)
sns.violinplot(data=wtcoverage, x='chromosome', y= 'coverage')
plt.savefig('violin_wt.png')
plt.clf()

ampbcoverage = coveragedata[coveragedata["type"]=='ampB']
print(ampbcoverage)
sns.violinplot(data=ampbcoverage, x='chromosome', y= 'coverage')
plt.savefig('violin_ampb.png')
plt.clf()
