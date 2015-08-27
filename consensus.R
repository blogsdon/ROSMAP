##build robust consensus


load('result_aracneFull.rda')
network <- as.matrix(network)
whichUpperTri <- which(upper.tri(network))

internal <- function(str,w1){
  cat(str,'\n')
  load(str)
  network <- as.matrix(network)
  gc()
  b <- network[w1]
  rm(network)
  gc()
  return(b)
}
methods <- c('result_aracneFull.rda','result_correlation.rda','result_genie3.rda','result_lassoAIC.rda','result_lassoBIC.rda','result_lassoCV1se.rda','result_lassoCVmin.rda','result_ridgeAIC.rda','result_ridgeBIC.rda','result_ridgeCV1se.rda','result_ridgeCVmin.rda','result_sparrowZ.rda','result_sparrow2Z.rda','result_tigress.rda')

fullNetwork <- sapply(methods,internal,whichUpperTri)
