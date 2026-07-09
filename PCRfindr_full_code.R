
#install.packages("devtools")
#devtools::install_github("mhahsler/rBLAST")
#BiocManager::install("BSgenome")

#######Load libraries #########
library(rBLAST)
library (seqinr)
library (EnvNJ)
library("Biostrings")
library("BSgenome")
library("GenomicRanges")
library("seqinr")
library ("stringr")



Sys.which("blastn")

### Load in Fasta seq####
#concatinate all fasta files in directory
filenames <- Sys.glob("*.fasta")
filenames=sub('.fasta', '', basename(filenames))

#### Check if concatenated.fasta exists already ######


fastaconc(filenames, inputdir = ".", out.file = "./concatenated.fasta")



######


#### Build blast database#########
makeblastdb("concatenated.fasta", db_name="proteusdatabase", hash_index = F)
bl=blast(db = "proteusdatabase")




###Load guide genome######
guide=readDNAStringSet("GCF_000069965.1_ASM6996v1_genomic.fasta")
guide =guide$`NC_010554.1 Proteus mirabilis HI4320, complete sequence`



print ("loaded guide genome")

#guide



###########################################################################
########### Operate sliding window over guide genome in for loop ##########
###########################################################################

querysize=100


results=data.frame()
write.table (results, "results.csv")

i=1
while (i < (length(guide)-(querysize-1))){


#Subset query, convert to DNAstringset
quer=guide[i:(i+querysize-1)]
quer=DNAStringSet(quer)

#Do blast
res=predict(bl,quer, BLAST_args = "-task dc-megablast -num_threads 4")

print (str_sort (filenames))
print (str_sort (res$sseqid))

output= cbind(i, mean(res$pident), length(res$sseqid), all(str_sort(filenames)==str_sort(res$sseqid)))
write.table( output,  file="results.csv",  append = T, sep=',',  row.names=F, col.names=F )

print ( paste("position",i,"till", (i+querysize-1)))

i=i+querysize
}



#############################################################
#############Initial analysis of results optional############
#############################################################
amplicon_size=900
top_nr=200
filename="results.csv"

data=read.csv(filename, header=F)
colnames(data)=c("Pos", "Sim", "Nrhit", "All_strains")

amplicon_segnr=amplicon_size/querysize
results=data.frame()

for (i in 1:(length (data$Pos)-amplicon_segnr)){
  

  
  if (data[i,4]==1 & data [(i+amplicon_segnr-1),4]==1 & is.na(data[i, 2])==F & is.na(data [(i+amplicon_segnr-1), 2])==F)
  {
    
  
    
    prim1=data[i,2]
    prim2=data [(i+amplicon_segnr-1),2]
    
    con_primer_score=  mean (c(prim1,prim2))- abs (prim1-prim2)
    
    div_center_score = mean (data [(i+1):(i+amplicon_segnr-2),2], na.rm=T)
    
    results=rbind (results, c(i, data$Pos[i], data$Pos[i+amplicon_segnr-1]+querysize-1, prim1, prim2, con_primer_score, div_center_score))
    
    
    
  }
  
  
}

colnames(results)=c("Segnr", "Seg_start_pos", "Seg_end_pos", "Primer start", "Primer end", "con_primer_score", "div_center_score")
results 

results$combined_score=results$con_primer_score/results$div_center_score



results = results [order (results$combined_score, decreasing=T),]


results$rank=1:length(results$Segnr)

result_contig=guide[results$Seg_start_pos[1]:results$Seg_end_pos[1]]
result_contig=toString(DNAStringSet(result_contig))



##################################################
######### Definitive analysis of results##########
######### New analysis 2 #########################


amplicon_size=900
top_nr=10
filename="results.csv"
con_threshold=92

data=read.csv(filename, header=F)
colnames(data)=c("Pos", "Sim", "Nrhit", "All_strains")

amplicon_segnr=amplicon_size/querysize
results=data.frame()

for (i in 1:(length (data$Pos)-amplicon_segnr)){
  
  
  
  if (data[i,4]==1 & data [(i+amplicon_segnr-1),4]==1 & is.na(data[i, 2])==F & is.na(data [(i+amplicon_segnr-1), 2])==F)
  {
    

    
    prim1=data[i,2]
    prim2=data [(i+amplicon_segnr-1),2]
    
    con_primer_score=  mean (c(prim1,prim2))
    
    
    div_center_score = mean (data [(i+1):(i+amplicon_segnr-2),2], na.rm=T)
    
    
    results=rbind (results, c(i, data$Pos[i], data$Pos[i+amplicon_segnr-1]+querysize-1, prim1, prim2, con_primer_score, div_center_score))
    
    
    
  }
  
  
}

colnames(results)=c("Segnr", "Seg_start_pos", "Seg_end_pos", "Primer start", "Primer end", "con_primer_score", "div_center_score")


results=subset (results, results$con_primer_score>con_threshold)


results = results [order (results$div_center_score, decreasing=F),]

results$rank=1:length(results$Segnr)

results


