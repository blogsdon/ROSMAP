require(synapseClient)
synapseLogin()

mods <- synQuery('select name,id from file where projectId==\'syn2397881\' and disease==\'AD\' and moduleMethod==\'igraph:fast_greedy\'')

enrV <- grep('Fisher',mods$file.name)

mods <- mods[-enrV,]

#mods <- synGet(mods$file.id[121])


############## build consensus clusters ############

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



a <- lapply(mods$file.id,synGet)
require(data.table);
newMat <- matrix(0,22899,22899)
for (i in 1:length(a)){
  modsSp <- fread(a[[i]]@filePath)
  gc()
  modsSp <- data.frame(modsSp)
  gc()
  modsSp$moduleNumber <- alternativeModulesId[modsSp$moduleNumber]
  gc()
  newMat <- newMat+buildAdjacency(modsSp)
  gc()
}



#download all files
#load all modules
#make matrix with all genes
#write function that produces adjacency from modules
#add to all gene matrix

