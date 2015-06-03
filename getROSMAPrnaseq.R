#login to synapse client
require(synapseClient)
synapseLogin()

#query Sage Lilly Project for ROSMAP data 
exprDataSets <- synQuery('select name,id from file where parentId==\'syn4259356\'')

#load necessary libraries, dplyr
require(dplyr)

#grab all the synapse objects
synObj <- exprDataSets$file.id %>% sapply(synGet)

names(synObj) <- exprDataSets$file.name

rosmapRNAseqResiduals <- read.delim(synObj[[5]]@filePath,stringsAsFactors=F)

rosmapClinical <- read.delim(synObj[[3]]@filePath,stringsAsFactors=F)

#synchronize expression and clinical data-sets
rnaseq_samples <- colnames(rosmapRNAseqResiduals)[-c(1:2)]

#remove the X from the sample ids that was introduced by R
rnaseq_samples <- sapply(rnaseq_samples,function(x) strsplit(x,'X')[[1]][2])
colnames(rosmapRNAseqResiduals) <- c('ensembl','hgnc',rnaseq_samples)
#test if there is a difference between the rnaseq and clinical sample IDs
sum(rosmapClinical$SampleID!=rnaseq_samples)

#look at cogdx
table(rosmapClinical$cogdx)

#We are going to create NCI, MCI, and AD data-sets
NCIrna <- rosmapRNAseqResiduals[,c('ensembl','hgnc',rosmapClinical$SampleID[rosmapClinical$cogdx==1])]

MCIrna <- rosmapRNAseqResiduals[,c('ensembl','hgnc',rosmapClinical$SampleID[rosmapClinical$cogdx==2])]

ADrna <- rosmapRNAseqResiduals[,c('ensembl','hgnc',rosmapClinical$SampleID[rosmapClinical$cogdx==4])]

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




