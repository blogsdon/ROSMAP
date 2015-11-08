foo <- synGet('syn5177050')
load(foo@filePath)
require(igraph)
g = igraph::graph.adjacency(sparseNetwork, mode = 'undirected', weighted = T, diag = F)
mod = igraph::fastgreedy.community(g)

fxn1 <- function(x){
	foo <- strsplit(x,'ENSG')[[1]]
	el1 <- paste0(strsplit(foo[1],'\\.')[[1]],collapse='.')
	el2 <- paste0('ENSG',strsplit(foo[2],'\\.')[[1]][1])
	return(c(el1,el2))
}
unparsed <- rownames(sparseNetwork)
spngenes <- t(sapply(unparsed,fxn1))
newMods <- data.frame(hgncName=spngenes[,1],geneName=spngenes[,2],metanetworkModule=mod$membership,stringsAsFactors=F)

bar <- synGet('syn4974979')
require(data.table)
require(dplyr)

fun2 <- function(x){
	foo <- strsplit(x,'-')[[1]]
	foo <- paste0(foo,collapse='')
	foo <- strsplit(foo,'\\.')[[1]]
	foo <- paste0(foo,collapse='')
	return(foo)
}

semods <- fread(bar@filePath,data.table=F)
colnames(semods) <- c('hgncName','speakeasyModule')

combinedModules <- data.frame(geneName=newMods$geneName,hgncName=semods$hgncName,speakeasyModule=semods$speakeasyModule,metanetworkModule=newMods$metanetworkModule,stringsAsFactors=F)

write.csv(combinedModules,file='ROSMAP_metanetwork_speakeasy_modules.csv',quote=F)

ppi <- synGet('syn4896428')
load(ppi@filePath)

ccc <- intersect(spngenes[,1],colnames(ppi))
ppi2 <- ppi[ccc,ccc]
sparseNetwork2 <- sparseNetwork
rownames(sparseNetwork) <- spngenes[,1]
colnames(sparseNetwork) <- spngenes[,1]
sparseNetwork <- sparseNetwork[ccc,ccc]
dim(sparseNetwork)
dim(ppi2)
table(c(as.matrix(sparseNetwork)),c(as.matrix(ppi2)))
