require(synapseClient)
synapseLogin()



getAllNetworks <- function(x){
  #synResult <- synQuery('select name,id from file where projectId==\'syn3455058\' and networkStorageType==\'sparse\'')
  y <- synGet(x)
  load(y@filePath)
  return(sparseNetwork)
}

#get ppi
ppisyn <- synGet('syn4552965')
load(ppisyn@filePath)
synResult <- synQuery('select name,id from file where projectId==\'syn3455058\' and networkStorageType==\'sparse\' and normalization==\'None\' and disease==\'Schizophrenia\'')

computePower <- function(net,true){
  power <- sum(net!=0 & true !=0)/(sum(true!=0)/2)
  cat(signif(power,2),'\n')
  return(power)
  
}

computeTDR <- function(net,true){
  tp <- sum(net!=0 & true !=0)
  fp <- sum(net!=0 & true ==0)
  tdr <- tp/(tp+fp)
  cat(signif(tdr,2),'\n')
  return(tdr)
}

allNets <- lapply(synResult$file.id,getAllNetworks)
powerVec <- sapply(allNets,computePower,trueMat)
fdrVec <- sapply(allNets,computeFDR,trueMat)

