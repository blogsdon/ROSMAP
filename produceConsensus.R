####function to produce consensus models.


produceConsensusNetwork <- function(tags,ngenes,downloadLocation){
  #load necessary packages
  require(dplyr)
  require(Matrix)

  #tags: filters for synQuery
  mapTagsToString <- function(tags){}
  
  #get networks from synapse
  networkList <- tags %>%
              mapTagsToString() %>% 
              synQuery()
  
  #if necessary filter networkList
  networks <- networkList$file.id %>%
              synGet(downloadLocation=downloadLocation)
  
  #generate consensus matrix
  consensusNetwork <- 0 %>%
                      matrix(ngenes,ngenes) %>%
                      Matrix(sparse=TRUE)
  gc()

  #create consensus, one network at a time
  nl <- length(networks)
  for (i in 1:nl){
    load(networks[[i]]@filePath)
    consensusNetwork <- consensusNetwork + sparseNetwork
    rm(sparseNetwork)
    gc()
  }
  
  return(consensusNetwork)
}