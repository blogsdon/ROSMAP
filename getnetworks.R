require(synapseClient)
synapseLogin()


networkTable <- synQuery('select name,id from file where parentId==\'syn4259680\'')


require(dplyr)

downloadNetworks <- function(synId){
  synObj <- synGet(synId)
  return(synObj)
}

allNetworks <- sapply(networkTable$file.id,downloadNetworks)
names(allNetworks) <- networkTable$file.name

sparsities <- read.csv(allNetworks[[13]]@filePath)

sparrow1 <- read.csv(allNetworks[[11]]@filePath,row.names=1)

write.csv(sparrow1[1:180,],file='sparrow1bonferroni.csv',quote=F,row.names=F)

