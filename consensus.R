##build robust consensus

require(bit64)
require(dplyr)
load('result_aracneFull.rda')
network <- as.matrix(network)
network <- network+t(network)
gc()
whichUpperTri <- which(upper.tri(network))
gc()
b <- network[whichUpperTri]
rm(network)
gc()
foo <- rank(-abs(b),ties.method='min')
aggregateRank <- foo %>% as.integer64
gc()
save(aggregateRank,file='aggregateRank.rda')


internal <- function(str,w1){
  cat(str,'\n')
  load(str)
  load('aggregateRank.rda')
  network <- as.matrix(network)
  network <- network+t(network)
  gc()
  b <- network[w1]
  rm(network)
  gc()
  foo <- rank(-abs(b),ties.method='min') %>% as.integer64
  aggregateRank <- aggregateRank + foo
  gc()
  save(aggregateRank,file='aggregateRank.rda')
}

methods <- c('result_correlation.rda','result_genie3.rda','result_lassoAIC.rda','result_lassoBIC.rda','result_lassoCV1se.rda','result_lassoCVmin.rda','result_ridgeAIC.rda','result_ridgeBIC.rda','result_ridgeCV1se.rda','result_ridgeCVmin.rda','result_sparrowZ.rda','result_sparrow2Z.rda','result_tigress.rda')

sapply(methods,internal,whichUpperTri)

rm(list=ls())
gc()

load('aggregateRank.rda')
finalRank <- rank(-aggregateRank,ties.method = 'min')
finalRank <- finalRank/max(finalRank)

load('result_lassoAIC.rda')
network <- as.matrix(network)
whichUpperTri <- which(upper.tri(network))
whichLowerTri <- which(lower.tri(network))
network[whichUpperTri] <- finalRank
network[whichLowerTri] <- 0
network <- network+t(network)

save(network,file='result_rankConsensus.rda')
