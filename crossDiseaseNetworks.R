#script to generate cross disease state analyses

require(synapseClient)
synapseLogin()

source('networkSummary.R')

models <- list()

#NCI: 
models$nciSummary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','NCI','syn2397881','DLPFC')
#MCI
models$mciSummary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','MCI','syn2397881','DLPFC')
#AD
models$adSummary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','AD','syn2397881','DLPFC')
#BRAAK12
models$braak12Summary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','BRAAK12','syn2397881','DLPFC')
#BRAAK34
models$braak34Summary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','BRAAK34','syn2397881','DLPFC')
#BRAAK56
models$braak56Summary <- grabNetworkAnalysisResults3('rankconsensus','sparrow2Bonferroni','BRAAK56','syn2397881','DLPFC')

makeFilesForCytoscape(models$nciSummary,'ncinet.csv','ncimod.csv')
makeFilesForCytoscape(models$mciSummary,'mcinet.csv','mcimod.csv')
makeFilesForCytoscape(models$adSummary,'adnet.csv','admod.csv')
makeFilesForCytoscape(models$braak12Summary,'braak12net.csv','braak12mod.csv')
makeFilesForCytoscape(models$braak34Summary,'braak34net.csv','braak34mod.csv')
makeFilesForCytoscape(models$braak56Summary,'braak56net.csv','braak56mod.csv')

####table of percent edge overlap
require(dplyr)
overlapTable <- matrix(0,6,6)
colnames(overlapTable) <- c('NCI','MCI','AD','BRAAK12','BRAAK34','BRAAK56')
rownames(overlapTable) <- c('NCI','MCI','AD','BRAAK12','BRAAK34','BRAAK56')

oddsRatioTable <- matrix(0,6,6)
colnames(oddsRatioTable) <- c('NCI','MCI','AD','BRAAK12','BRAAK34','BRAAK56')
rownames(oddsRatioTable) <- c('NCI','MCI','AD','BRAAK12','BRAAK34','BRAAK56')

#wup <- which(upper.tri(as.matrix(models[[1]][[1]])))
sharedName <- colnames(models[[1]][[1]])
for (i in 2:6){
  sharedName <- intersect(sharedName,colnames(models[[i]][[1]]))  
}
for (i in 1:6){
  models[[i]][[1]] <- models[[i]][[1]][sharedName,sharedName]
}

wup <- which(upper.tri(as.matrix(models[[1]][[1]])))

for (i in 1:5){
  vec1 <- models[[i]][[1]] %>% as.matrix
  vec1 <- vec1[wup]
  for (j in (i+1):6){
    
    vec2 <- models[[j]][[1]] %>% as.matrix
    vec2 <- vec2[wup]
    
    a11 <- sum(vec1==1 & vec2 ==1)
    a12 <- sum(vec1==1 & vec2 ==0)
    a21 <- sum(vec1==0 & vec2 ==1)
    a22 <- sum(vec1==0 & vec2 ==0) 
    a1 <- sum(vec1==1)
    a2 <- sum(vec2==1)
    tab1 <- matrix(c(a11,a12,a21,a22),2,2)

    overlapTable[i,j] <- a11/a1
    overlapTable[j,i] <- a11/a2
    
    oddsRatioTable[i,j] <- fisher.test(tab1)$estimate
    print(overlapTable)
    print(oddsRatioTable)
    gc()
  }
  #gc()
}
for (i in 1:6){
  cat(sum(models[[i]][[1]])/2,'\n')
}


require(dplyr)

getAD <- function(x){
  return(dplyr::filter(x$enrichments,category=='ADRelated' & fdr <=0.05))
}

adLists <- lapply(models,getAD)

write.csv(adLists[[1]],file='nciAdEnrich.csv',quote=F,row.names=F)
write.csv(adLists[[2]],file='mciAdEnrich.csv',quote=F,row.names=F)
write.csv(adLists[[3]],file='adAdEnrich.csv',quote=F,row.names=F)
write.csv(adLists[[4]],file='braak12AdEnrich.csv',quote=F,row.names=F)
write.csv(adLists[[5]],file='braak34AdEnrich.csv',quote=F,row.names=F)
write.csv(adLists[[6]],file='braak56AdEnrich.csv',quote=F,row.names=F)

