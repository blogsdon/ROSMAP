#find unique biology

rosmap <- read.csv('ROSMAP_metanetwork_megena_speakeasy_wgcna_modules_table.csv',stringsAsFactors = F)
mssm <- read.csv('../MSSM/MSSM_metanetwork_megena_speakeasy_wgcna_modules.csv',stringsAsFactors = F)
colnames(mssm)[c(1,2)] <- c('geneName','hgncName')

combMn <- merge(dplyr::select(rosmap,geneName,hgncName,metanetworkModule),
                dplyr::select(mssm,geneName,metanetworkModuleFP,metanetworkModuleSTG,metanetworkModulePHG),by='geneName')

combMn <- dplyr::filter(combMn,!duplicated(geneName))


internal <- function(x,y){
  tab1 <- table(x)
  tab2 <- tab1
  for (i in 1:length(tab1)){
    tab2[i] <- length(unique(y[x==names(tab1)[i]]))
  }
  return(tab2[x])
}

bar <- dplyr::mutate(combMn,
                     metanetworkModuleCount=internal(metanetworkModule,geneName),
                     metanetworkModuleFPCount=internal(metanetworkModuleFP,geneName),
                     metanetworkModuleSTGCount=internal(metanetworkModuleSTG,geneName),
                     metanetworkModulePHGCount=internal(metanetworkModulePHG,geneName))



newMat <- dplyr::filter(bar,metanetworkModuleCount>19)
metanetworkMods <- unique(newMat$metanetworkModule)

newMat <- dplyr::filter(bar,metanetworkModuleFPCount>19)
metanetworkModsFP <- unique(newMat$metanetworkModuleFP)

newMat <- dplyr::filter(bar,metanetworkModuleSTGCount>19)
metanetworkModsSTG <- unique(newMat$metanetworkModuleSTG)

newMat <- dplyr::filter(bar,metanetworkModulePHGCount>19)
metanetworkModsPHG <- unique(newMat$metanetworkModulePHG)

listify <- function(x,y,z){
  return(unique(y[which(z==x)]))
}

newMat <- dplyr::filter(bar,metanetworkModuleCount>19)
metanetworkList <- sapply(metanetworkMods,
                          listify,
                          newMat$geneName,
                          newMat$metanetworkModule)
names(metanetworkList) <- metanetworkMods

newMat <- dplyr::filter(bar,metanetworkModuleFPCount>19)
metanetworkListFP <- sapply(metanetworkModsFP,
                          listify,
                          newMat$geneName,
                          newMat$metanetworkModuleFP)
names(metanetworkListFP) <- metanetworkModsFP

newMat <- dplyr::filter(bar,metanetworkModuleSTGCount>19)
metanetworkListSTG <- sapply(metanetworkModsSTG,
                            listify,
                            newMat$geneName,
                            newMat$metanetworkModuleSTG)
names(metanetworkListSTG) <- metanetworkModsSTG

newMat <- dplyr::filter(bar,metanetworkModulePHGCount>19)
metanetworkListPHG <- sapply(metanetworkModsPHG,
                            listify,
                            newMat$geneName,
                            newMat$metanetworkModulePHG)
names(metanetworkListPHG) <- metanetworkModsPHG


require(utilityFunctions)


correction <- 0.05/ ( 34*35 + 34*40 + 34*37 + 35*40 + 35*37 + 40*37)

interMat <- list()

