require(synapseClient)
require(dplyr)
require(data.table)

synapseLogin()

foo <- synGet('syn5260130')
bar <- fread(foo@filePath,data.table=F,stringsAsFactors = F)

listify <- function(x,y,z){
  return(unique(y[which(z==x)]))
}


internal <- function(x,y){
  tab1 <- table(x)
  tab2 <- tab1
  for (i in 1:length(tab1)){
    tab2[i] <- length(unique(y[x==names(tab1)[i]]))
  }
  return(tab2[x])
}
bar <- dplyr::mutate(bar,
                      speakEasyModuleCount=internal(speakeasyModule,geneName),
                      megenaModuleCount=internal(megenaModule,geneName),
                      metanetworkModuleCount=internal(metanetworkModule,geneName))
#bar3 <- filter(bar2,speakEasyModuleCount>19  megenaModuleCount>19 & metanetworkModuleCount > 19)

countTable <- c()

newMat <- filter(bar,speakEasyModuleCount>19)
speakEasyMods <- unique(newMat$speakeasyModule)
countTable <- c(countTable,length(speakEasyMods))
newMat <- filter(bar,megenaModuleCount>19)
megenaMods <- unique(newMat$megenaModule)
countTable <- c(countTable,length(megenaMods))
newMat <- filter(bar,metanetworkModuleCount>19)
metanetworkMods <- unique(newMat$metanetworkModule)
countTable <- c(countTable,length(metanetworkMods))

nModTable <- data.frame(modSize=as.numeric(countTable),method=c('SpeakEasy','Metanetwork','MEGENA'))

barplot(nModTable$modSize)


newMat <- filter(bar,speakEasyModuleCount>19)
speakEasyList <- sapply(speakEasyMods,
                        listify,
                        newMat$geneName,
                        newMat$speakeasyModule)
names(speakEasyList) <- speakEasyMods

newMat <- filter(bar,megenaModuleCount>19)
megenaList <- sapply(megenaMods,
                     listify,
                     newMat$geneName,
                     newMat$megenaModule)
names(megenaList) <- megenaMods

newMat <- filter(bar,metanetworkModuleCount>19)
metanetworkList <- sapply(metanetworkMods,
                          listify,
                          newMat$geneName,
                          newMat$metanetworkModule)
names(metanetworkList) <- metanetworkMods


require(devtools)
install_github('blogsdon/utilityFunctions')
require(utilityFunctions)

fisherWrapperOR <- function(moduleGenes,annotationGenes,allGenes){
  a00 <- sum(!(allGenes%in%moduleGenes) & !(allGenes%in%annotationGenes))
  a10 <- sum((allGenes%in%moduleGenes) & !(allGenes%in%annotationGenes))
  a01 <- sum(!(allGenes%in%moduleGenes) & (allGenes%in%annotationGenes))
  a11 <- sum((allGenes%in%moduleGenes) & (allGenes%in%annotationGenes))
  bar <- matrix(c(a00,a10,a01,a11),2,2)
  #print(bar)
  foo <- fisher.test(bar,alternative='greater')
  return(foo$estimate)
}


fisherWrapperPval <- function(moduleGenes,annotationGenes,allGenes){
  a00 <- sum(!(allGenes%in%moduleGenes) & !(allGenes%in%annotationGenes))
  a10 <- sum((allGenes%in%moduleGenes) & !(allGenes%in%annotationGenes))
  a01 <- sum(!(allGenes%in%moduleGenes) & (allGenes%in%annotationGenes))
  a11 <- sum((allGenes%in%moduleGenes) & (allGenes%in%annotationGenes))
  bar <- matrix(c(a00,a10,a01,a11),2,2)
  #print(bar)
  foo <- fisher.test(bar,alternative='greater')
  return(foo$p.value)
}

speakeasyVmetanetworkPval <- t(biSapply(fisherWrapperPval,speakEasyList,metanetworkList,unique(bar$geneName)))
speakeasyVmetanetworkOR <- t(biSapply(fisherWrapperOR,speakEasyList,metanetworkList,unique(bar$geneName)))
sEmNThres <- speakeasyVmetanetworkPval
sEmNThres[speakeasyVmetanetworkPval>0.05/(18302)] <- 0
sEmNThres[speakeasyVmetanetworkPval<=0.05/(18302)] <- 1

speakeasyVmegenaPval <- t(biSapply(fisherWrapperPval,speakEasyList,megenaList,unique(bar$geneName)))
speakeasyVmegenaOR <- t(biSapply(fisherWrapperOR,speakEasyList,megenaList,unique(bar$geneName)))
sEmGThres <- speakeasyVmegenaPval
sEmGThres[speakeasyVmegenaPval>0.05/(18302)] <- 0
sEmGThres[speakeasyVmegenaPval<=0.05/(18302)] <- 1

metanetworkVmegenaPval <- t(biSapply(fisherWrapperPval,metanetworkList,megenaList,unique(bar$geneName)))
metanetworkVmegenaOR <- t(biSapply(fisherWrapperOR,metanetworkList,megenaList,unique(bar$geneName)))
mNmGThres <- metanetworkVmegenaPval
mNmGThres[metanetworkVmegenaPval>0.05/(18302)] <- 0
mNmGThres[metanetworkVmegenaPval<=0.05/(18302)] <- 1


