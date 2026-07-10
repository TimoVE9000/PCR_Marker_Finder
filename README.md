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
This process might take a very long time depending on the size of the guide genome, consider running on HPC if available.

## Analysis of results
For the analysis you first select an aproximate desired amplicon size, this needs to be a multiple of 100bp (due to the 100bp chuncks in the previous step), in this case we used 900 bp (this works well with current Sanger sequencing pipelines).
Now for each possible amplicon, three scores are calculated:
- Con_primer_score: how conserved the 100bp chunks at the end and beginning of the amplicon, where the primers should bind are in the set of species
- Div_center_score: how divergent the middle of the amplicon is between the different species in the database (i.e. not counting the 100bp chunks at both ends)

Next the results are sorted for a maximal combined score (Con_primer_score/Div_center_score), thereby optimizing for an amplicon with a divergent center (i.e. very different between species to discrimnate them) and conserved ends (so that primers will consistently bind in all species). Amplicons where the 100 bp chunks at both ends did not appear exactly once in each species were also filtered out (Not present in all species or Copynr larger than one). To view the resulting amplicions, the "Seg_start_pos", "Seg_end_pos" can be used, as they indicate the location of the amplicon in the guide genome. Simply look up the guide genome in NCBI (in this case the associated genbank nr is AM942759.1), go to change region shown, go to selected region, enter these numbers, then click "fasta" to view the amplicion or graphics to see which gene is being amplified. Use this to manually select candidate amplicons. 



### Genomes used for the Proteus genus in this study
- Proteus mirabilis HI4320: GCF_000069965.1_ASM6996v1_genomic (used as "guide genome")
- Proteus vulgaris strain ATCC 49132: GCF_000754995.1_PVA_genomic
- Proteus myxofaciens ATCC 19692: GCF_001654855.1_Cmy19692_DRAFTv1_genomic
- Proteus columbae strain 08MAS2615: GCF_002777965.1_ASM277796v1_genomic
- Proteus cibi strain FJ2001126-3: GCF_003144405.1_ASM314440v1_genomic
- Proteus hauseri strain 15H5D-4a: GCF_004116975.1_ASM411697v1_genomic
- Proteus terrae subsp. cibarius strain ZN2: GCF_011045835.1_ASM1104583v1_genomic
- Proteus penneri strain S178-2: GCF_022369495.1_ASM2236949v1_genomic

