#functions to build all the relevant network results

grabNetworkAnalysisResults3 <- function(method,sparsityMethod,disease,projectId,tissueType){
  require(synapseClient)
  synapseLogin()
  queryStatement <- paste0('select name,id from file where projectId==\'',projectId,'\' and disease==\'',disease,'\' and sparsityMethod==\'',sparsityMethod,'\' and method ==\'',method,'\' and tissueType==\'',tissueType,'\'')
  cat(queryStatement,'\n')
  foo <- synQuery(queryStatement)  
  bar <- lapply(foo$file.id,synGet)
  load(bar[[which(foo$file.name=='rankconsensussparrow2Bonferroni.rda')]]@filePath)
  require(dplyr)
  require(data.table)
  sparrow2Sparse <- list(network=sparseNetwork,
                         modules=fread(bar[[which(foo$file.name=='rankconsensussparrow2Bonferroni fast_greedy Modules')]]@filePath)%>%data.frame,
                         enrichments=fread(bar[[which(foo$file.name=='rankconsensussparrow2Bonferroni fast_greedy Enrichment Fisher')]]@filePath)%>%data.frame)
  sparrow2Sparse$enrichments <- arrange(sparrow2Sparse$enrichments,fdr)
  return(sparrow2Sparse)  
}

makeFilesForCytoscape <- function(x,networkFile,moduleFile){
  require(dplyr)
  nMods <- sum(table(x$modules$moduleNumber)>20)
  mods <- filter(x$modules,moduleNumber%in%1:nMods)
  x$network <- x$network %>% as.matrix
  allAdj <- x$network[mods$GeneIDs,mods$GeneIDs] %>% as.matrix
  library(metanetwork)
  alledgeList <- rankedEdgeList(allAdj,symmetric=T)
  exprFile <- synGet('syn4259377')
  require(data.table);
  expr <- fread(exprFile@filePath,header=T)
  expr <- data.frame(expr)
  
  hgnc <- expr$hgnc_symbol
  names(hgnc) <- expr$ensembl_gene_id
  
  alledgeList$var1 <- hgnc[mods$GeneIDs][alledgeList$var1]
  alledgeList$var2 <- hgnc[mods$GeneIDs][alledgeList$var2]
  
  alledgeList <- filter(alledgeList,!is.na(var1))
  alledgeList <- filter(alledgeList,!is.na(var2))
  alledgeList <- filter(alledgeList,var1!='')
  alledgeList <- filter(alledgeList,var2!='')
  write.csv(alledgeList,file=networkFile,quote=F,row.names=F)
  mod2 <- dplyr::select(mods,GeneIDs,modulelabels)
  mod2$GeneIDs <- hgnc[mod2$GeneIDs]
  write.csv(mod2,file=moduleFile,quote=F,row.names=F)
}


makeFilesForCytoscape2 <- function(x,networkFile,moduleFile){
  require(dplyr)
  nMods <- sum(table(x$modules$moduleNumber)>20)
  mods <- filter(x$modules,moduleNumber%in%1:nMods)
  x$network <- x$network %>% as.matrix
  allAdj <- x$network[mods$GeneIDs,mods$GeneIDs] %>% as.matrix
  library(metanetwork)
  alledgeList <- rankedEdgeList(allAdj,symmetric=T)
  #exprFile <- synGet('syn4259377')
  #require(data.table);
  #expr <- fread(exprFile@filePath,header=T)
  #expr <- data.frame(expr)
  
  #hgnc <- expr$hgnc_symbol
  #names(hgnc) <- expr$ensembl_gene_id
  hgnc <- rownames(x$network)
  names(hgnc) <- hgnc
  
  alledgeList$var1 <- hgnc[alledgeList$var1]
  alledgeList$var2 <- hgnc[alledgeList$var2]
  
  alledgeList <- filter(alledgeList,!is.na(var1))
  alledgeList <- filter(alledgeList,!is.na(var2))
  alledgeList <- filter(alledgeList,var1!='')
  alledgeList <- filter(alledgeList,var2!='')
  write.csv(alledgeList,file=networkFile,quote=F,row.names=F)
  mod2 <- dplyr::select(mods,GeneIDs,modulelabels)
  mod2$GeneIDs <- hgnc[mod2$GeneIDs]
  write.csv(mod2,file=moduleFile,quote=F,row.names=F)
}


makeEnrichmentSummary <- function(x){
  require(dplyr)
  require(data.table)
  nMods <- sum(table(x$modules$moduleNumber)>20)
  cat(nMods)
  nameKeep <- filter(x$modules,moduleNumber%in%1:nMods)[,3] %>%  
    table %>% 
    sort(decreasing=T) %>% 
    names
  cat(nameKeep,'\n')  
  
  
  internal <- function(y,x){
    green <- filter(x$enrichments,ComparisonName==y)
    greenSplit <- lapply(names(table(green$category)),function(x,y) return(filter(y,category==x)),green)
    names(greenSplit) <- names(table(green$category))
    summarygreen <- do.call(rbind,lapply(greenSplit,function(x) return(x[1:5,c('GeneSetName','category','pval','noverlap','OR','fdr')])))
    try(summarygreen <- arrange(summarygreen,fdr),silent=TRUE)
    return(summarygreen)
  }
  
  res <- lapply(nameKeep,internal,x)
  names(res) <- nameKeep
  return(res)
}

populateADenrichments <- function(x){
  require(dplyr)
  require(data.table)
  nMods <- sum(table(x$modules$moduleNumber)>20)
  cat(nMods)
  nameKeep <- filter(x$modules,moduleNumber%in%1:nMods)[,3] %>%  
    table %>% 
    sort(decreasing=T) %>% 
    names
  cat(nameKeep,'\n')
  internal <- function(x,y){
    filter(y,ComparisonName==x & category =='ADRelated')
  }
  res <- lapply(nameKeep,internal,x$enrichments)
  names(res) <- nameKeep
  return(res)
}
