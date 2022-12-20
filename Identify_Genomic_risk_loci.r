library(dplyr)

Pathway_geno="/scratch/ys98038/UKB/plink2_format/PUFA_GWAS/Summary_statistics/"
Pathway_out="/scratch/ys98038/UKB/plink2_format/PUFA_GWAS/Summary_statistics/"

PUFA_LIST=c("FAw3","FAw6","MUFA","DHA","LA")

for (n in PUFA_LIST) {
  Trait1_final_infile=paste(Pathway_geno,"META_IVW_",n,".clumped.ranges", sep="")
  
  #  Trait1_final <- read.table(Trait1_final_infile,header=T,as.is=T,sep = "\t")
  Trait1_final <- read.table(Trait1_final_infile,header=T)
  
  Trait1_final$POS_new=sapply(strsplit(Trait1_final$POS, split= ":", fixed=TRUE),"[",2)
  
  Trait1_final$POS_begin=sapply(strsplit(Trait1_final$POS_new, split= "..", fixed=TRUE),"[",1)
  Trait1_final$POS_end=sapply(strsplit(Trait1_final$POS_new, split= "..", fixed=TRUE),"[",2)
  
  Trait1_final$POS_begin=as.numeric(Trait1_final$POS_begin)
  Trait1_final$POS_end=as.numeric(Trait1_final$POS_end)
  
  Trait1_final$POS_begin_250=Trait1_final$POS_begin-250000
  Trait1_final$POS_end_250= Trait1_final$POS_end+250000
  
  require(GenomicRanges)
  Trait2_final=as.data.frame(reduce(GRanges(Trait1_final$CHR, IRanges(Trait1_final$POS_begin_250, Trait1_final$POS_end_250))))
  
  Trait2_final$seqnames=as.numeric(as.character(Trait2_final$seqnames))
  Trait2_final=Trait2_final[order(Trait2_final$seqnames),]
  
  # Trait2_final$start=Trait2_final$start+250000
  # Trait2_final$end=Trait2_final$end-250000
  # Trait2_final$width=Trait2_final$width-500000
  
  Trait2_final<-Trait2_final%>%select(seqnames,start,end,width)
  
  Outputfile=paste(Pathway_out,"META_IVW_Range_with_250_",n, ".txt", sep="")
  write.table(Trait2_final, file= Outputfile, col.names = T, append = TRUE, row.names = FALSE, quote = FALSE, sep='\t')
}

  
  
Trait1_final_infile=paste(Pathway_geno,"Summary_statistics_MAGNETIC_",n,"_EUR_250_range.clumped.ranges", sep="")
  
Outputfile=paste(Pathway_out,"META_MAGNETIC_IVW_Range_",n, ".txt", sep="")

