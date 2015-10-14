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
NCIrna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$cogdx==1]))]

MCIrna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$cogdx==2]))]

ADrna <- rosmapRNAseqResiduals[,as.character(c('ensembl_gene_id','hgnc_symbol',rosmapClinical$projid[rosmapClinical$cogdx==4]))]

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

NCIrna <- cleanRMdata(NCIrna)
NCIrna$expr <- apply(NCIrna$expr,2,winsorize)
NCIrna$expr <- scale(NCIrna$expr)

MCIrna <- cleanRMdata(MCIrna)
MCIrna$expr <- apply(MCIrna$expr,2,winsorize)
MCIrna$expr <- scale(MCIrna$expr)

ADrna <- cleanRMdata(ADrna)
ADrna$expr <- apply(ADrna$expr,2,winsorize)
ADrna$expr <- scale(ADrna$expr)

###write the data to files
write.csv(NCIrna$expr,file='NCIrna.csv',quote=F)
write.csv(MCIrna$expr,file='MCIrna.csv',quote=F)
write.csv(ADrna$expr,file='ADrna.csv',quote=F)




