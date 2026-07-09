# PCR_Marker_Finder
This is the pipeline used to find suitable PCR marker genes for the Proteus genus. It is a bit hacky and slow, so you may want to refine it if you reuse it.

## Dependencies
It relies on several dependencies that are not installed from CRAN
-R devtools
-BLAST+ software: https://www.ncbi.nlm.nih.gov/books/NBK52637/
-Bioconductor (and several packages install through it): https://www.bioconductor.org/install/
-R blast package: https://github.com/mhahsler/rBLAST



## Creating a database
Place all the the genomes you want to use 






### Genomes used for the Proteus genus for this study
-Proteus mirabilis HI4320: GCF_000069965.1_ASM6996v1_genomic
-Proteus vulgaris strain ATCC 49132: GCF_000754995.1_PVA_genomic
-Proteus myxofaciens ATCC 19692: GCF_001654855.1_Cmy19692_DRAFTv1_genomic
-Proteus columbae strain 08MAS2615: GCF_002777965.1_ASM277796v1_genomic
-Proteus cibi strain FJ2001126-3: GCF_003144405.1_ASM314440v1_genomic
-Proteus hauseri strain 15H5D-4a: GCF_004116975.1_ASM411697v1_genomic
-Proteus terrae subsp. cibarius strain ZN2: GCF_011045835.1_ASM1104583v1_genomic
-Proteus penneri strain S178-2: GCF_022369495.1_ASM2236949v1_genomic

