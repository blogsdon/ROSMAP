require(synapseClient,warn.conflicts = F,quietly = T)
synapseLogin()

expressionFile <- synQuery('select name,
id
from file
where projectId==\'syn2397881\'
and study==\'ROSMAP\'
and adjusted==\'TRUE\'
and assay==\'RNAseq\'')

clinicalFile <- synQuery('select name,
id
from file
where projectId==\'syn2580853\'
and center==\'Broad-Rush\'
and dataType==\'clinical\'')
head(clinicalFile)

clinObj <- synGet(clinicalFile$file.id)
clinData <- read.csv(clinObj@filePath,row.names=1,stringsAsFactors=F)
head(clinData)

library(data.table)
rosmapExprObj <- synGet(expressionFile$file.id)
rosmapExpr <- read.delim(rosmapExprObj@filePath,sep='\t',stringsAsFactors=F)
rosmapExprGeneNames <- rosmapExpr[,1:2]
rosmapExprNew <- t(rosmapExpr[,-c(1:2)])
colnames(rosmapExprNew) <- rosmapExprGeneNames[,1]
rosmapExprNew <- cbind(rownames(rosmapExprNew),rosmapExprNew)
colnames(rosmapExprNew)[1] <- 'projid'
rosmapExprNew[1:5,1:5]

clinData$projid <- paste0('X',clinData$projid)
combinedData <- merge(clinData,rosmapExprNew,by='projid')
combinedData[1:5,1:20]

consensusModuleObj <- synGet('syn5578189')
consensusModule <- read.csv(consensusModuleObj@filePath,row.names=1)
table(consensusModule$consensus.cluster.id)

rosmapExprGeneNameNew <- merge(rosmapExprGeneNames,consensusModule,by.x='hgnc_symbol',by.y='gene.symbol')
extractEnsembl <- function(i,x){
  return(x$ensembl_gene_id[which(x$consensus.cluster.id==i)])
}
geneIds <- lapply(1:8,extractEnsembl,rosmapExprGeneNameNew)
computeEigenGene <- function(ind,x){
  library(dplyr)
  eigenGenes <- x[,ind]%>%
    apply(2,as.numeric) %>%
    scale %>%
    svd
  
  return(eigenGenes$u[,1])
}

###get all modules
allMods <- synTableQuery('SELECT * FROM syn5327481')
modules <- vector('list',16)
for(i in 3:18){
  cat(i,'\n')
  modules[[i-2]] <- lapply(unique(allMods@values[,i]),utilityFunctions::listify, allMods@values$geneName, allMods@values[,i])
  names(modules[[i-2]]) <- unique(allMods@values[,i])
  subUse <- which(sapply(modules[[i-2]],length)>20)
  modules[[i-2]] <- modules[[i-2]][subUse]
}
names(modules) <- colnames(allMods@values)[3:18]

eigenGeneList <- vector('list',16)
for (i in 1:16){
  cat(i,'\n')
  eigenGeneList[[i]] <- sapply(modules[[i]],computeEigenGene,combinedData)
  colnames(eigenGeneList[[i]]) <- paste0(names(modules)[i],'_',names(modules[[i]]))
}


eigenGeneFullMatrix <- do.call(cbind,eigenGeneList)
cogdxpval <- rep(0,ncol(eigenGeneFullMatrix))
braakpval <- rep(0,ncol(eigenGeneFullMatrix))
ceradpval <- rep(0,ncol(eigenGeneFullMatrix))
for(i in 1:ncol(eigenGeneFullMatrix)){
  foo <- summary(lm(eigenGeneFullMatrix[,i] ~ as.factor(combinedData$cogdx)))
  cogdxpval[i] <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
  
  foo <- summary(lm(eigenGeneFullMatrix[,i] ~ as.factor(combinedData$braaksc)))
  braakpval[i] <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
  
  foo <- summary(lm(eigenGeneFullMatrix[,i] ~ as.factor(combinedData$ceradsc)))
  ceradpval[i] <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
  #plot(as.factor(combinedData$cogdx),eigenGeneMatrix[,i],main=paste0('cogdx eigengene ',i,' anova p-value: ',signif(pval,2)),ylab='eigengene value', xlab='cogdx')
}

pvalMatrix <- cbind(cogdxpval,braakpval,ceradpval)
pvalMatrix <- cbind(rownames(pvalMatrix),pvalMatrix)
colnames(pvalMatrix)[1] <- c('module')
pvalMatrix <- data.frame(pvalMatrix,stringsAsFactors=F)
synapseUtilities::makeTable(pvalMatrix,'Preliminary ROSMAP Clinical Eigengene Results','syn4907617')

library(gap)
qqunif(cogdxpval)
which.min(cogdxpval)
plot((combinedData$cogdx),eigenGeneFullMatrix[,179],main=paste0('cogdx eigengene ',179,' anova p-value: ',signif(cogdxpval[179],2)),ylab='eigengene value', xlab='cogdx')
eigenGeneMatrix <- sapply(geneIds,computeEigenGene,combinedData)


for(i in 1:8){
foo <- summary(lm(eigenGeneMatrix[,i] ~ as.factor(combinedData$cogdx)))
pval <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
plot(as.factor(combinedData$cogdx),eigenGeneMatrix[,i],main=paste0('cogdx eigengene ',i,' anova p-value: ',signif(pval,2)),ylab='eigengene value', xlab='cogdx')
}

for(i in 1:8){
  foo <- summary(lm(eigenGeneMatrix[,i] ~ as.factor(combinedData$braaksc)))
  pval <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
  plot(as.factor(combinedData$cogdx),eigenGeneMatrix[,i],main=paste0('braaksc eigengene ',i,' anova p-value: ',signif(pval,2)),ylab='eigengene value', xlab='cogdx')
}

for(i in 1:8){
foo <- summary(lm(eigenGeneMatrix[,i] ~ as.factor(combinedData$ceradsc)))
pval <- pf(foo$fstatistic['value'],foo$fstatistic['numdf'],foo$fstatistic['dendf'],lower.tail=F)
plot(as.factor(combinedData$cogdx),eigenGeneMatrix[,i],main=paste0('ceradsc eigengene ',i,' anova p-value: ',signif(pval,2)),ylab='eigengene value', xlab='cogdx')
}
