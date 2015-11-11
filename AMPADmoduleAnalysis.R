#overlap analysis
#syn5004900
#syn5053449


require(synapseClient)
synapseLogin()

require(dplyr)
require(data.table)
speakEasyMetaNetworkObj <- synGet('syn5004900',version = 2)
megena <- synGet('syn5053449')


fun2 <- function(x){
  foo <- strsplit(x,'ENSG')[[1]]
  el1 <- paste0(strsplit(foo[1],'\\.')[[1]],collapse='.')
  el2 <- paste0('ENSG',strsplit(foo[2],'\\.')[[1]][1])
  return(c(el1,el2))
}


#combine megena

combinedModules <- fread(speakEasyMetaNetworkObj@filePath,data.table=F,stringsAsFactors = F)
megenaMods <- read.delim(megena@filePath,sep='\t',stringsAsFactors = F)

megenaProbeMap <- t(sapply(megenaMods$probe,fun2))

megenaMods$probe <- megenaProbeMap[,2]
megenaMods[,-1] <- megenaMods[,-1]=='YES'
moduleSize <- colSums(megenaMods[,-1])
plot(moduleSize)
#rmV <- moduleSize<20
megenaMods2 <- megenaMods[,-1]
lnv <- colnames(megenaMods2)
megenaMods2 <- apply(megenaMods2,2,as.numeric)
megenaMods2 <- data.frame(megenaMods2)
megenaMods2$probe <- megenaProbeMap[,2]

fun4 <- function(x,nl){
  #print(x)
  names(x) <- nl
  test <- which(x=="1")
  #print(test)
  if(length(test)>0){
    #cat('here\n')
    return(cbind(rep(x['probe'],length(test)),unlist(names(x)[which(x=="1")])))
  }
}

megenaModulesReduced <- apply(megenaMods2,1,fun4,colnames(megenaMods2))
combinedDataFrame <- do.call(rbind,megenaModulesReduced)
colnames(combinedDataFrame) <- c('geneName','megenaModule')
combinedDataFrame <- combinedDataFrame %>% data.frame

fullMerge <- merge(combinedDataFrame,combinedModules,by='geneName')
fullMerge <- fullMerge[,c(1,4,2,5,6)]

write.csv(fullMerge,file='ROSMAP_metanetwork_megena_speakeasy_modules.csv',quote=F)
foo <- File('ROSMAP_metanetwork_megena_speakeasy_modules.csv',parentId='syn4907617')
foo <- synStore(foo)

