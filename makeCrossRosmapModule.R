
makeTemporaryRosmapModules <- function(y){
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
	return(newMods)
}
