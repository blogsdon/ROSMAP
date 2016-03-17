#login to synapse client
require(synapseClient)
synapseLogin()

#query Sage Lilly Project for ROSMAP data 
exprDataSets <- synQuery('select name,id from file where parentId==\'syn4259356\'')
braakDataSets <- synQuery('select name,id from file where parentId==\'syn4935399\'')

#load necessary libraries, dplyr
require(dplyr)
require(data.table)

#grab all the synapse objects
synObj <- exprDataSets$file.id %>% sapply(synGet)
synObjBraak <- braakDataSets$file.id %>% sapply(synGet)

synClin <- synGet('syn3191087')

names(synObj) <- exprDataSets$file.name
names(synObjBraak) <- braakDataSets$file.name

rosmapRNAseqResiduals <- fread(synObjBraak[[3]]@filePath,stringsAsFactors=F,data.table=F,header=T)
rosmapClinical <- fread(synClin@filePath,stringsAsFactors=F,data.table=F)


#synchronize expression and clinical data-sets
rnaseq_samples <- colnames(rosmapRNAseqResiduals)[-c(1:2)]

#remove the X from the sample ids that was introduced by R
#rnaseq_samples <- sapply(rnaseq_samples,function(x) strsplit(x,'X')[[1]][2])
#colnames(rosmapRNAseqResiduals) <- c('ensembl','hgnc',rnaseq_samples)
#test if there is a difference between the rnaseq and clinical sample IDs
#sum(rosmapClinical$SampleID!=rnaseq_samples)
ind1 <- 1:length(rosmapClinical$projid)
names(ind1) <- rosmapClinical$projid
rosmapClinicalOld <- rosmapClinical
rosmapClinical <- rosmapClinical[ind1[rnaseq_samples],]



#harmonize

#look at braaksc
table(rosmapClinical$braaksc)

#We are going to create NCI, MCI, and AD data-sets
BRAAK12rna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$braaksc==1 | rosmapClinical$braaksc ==2]))]

BRAAK34rna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$braaksc==3 | rosmapClinical$braaksc ==4]))]

BRAAK56rna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$braaksc == 5 | rosmapClinical$braaksc == 6]))]

#Next, let's transpose and standardize these data-sets
#grab gene names


winsorize <- function(x,per=.99){
  up <- quantile(x,per)
  low <- quantile(x,1-per)
  x[x>=up] <- up
  x[x<=low] <- low
  return(x)
}

cleanRMdata <- function(NCIrna){
  model <- list()
  model$hgncNames <- NCIrna[,2]
  model$ensemblNames <- NCIrna[,1]
  
  #transpose and remove gene names
  NCIrna <- t(NCIrna[,-c(1,2)])
  
  #go from data.frame to matrix
  NCIrna <- as.matrix(NCIrna)
  
  #make it numeric
  NCIrna <- apply(NCIrna,1,as.numeric)
  
  #define ensembl gene names as rownames
  rownames(NCIrna) <- model$ensemblNames
  print(dim(NCIrna))
  #standardize variables
  model$expr <- t(NCIrna)
  return(model)
}

####clean up the data:

BRAAK12rna <- cleanRMdata(BRAAK12rna)
BRAAK12rna$expr <- apply(BRAAK12rna$expr,2,winsorize)
BRAAK12rna$expr <- scale(BRAAK12rna$expr)

BRAAK34rna <- cleanRMdata(BRAAK34rna)
BRAAK34rna$expr <- apply(BRAAK34rna$expr,2,winsorize)
BRAAK34rna$expr <- scale(BRAAK34rna$expr)

BRAAK56rna <- cleanRMdata(BRAAK56rna)
BRAAK56rna$expr <- apply(BRAAK56rna$expr,2,winsorize)
BRAAK56rna$expr <- scale(BRAAK56rna$expr)

###write the data to files
write.csv(BRAAK12rna$expr,file='BRAAK12rna.csv',quote=F)
write.csv(BRAAK34rna$expr,file='BRAAK34rna.csv',quote=F)
write.csv(BRAAK56rna$expr,file='BRAAK56rna.csv',quote=F)




