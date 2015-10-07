
# login to synapse --------------------------------------------------------

require(synapseClient)
synapseLogin()

# extracting networks -----------------------------------------------------
getNetworks <- function(projectId,disease,normalization){
  queryString <- paste0('select name,id from file where projectId==\'',
                        projectId,
                        '\' and disease==\'',
                        disease,
                        '\' and fileType==\'',
                        'rda',
                        '\' and normalization==\'',
                        normalization,'\'')
  res <- synQuery(queryString)
  return(res)
}
test <- getNetworks('syn2397881','AD','None')

allNets <- lapply(test$file.id,synGet)
getMethodKeys <- function(x){
  foo <- synGetAnnotations(x)
  return(foo[c('method','sparsityMethod')])
}
require(dplyr)
results <- t(sapply(allNets,getMethodKeys)) %>% data.frame

loadNetworks <- function(x){
  load(x@filePath)
  return(sparseNetwork)
}

allNetworks <- lapply(allNets,loadNetworks)

#get microglial genes
ab <- synGet('syn4893059')
load(ab@filePath)

exprFile <- synGet('syn4259377')
require(data.table);
expr <- fread(exprFile@filePath,header=T)
expr <- data.frame(expr)

hgnc <- expr$hgnc_symbol
names(hgnc) <- expr$ensembl_gene_id
microglialInd <- hgnc%in% GeneSets$`Zhang:Microglia`

getMean <- function(x,w1){
  foo <- mean(x[w1,w1])
  print(foo)
  return(foo)
}
getRandomMean <- function(x,p,r){
  w1 <- sample(1:r,p)
  foo <- mean(x[w1,w1])
  print(foo)
  return(foo)
}
results$mgConnectivity <- sapply(allNetworks,getMean,which(microglialInd))
results$randMgConnectivity <- sapply(allNetworks,getRandomMean,506,22899)

test2 <- results %>% group_by(sparsityMethod) %>% summarise(avg=mean(randMgConnectivity),std=sd(randMgConnectivity))
blah<-right_join(filter(results,method=='rankconsensus'),test2,by='sparsityMethod')
blah <- mutate(blah,fold=mgConnectivity/avg)
select(blah,sparsityMethod,fold)