####fix ordering
#greedy depth first search
reSortModuleComparison <- function(x){
  vec1 <- 1:nrow(x)
  vec2 <- 1:ncol(x)
  vec1n <- c()
  vec2n <- c()
  p <- min(nrow(x),ncol(x))
  x2 <- x
  foo <- min(x2)
  while(nrow(x2)>0 & ncol(x2) >0 & foo < 0.05/18302){
    foo <- min(x2)
    bar <- which(x==foo,T)
    #print(bar)
    #print(foo)
    if((!bar[1]%in%vec1n)&(!bar[2]%in%vec2n)){
      #cat('here\n')
      #cat(bar[1],bar[2],'\n')
      #print(x2)
      vec1n <- c(vec1n,bar[1])
      vec2n <- c(vec2n,bar[2])
      x2 <- x[-vec1n,-vec2n]
    }
  }
  return(list(rowInd=c(vec1n),colInd=c(vec2n)))
}

foo <- reSortModuleComparison(speakeasyVmetanetworkPval)
foo2 <- reSortModuleComparison(speakeasyVmegenaPval)
foo3 <- reSortModuleComparison(metanetworkVmegenaPval)


heatmap(sEmNThres[foo$rowInd,foo$colInd],scale='none',Rowv = NA,Colv = NA,col=c('white','grey50'),xlab='SpeakEasy Modules',ylab='Metanetwork Modules',main='')
heatmap(sEmGThres[foo2$rowInd,foo2$colInd],scale='none',Rowv = NA,Colv = NA,col=c('white','grey50'),xlab='SpeakEasy Modules',ylab='Megena Modules',main='',margins=c(5,6))
heatmap(mNmGThres[foo3$rowInd,foo3$colInd],scale='none',Rowv = NA,Colv = NA,col=c('white','grey50'),xlab='Metanetwork Modules',ylab='Megena Modules',main='',margins=c(5,6.5))

library(metanetwork)


makeAdjacency <- function(A,B,C){
  n1 <- nrow(A)
  n2 <- ncol(A)
  n3 <- ncol(B)
  ntot <- n1+n2+n3
  mat1 <- matrix(0,ntot,ntot)
  varNames <- c(paste0('se',rownames(A)),paste0('mn',colnames(A)),colnames(B))
  rownames(mat1) <- varNames
  colnames(mat1) <- varNames
  mat1[paste0('se',rownames(A)),paste0('mn',colnames(A))] <- A
  mat1[paste0('se',rownames(B)),colnames(B)] <- B
  mat1[paste0('mn',rownames(C)),colnames(C)] <- C
  mat1 <- mat1+ t(mat1)
  return(mat1)
}



fullMat <- makeAdjacency((sEmNThres),(sEmGThres),(mNmGThres))
setF <- c(rep(2,46),rep(3,36),rep(4,203))
set1 <- setF == 2 | setF == 3
set2 <- setF == 2 | setF == 4
set3 <- setF == 3 | setF == 4

plot.network(as.network.matrix(fullMat),vertex.col=c(rep(2,46),rep(3,36),rep(4,203)),usearrows=F)
plot.network(as.network.matrix(fullMat[set1,set1]),vertex.col=c(rep(2,46),rep(3,36),rep(4,203))[set1],usearrows=F)          
plot.network(as.network.matrix(fullMat[set2,set2]),vertex.col=c(rep(2,46),rep(3,36),rep(4,203))[set2],usearrows=F)
plot.network(as.network.matrix(fullMat[set3,set3]),vertex.col=c(rep(2,46),rep(3,36),rep(4,203))[set3],usearrows=F)

require(igraph)
g = igraph::graph.adjacency(fullMat, mode = 'undirected', weighted = T, diag = F)

threeWayCliques <- (((cliques(g,min=3,max=3))))
mg3 <- grep('comp',threeWayCliques)
mn3 <- grep('mn',threeWayCliques)
se3 <- grep('se',threeWayCliques)

internal2 <- function(x,y){
  x <- names(x)
  print(x)
  baz <- dplyr::filter(y,speakeasyModule==strsplit(x[1],'se')[[1]][2] & megenaModule==x[3] & metanetworkModule == strsplit(x[2],'mn')[[1]][2])
  return(unique(baz$hgncName))
}

genesAcrossModules <- sapply(threeWayCliques,internal2,bar)
ln1 <- sapply(genesAcrossModules,length)
cat(genesAcrossModules[[12]],file='~/Desktop/bigOverlap.out',sep='\n')
cat(unique(bar$hgncName),file='~/Desktop/background.out',sep='\n')

restrictMat <- dplyr::filter(bar,speakeasyModule=='116' & metanetworkModule=='12' & megenaModule=='comp2_4')


twoWayCliques <- table(names(unlist(cliques(g,min=2,max=2))))


#enrichments
mnEnrObj <- synGet('syn5262001')
mnEnr <- fread(mnEnrObj@filePath,stringsAsFactors = F,data.table=F)
mnEnr[1:5,]
mnEnr <- dplyr::arrange(mnEnr,fdr)
mnEnr[1:100,]
ad <- filter(mnEnr,category=='ADRelated')
ad[1:40,]

go <- dplyr::filter(mnEnr,category=='GO_Biological_Process')
table(go$ComparisonName)[1:37]
dplyr::filter(go,ComparisonName=='darkolivegreen')[1:20,]
