####function to produce consensus models.


produceConsensusNetwork <- function(tags,ngenes,downloadLocation){
  #load necessary packages
  require(synapseClient)
  require(dplyr)
  require(Matrix)

  synapseLogin()
  #tags: filters for synQuery
  mapTagsToString <- function(tags){
    
    foo <- paste0('select name,id from file where networkStorageType==\'',
                  tags$networkStorageType,
                  '\' and disease==\'',
                  tags$disease,
                  '\' and projectId==\'',
                  tags$projectId,
                  '\'')
    return(foo)
  }
  
  #get networks from synapse
  networkList <- tags %>%
              mapTagsToString() %>% 
              synQuery()
  
  wkeep <- grep('.rda',networkList$file.name)
  
  
  networkList <- networkList[wkeep,]
  
  #if necessary filter networkList
  networks <- networkList$file.id %>%
              lapply(function(x,y){ return(synGet(x,downloadLocation=y))},
                     downloadLocation)
  
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

#function to produce a consensus Module
produceConsensusModuleNetwork <- function(tags,ngenes,downloadLocation){}

#function to generate modules from consensus
fastGreedy <- function(consensus){}

#function to run quick enrichments on consensus

######TO DO:

###build consensus
###convert to markdown
###push up to synapse
###run enrichments
###push results to Synapse