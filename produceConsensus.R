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
  cat('synapse query: ',tags %>% mapTagsToString,'\n')
  
  #get networks from synapse
  networkList <- tags %>%
              mapTagsToString() %>% 
              synQuery()
  print(networkList[1:5,])
  
  wkeep <- grep('.rda',networkList$file.name)
  
  
  networkList <- networkList[wkeep,]
  
  print(networkList[1:5,])
  
  #if necessary filter networkList
  cat('grabbing networks\n')
  networks <- networkList$file.id %>%
              lapply(function(x,y){ return(synGet(x,downloadLocation=y))},
                     downloadLocation)
  
  #generate consensus matrix
  consensusNetwork <- 0 %>%
                      matrix(ngenes,ngenes)
  gc()
  cat('built empty network\n')
  #create consensus, one network at a time
  nl <- length(networks)
  for (i in 1:nl){
    load(networks[[i]]@filePath)
    sparseNetwork <- as.matrix(sparseNetwork)
    consensusNetwork <- consensusNetwork + sparseNetwork
    percentDone <- signif(100*(i/nl),2)
    if(percentDone%%5==0){
      cat(percentDone,'% done\n')
    }
    rm(sparseNetwork)
    gc()
  }
  return(consensusNetwork)
}

ngenes <- 22899
downloadLocation <- '/shared/ROSMAP/AD/'
ADtags <- list(networkStorageType='sparse',
             disease='AD',
             projectId='syn2397881')

ADconsensusNetwork <- produceConsensusNetwork(tags = ADtags,
                                              downloadLocation = downloadLocation, 
                                              ngenes = ngenes)
network <- ADconsensusNetwork/max(ADconsensusNetwork)
save(network,file='/shared/ROSMAP/AD/result_sparsityconsensus.rda')
require(metanetwork)


#function to produce a consensus Module
produceConsensusModuleNetwork <- function(tags,ngenes,downloadLocation){
  
  
  
  
  buildAdjacency <- function(df){
    mat <- df$moduleNumber%*%t(df$moduleNumber)
    gc()
    mat <- mat%in%unique(df$moduleNumber^2)
    gc()
    mat <- matrix(mat,nrow(df),nrow(df))
    gc()
    colnames(mat) <- df$GeneIDs
    gc()
    rownames(mat) <- df$GeneIDs
    gc()
    return(mat)
  }
  
  
  
  sieve <- function(n){
    n <- as.integer(n)
    if(n > 1e6) stop("n too large")
    primes <- rep(TRUE, n)
    primes[1] <- FALSE
    last.prime <- 2L
    for(i in last.prime:floor(sqrt(n)))
    {
      primes[seq.int(2L*last.prime, n, last.prime)] <- FALSE
      last.prime <- last.prime + min(which(primes[(last.prime+1):n]))
    }
    which(primes)
  }
  alternativeModulesId<-(sieve(2.6068e5))
  
  
  
  
  
}

#function to generate modules from consensus
fastGreedy <- function(consensus){}

#function to run quick enrichments on consensus

######TO DO:

###build consensus
###convert to markdown
###push up to synapse
###run enrichments
###push results to Synapse