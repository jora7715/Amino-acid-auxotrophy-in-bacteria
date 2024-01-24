####PARSING GENOME ANNOTATIONS FROM GAPMIND TO PREDICT AA BIOSYNTHESIS CAPABILITIES IN BACTERIA

rm(list=ls()) 

##READ IN OUTPUT FILE FROM GAPMIND
gap.out = read.csv("C:/CU_Boulder/Auxotrophies/2022-10-09_bacteria_auxotrophies_subset_all.txt", header = T, sep = ",")
head(gap.out)

length(unique(gap.out$genomeName)) #62291 unique genomes for GTDB r207

##GET PATHWAY LENGTH
gap.out$gene.number = gap.out$nHi + gap.out$nMed + gap.out$nLo #Get total pathway length for each AA based on the sum of genes that had a low, medium, or high confidence hit

##DECIDE CUTOFF ON THE NUMBER OF GENES THAT NEED TO BE MISSING FROM A GIVEN AA BIOSYNTHESIS PATHWAY TO CONSIDER AN ORGANISM AUXOTROPHIC FOR THAT GIVEN AA
#gap.out$Prototrophy.strict.20 = ifelse(gap.out$nLo / gap.out$gene.number >= 0.20, 0, 1)
#gap.out$Prototrophy.strict.30 = ifelse(gap.out$nLo / gap.out$gene.number >= 0.30, 0, 1)
gap.out$Prototrophy.strict.40 = ifelse(gap.out$nLo / gap.out$gene.number >= 0.40, 0, 1) #SUGGESTED AS OF SEP 2023 FOR CONSERVATIVE ESTIMATES OF AA AUXOTROPHY IN BACTERIA
#gap.out$Prototrophy.strict.50 = ifelse(gap.out$nLo / gap.out$gene.number >= 0.50, 0, 1)

head(gap.out)

#write.csv(gap.out, "YOURDIRECTORY/Auxotrophies_gtdb_parsed.csv")

