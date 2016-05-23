#login to synapse client
require(synapseClient)
library(dplyr)
library(utilityFunctions)

synapseLogin()

covariatesObj <- synGet('syn6114444')
residualExpressionObj <- synGet('syn6114451')

library(data.table)
rosmapCovariates <- fread(covariatesObj@filePath,data.table=F,stringsAsFactors=F)
rosmapExpression <- fread(residualExpressionObj@filePath,data.table=F,stringsAsFactors=F)

rosmapExpression2 <- t(rosmapExpression[,-c(1,2)])
colnames(rosmapExpression2) <- rosmapExpression$ensembl_gene_id

#NCI
rosmapExpression2[dplyr::filter(rosmapCovariates,cogdx==1)$Sampleid,] %>%
  apply(2,utilityFunctions::winsorize) %>%
  scale %>%
  write.csv(file='rosmapNCIRNAseq.csv',quote=F)

#MCI
rosmapExpression2[dplyr::filter(rosmapCovariates,cogdx==2)$Sampleid,] %>%
  apply(2,utilityFunctions::winsorize) %>%
  scale %>%
  write.csv(file='rosmapMCIRNAseq.csv',quote=F)

#AD
rosmapExpression2[dplyr::filter(rosmapCovariates,cogdx==4)$Sampleid,] %>%
  apply(2,utilityFunctions::winsorize) %>%
  scale %>%
  write.csv(file='rosmapADRNAseq.csv',quote=F)

rosmapExpression2 <- apply(rosmapExpression2,2,utilityFunctions::winsorize)
rosmapExpression2 <- scale(rosmapExpression2)

write.csv(rosmapExpression2,file='rosmapRNAseq.csv',quote=F)
