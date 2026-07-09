# PCR_Marker_Finder
This is the pipeline used to find suitable PCR marker genes for the Proteus genus. It is a bit hacky and slow. 

## Dependencies
This programme relies on several dependencies
- R devtools
- BLAST+ software: https://www.ncbi.nlm.nih.gov/books/NBK52637/
- Bioconductor (and several packages install through it): https://www.bioconductor.org/install/
- R blast package: https://github.com/mhahsler/rBLAST
- Several packages from Bioconductor & CRAN (see code)



## Creating a database
To create a blast database, place all the relevant genomes in fasta format (in my case 8 Proteus genomes, see list below) in the same folder as the main R script. Once the script runs, it will concatinate all the genomes into a single fasta file (concatenated.fasta).
Then, it will use this fasta file to build a blast database. 

## Run the sliding window analysis
Next a single one of the genomes is selected as a "guide genome". This genome is blasted against the previously created database in 100bp chunks. 
For each chunk the following is saved as a line in a file csv (resuts.csv): Position (Pos), Mean percentage similarity of hits with query (Sim), Nr of blast hits (Nrhit), Logical variable  if all of the original genomes are represented in the results (All_strains)
This process might take a very long time depending on the size of the guide genome. 





### Genomes used for the Proteus genus for in this study
- Proteus mirabilis HI4320: GCF_000069965.1_ASM6996v1_genomic (guide genome)
- Proteus vulgaris strain ATCC 49132: GCF_000754995.1_PVA_genomic
- Proteus myxofaciens ATCC 19692: GCF_001654855.1_Cmy19692_DRAFTv1_genomic
- Proteus columbae strain 08MAS2615: GCF_002777965.1_ASM277796v1_genomic
- Proteus cibi strain FJ2001126-3: GCF_003144405.1_ASM314440v1_genomic
- Proteus hauseri strain 15H5D-4a: GCF_004116975.1_ASM411697v1_genomic
- Proteus terrae subsp. cibarius strain ZN2: GCF_011045835.1_ASM1104583v1_genomic
- Proteus penneri strain S178-2: GCF_022369495.1_ASM2236949v1_genomic