metanetworkVmetanetworkFPPval <- t(biSapply(fisherWrapperPval,metanetworkList,metanetworkListFP,unique(bar$geneName)))
interMat$mNmNFP <- metanetworkVmetanetworkFPPval < correction
metanetworkVmetanetworkSTGPval <- t(biSapply(fisherWrapperPval,metanetworkList,metanetworkListSTG,unique(bar$geneName)))
interMat$mNmNSTG <- metanetworkVmetanetworkSTGPval < correction
metanetworkVmetanetworkPHGPval <- t(biSapply(fisherWrapperPval,metanetworkList,metanetworkListPHG,unique(bar$geneName)))
interMat$mNmNPHG <- metanetworkVmetanetworkPHGPval < correction
metanetworkFPVmetanetworkSTGPval <- t(biSapply(fisherWrapperPval,metanetworkListFP,metanetworkListSTG,unique(bar$geneName)))
interMat$mNFPmNSTG <- metanetworkFPVmetanetworkSTGPval < correction
metanetworkFPVmetanetworkPHGPval <- t(biSapply(fisherWrapperPval,metanetworkListFP,metanetworkListPHG,unique(bar$geneName)))
interMat$mNFPmNPHG <- metanetworkFPVmetanetworkPHGPval < correction
metanetworkSTGVmetanetworkPHGPval <- t(biSapply(fisherWrapperPval,metanetworkListSTG,metanetworkListPHG,unique(bar$geneName)))
interMat$mNSTGmNPHG <- metanetworkSTGVmetanetworkPHGPval < correction


makeAdjacency <- function(enrList){
  nM <- length(enrList)
  n1 <- nrow(enrList[[1]])
  n2 <- ncol(enrList[[1]])
  n3 <- ncol(enrList[[2]])
  n4 <- ncol(enrList[[3]])
  ntot <- n1+n2+n3+n4
  mat1 <- matrix(0,ntot,ntot)
  varNames <- c(paste0('mn',rownames(enrList[[1]])),
                paste0('mnFP',colnames(enrList[[1]])),
                paste0('mnSTG',colnames(enrList[[2]])),
                paste0('mnPHG',colnames(enrList[[3]])))
  rownames(mat1) <- varNames
  colnames(mat1) <- varNames
  mat1[paste0('mn',rownames(enrList[[1]])),paste0('mnFP',colnames(enrList[[1]]))] <- enrList[[1]]
  mat1[paste0('mn',rownames(enrList[[2]])),paste0('mnSTG',colnames(enrList[[2]]))] <- enrList[[2]]
  mat1[paste0('mn',rownames(enrList[[3]])),paste0('mnPHG',colnames(enrList[[3]]))] <- enrList[[3]]
  mat1[paste0('mnFP',rownames(enrList[[4]])),paste0('mnSTG',colnames(enrList[[4]]))] <- enrList[[4]]
  mat1[paste0('mnFP',rownames(enrList[[5]])),paste0('mnPHG',colnames(enrList[[5]]))] <- enrList[[5]]
  mat1[paste0('mnSTG',rownames(enrList[[6]])),paste0('mnPHG',colnames(enrList[[6]]))] <- enrList[[6]]  
  mat1 <- mat1+ t(mat1)
  return(mat1)
}


fullMat <- makeAdjacency(interMat)


require(igraph)
g = igraph::graph.adjacency(fullMat, mode = 'undirected', weighted = T, diag = F)

fourWayCliques <- (((cliques(g,min=4,max=4))))
threeWayCliques <- (((cliques(g,min=3,max=3))))

internal2 <- function(x,y){
  x <- names(x)
  print(x)
  baz <- dplyr::filter(y,metanetworkModule==strsplit(x[1],'mn')[[1]][2] & metanetworkModuleFP==strsplit(x[2],'mnFP')[[1]][2] & metanetworkModuleSTG == strsplit(x[3],'mnSTG')[[1]][2] & metanetworkModulePHG==strsplit(x[4],'mnPHG')[[1]][2])
  return(unique(baz$hgncName))
}

genesAcrossModules <- sapply(fourWayCliques,internal2,bar)
ln1 <- sapply(genesAcrossModules,length)
cat(genesAcrossModules[[5]],file='~/Desktop/mnunique.txt',sep='\n')
cat(unique(bar$hgncName),file='~/Desktop/bkgdnew.txt',sep='\n')
e