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

newMat <- filter(bar,speakEasyModuleCount>19)
speakEasyMods <- unique(newMat$speakeasyModule)
newMat <- filter(bar,megenaModuleCount>19)
megenaMods <- unique(newMat$megenaModule)
newMat <- filter(bar,metanetworkModuleCount>19)
metanetworkMods <- unique(newMat$metanetworkModule)

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

speakeasyVmetanetworkPval <- biSapply(fisherWrapperPval,speakEasyList,metanetworkList,unique(bar$geneName))
sEmNThres <- speakeasyVmetanetworkPval
sEmNThres[speakeasyVmetanetworkPval>0.05/(18053)] <- 0
sEmNThres[speakeasyVmetanetworkPval<=0.05/(18053)] <- 1

speakeasyVmegenaPval <- biSapply(fisherWrapperPval,speakEasyList,megenaList,unique(bar$geneName))
sEmGThres <- speakeasyVmegenaPval
sEmGThres[speakeasyVmegenaPval>0.05/(18053)] <- 0
sEmGThres[speakeasyVmegenaPval<=0.05/(18053)] <- 1

metanetworkVmegenaPval <- biSapply(fisherWrapperPval,metanetworkList,megenaList,unique(bar$geneName))
mNmGThres <- metanetworkVmegenaPval
mNmGThres[metanetworkVmegenaPval>0.05/(18053)] <- 0
mNmGThres[metanetworkVmegenaPval<=0.05/(18053)] <- 1


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



fullMat <- makeAdjacency(t(sEmNThres),t(sEmGThres),t(mNmGThres))
setF <- c(rep(2,46),rep(3,35),rep(4,203))
set1 <- setF == 2 | setF == 3
set2 <- setF == 2 | setF == 4
set3 <- setF == 3 | setF == 4
          
plot.network(as.network.matrix(fullMat[set1,set1]),vertex.col=c(rep(2,46),rep(3,35),rep(4,203))[set1],usearrows=F)
plot.network(as.network.matrix(fullMat[set2,set2]),vertex.col=c(rep(2,46),rep(3,35),rep(4,203))[set2],usearrows=F)
plot.network(as.network.matrix(fullMat[set3,set3]),vertex.col=c(rep(2,46),rep(3,35),rep(4,203))[set3],usearrows=F)
