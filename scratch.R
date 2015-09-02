#scratch



require(synapseClient)
synapseLogin()
require(data.table)
require(dplyr)
a <- synGet('syn4899426')
b <- fread(a@filePath) %>% data.frame
b <- arrange(b,fdr)
b <- filter(b,fdr<0.05)
b <- filter(b,ComparisonName=='brown')
write.csv(b,file='~/Projects/AMP-AD-Network-Analysis/brownEnrichments.csv',quote=F,row.names=F)


#ridge CV1se (the best of the best)
foo <- synQuery('select name,id from file where projectId==\'syn2397881\' and disease==\'AD\' and sparsityMethod==\'sparrow2Bonferroni\' and method==\'ridgeCV1se\'')

bar <- lapply(foo$file.id,synGet)
load(bar[[1]]@filePath)
ridgeCV1seSparse <- list(network=sparseNetwork,
                         modules=fread(bar[[2]]@filePath)%>%data.frame,
                         nodeProperties=fread(bar[[3]]@filePath)%>%data.frame,
                         enrichments=fread(bar[[5]]@filePath)%>%data.frame)

ridgeCV1seSparse$enrichments <- arrange(ridgeCV1seSparse$enrichments,fdr)
green <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='green')

table(ridgeCV1seSparse$modules$modulelabels[ridgeCV1seSparse$modules$moduleNumber%in%1:13])

greenAD <- filter(green,category=='ADRelated')
blackAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='black' & category=='ADRelated')
blueAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='blue' & category=='ADRelated')
brownAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='brown' & category=='ADRelated')
redAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='red' & category=='ADRelated')
turquoiseAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='turquoise' & category=='ADRelated')
yellowAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='yellow' & category=='ADRelated')
pinkAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='pink' & category=='ADRelated')
salmonAD <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='pink' & category=='ADRelated')
yellow <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='yellow')


brown <- filter(ridgeCV1seSparse$enrichments,ComparisonName=='brown')
brownSplit <- lapply(names(table(brown$category)),function(x,y) return(filter(y,category==x)),brown)
names(brownSplit) <- names(table(brown$category))
summarybrown <- do.call(rbind,lapply(brownSplit,function(x) return(x[1:5,c('GeneSetName','category','pval','noverlap','OR','fdr')])))
summarybrown <- arrange(summarybrown,fdr)


#output ridge CV1se network

mods <- filter(ridgeCV1seSparse$modules,moduleNumber%in%1:13)
allAdj <- ridgeCV1seSparse$network[mods$GeneIDs,mods$GeneIDs] %>% as.matrix
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
write.csv(alledgeList,file='~/Projects/AMP-AD-Network-Analysis/allAlzROSMAP.csv',quote=F,row.names=F)
mod2 <- select(mods,GeneIDs,modulelabels)
mod2$GeneIDs <- hgnc[mod2$GeneIDs]
write.csv(mod2,file='~/Projects/AMP-AD-Network-Analysis/allAlzMods.csv',quote=F,row.names=F)


foo <- synQuery('select name,id from file where projectId==\'syn2397881\' and disease==\'AD\' and sparsityMethod==\'sparrow2Bonferroni\' and method==\'rankconsensus\'')

bar <- lapply(foo$file.id,synGet)
load(bar[[1]]@filePath)
require(dplyr)
require(data.table)
sparrow2Sparse <- list(network=sparseNetwork,
                         modules=fread(bar[[2]]@filePath)%>%data.frame,
                         nodeProperties=fread(bar[[3]]@filePath)%>%data.frame,
                         enrichments=fread(bar[[4]]@filePath)%>%data.frame)
sparrow2Sparse$enrichments <- arrange(sparrow2Sparse$enrichments,fdr)
sort(table(sparrow2Sparse$modules$modulelabels[sparrow2Sparse$modules$moduleNumber%in%1:21]),decreasing=T)


#greenAD <- filter(green,category=='ADRelated')
#testAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='yellow' & category=='ADRelated');testAD[1:5,]
redAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='red' & category=='ADRelated')
yellowAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='yellow' & category=='ADRelated')
brownAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='brown' & category=='ADRelated')
blueAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='blue' & category=='ADRelated')
turquoiseAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='turquoise' & category=='ADRelated')
blackAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='black' & category=='ADRelated')
pinkAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='pink' & category=='ADRelated')
magentaAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='magenta' & category=='ADRelated')
salmonAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='pink' & category=='ADRelated')
greenyellowAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='greenyellow' & category=='ADRelated')
greenAD <- filter(sparrow2Sparse$enrichments,ComparisonName=='green' & category=='ADRelated')
# green <- filter(sparrow2Sparse$enrichments,ComparisonName=='green')
# 
# 
 green <- filter(sparrow2Sparse$enrichments,ComparisonName=='green')
 greenSplit <- lapply(names(table(green$category)),function(x,y) return(filter(y,category==x)),green)
 names(greenSplit) <- names(table(green$category))
 summarygreen <- do.call(rbind,lapply(greenSplit,function(x) return(x[1:5,c('GeneSetName','category','pval','noverlap','OR','fdr')])))
 summarygreen <- arrange(summarygreen,fdr)


#output ridge CV1se network

mods <- filter(sparrow2Sparse$modules,moduleNumber%in%1:21)
allAdj <- sparrow2Sparse$network[mods$GeneIDs,mods$GeneIDs] %>% as.matrix
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
write.csv(alledgeList,file='~/Projects/AMP-AD-Network-Analysis/allAlzROSMAP.csv',quote=F,row.names=F)
mod2 <- select(mods,GeneIDs,modulelabels)
mod2$GeneIDs <- hgnc[mod2$GeneIDs]
write.csv(mod2,file='~/Projects/AMP-AD-Network-Analysis/allAlzMods.csv',quote=F,row.names=F)




###functions to spit out adjacency matrix for cytoscape, module categories, ad enrichments, enrichment summaries
grabNetworkAnalysisResults <- function(method,sparsityMethod,disease,projectId){
  require(synapseClient)
  synapseLogin()
  queryStatement <- paste0('select name,id from file where projectId==\'',projectId,'\' and disease==\'',disease,'\' and sparsityMethod==\'',sparsityMethod,'\' and method ==\'',method,'\'')
  cat(queryStatement,'\n')
  foo <- synQuery(queryStatement)  
  bar <- lapply(foo$file.id,synGet)
  load(bar[[1]]@filePath)
  require(dplyr)
  require(data.table)
  sparrow2Sparse <- list(network=sparseNetwork,
                         modules=fread(bar[[2]]@filePath)%>%data.frame,
                         nodeProperties=fread(bar[[3]]@filePath)%>%data.frame,
                         enrichments=fread(bar[[4]]@filePath)%>%data.frame)
  sparrow2Sparse$enrichments <- arrange(sparrow2Sparse$enrichments,fdr)
  return(sparrow2Sparse)  
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

makeFilesForCytoscape <- function(x,networkFile,moduleFile){
  require(dplyr)
  nMods <- sum(table(x$modules$moduleNumber)>20)
  mods <- filter(x$modules,moduleNumber%in%1:nMods)
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


makeFilesForCytoscape(nciAnalysisResults,'~/Projects/AMP-AD-Network-Analysis/nciRankConsensusNetwork.csv','~/Projects/AMP-AD-Network-Analysis/nciRankConsensusModules.csv')


adAnalysisResults<-grabNetworkAnalysisResults('rankconsensus','sparrow2Bonferroni','AD','syn2397881')
#grabNetworkAnalysisResults('rankconsensus','sparrow2Bonferroni','MCI','syn2397881')
nciAnalysisResults<-grabNetworkAnalysisResults('rankconsensus','sparrow2Bonferroni','NCI','syn2397881')

adADenrichments <- populateADenrichments(adAnalysisResults)
nciADenrichments <- populateADenrichments(nciAnalysisResults)

a <- lapply(nciADenrichments,function(x) return(x[1:5,]))
do.call(rbind,a)

nciAllEnrichments <- makeEnrichmentSummary(nciAnalysisResults)


#differential network analysis
require(WGCNA)
require(igraph)

diffNet <- adAnalysisResults$network - nciAnalysisResults$network
require(Matrix)
# Convert lsparseNetwork to igraph graph object
makeModule <- function(x){
  g = igraph::graph.adjacency(x, mode = 'undirected', weighted = T, diag = F)
  
  # Get modules using fast.greedy method (http://arxiv.org/abs/cond-mat/0408187)
  mod = igraph::fastgreedy.community(g)
  collectGarbage()
  
  # Get individual clusters from the igraph community object
  clust.numLabels = igraph::membership(mod)
  collectGarbage()
  
  # Change cluster number to color labels
  labels = WGCNA::labels2colors(clust.numLabels)
  
  # Get results
  geneModules = data.frame(GeneIDs = V(g)$name,
                           moduleNumber = as.numeric(clust.numLabels), 
                           modulelabels = labels)
  
  return(geneModules)  
}

alzSpecificMods <- makeModule(Matrix(diffNet==1,sparse=TRUE))
nciSpecificMods <- makeModule(Matrix(diffNet==-1,sparse=TRUE))


###enrichment analysis
runEnrichmentAnalysis <- function(MOD){
  library(synapseClient)
  library(dplyr)
  library(WGCNA)
  library(tools)
  library(stringr)
  library(igraph)
  library(data.table)
  library(biomaRt)
  filterGeneSets <- function(GeneLists, # List of lists
                             genesInBackground, # background set of genes
                             minSize = 10,
                             maxSize = 1000){
    GeneLists = lapply(GeneLists, 
                       function(x, genesInBackground){
                         x = lapply(x, 
                                    function(x, genesInBackground){
                                      return(intersect(x, genesInBackground))
                                    },
                                    genesInBackground)
                         return(x)
                       }, 
                       genesInBackground)
    
    GeneLists = lapply(GeneLists, 
                       function(x, minSize, maxSize){
                         len = sapply(x, length)
                         x = x[len>minSize & len<maxSize]
                         return(x)
                       },
                       minSize,
                       maxSize)
    len = sapply(GeneLists, length)
    GeneLists = GeneLists[len != 0]
    
    return(GeneLists)
  }
  
  # Function to perform Fishers enrichment analysis
  fisherEnrichment <- function(genesInSignificantSet, # A character vector of differentially expressed or some significant genes to test
                               genesInGeneSet, # A character vector of genes in gene set like GO annotations, pathways etc...
                               genesInBackground # Background genes that are 
  ){
    genesInSignificantSet = intersect(genesInSignificantSet, genesInBackground) # back ground filtering
    genesInNonSignificantSet = base::setdiff(genesInBackground, genesInSignificantSet)
    genesInGeneSet = intersect(genesInGeneSet, genesInBackground) # back ground filtering
    genesOutGeneSet = base::setdiff(genesInBackground,genesInGeneSet)
    
    pval = fisher.test(
      matrix(c(length(intersect(genesInGeneSet, genesInSignificantSet)),             
               length(intersect(genesInGeneSet, genesInNonSignificantSet)),
               length(intersect(genesOutGeneSet, genesInSignificantSet)),
               length(intersect(genesOutGeneSet, genesInNonSignificantSet))), 
             nrow=2, ncol=2),
      alternative="greater")
    OR = (length(intersect(genesInGeneSet, genesInSignificantSet)) * length(intersect(genesOutGeneSet, genesInNonSignificantSet))) / (length(intersect(genesInGeneSet, genesInNonSignificantSet)) * length(intersect(genesOutGeneSet, genesInSignificantSet)))
    return(data.frame(pval = pval$p.value,
                      ngenes = length(genesInGeneSet),
                      noverlap = length(intersect(genesInGeneSet, genesInSignificantSet)),
                      OR = OR 
    )
    )
  }
  
  # Function to convert rownames to first column of a df
  rownameToFirstColumn <- function(DF,colname){
    DF <- as.data.frame(DF)
    DF[,colname] <- row.names(DF)
    DF <- DF[,c(dim(DF)[2],1:(dim(DF)[2]-1))]
    return(DF)
  }
  
  # Download AD related gene sets from synapse
  GL_OBJ = synGet('syn4893059');
  ALL_USED_IDs = c(GL_OBJ$properties$id)
  load(GL_OBJ@filePath)
  
  GeneSets.AD = list(ADRelated = GeneSets)
  
  
  
  ensembl = useMart("ensembl",dataset="hsapiens_gene_ensembl")
  ensg2hgnc = getBM(attributes = c('ensembl_gene_id','hgnc_symbol'), filters = 'ensembl_gene_id', values = MOD$GeneIDs, mart = ensembl)
  backGroundGenes = unique(ensg2hgnc$hgnc_symbol)
  
  MOD = merge(MOD, ensg2hgnc, by.x = 'GeneIDs', by.y = 'ensembl_gene_id', all.x=T)
  ############################################################################################################
  
  ############################################################################################################
  #### Filter gene list ####
  GeneSets.AD = filterGeneSets(GeneSets.AD, backGroundGenes, minSize = 1, maxSize = 10000)
  GeneSets = c(GeneSets.AD)
  ############################################################################################################
  
  ############################################################################################################
  #### Perform enrichment analysis ####
  # Perform enrichment analysis (for modules greater than 20 genes only)
  enrichResults = list()
  for (name in unique(MOD$modulelabels)){
    genesInModule = unique(MOD$hgnc_symbol[MOD$modulelabels == name])  
    if (length(genesInModule) > 20){
      tmp = lapply(GeneSets,
                   function(x, genesInModule, genesInBackground){
                     tmp = as.data.frame(t(sapply(x, fisherEnrichment, genesInModule, genesInBackground)))
                     tmp = rownameToFirstColumn(tmp,'GeneSetName')
                     return(tmp)
                   },
                   unique(genesInModule), unique(backGroundGenes))
      
      for (name1 in names(tmp))
        tmp[[name1]]$category = name1
      
      enrichResults[[name]] = as.data.frame(rbindlist(tmp))
      enrichResults[[name]]$fdr = p.adjust(enrichResults[[name]]$pval, 'fdr')
    } else {
      enrichResults[[name]] = data.frame(GeneSetName = NA, pval = NA, ngenes = NA, noverlap = NA, OR = NA, category = NA, fdr = NA)
    }
    writeLines(paste0('Completed ',name))  
  }
  
  # Write results to file
  for(name in names(enrichResults))
    enrichResults[[name]]$ComparisonName = name
  enrichmentResults = as.data.frame(rbindlist(enrichResults))
  enrichmentResults$ngenes = unlist(enrichmentResults$ngenes)
  enrichmentResults$noverlap = unlist(enrichmentResults$noverlap)
  enrichmentResults$fdr = unlist(enrichmentResults$fdr)
  enrichmentResults$OR = unlist(enrichmentResults$OR)
  enrichmentResults$pval = unlist(enrichmentResults$pval)
  return(enrichmentResults)
}

foo <- runEnrichmentAnalysis(alzSpecificMods)
alzSpecificEnrichments <- foo

nciSpecificEnrichments <- runEnrichmentAnalysis(nciSpecificMods)

adMinusNci <- list(network=Matrix(diffNet==1,sparse=TRUE),
                   modules=alzSpecificMods,
                   enrichments=alzSpecificEnrichments)

nciMinusAd <- list(network=Matrix(diffNet==-1,sparse=TRUE),
                   modules=nciSpecificMods,
                   enrichments=nciSpecificEnrichments)


#adMinusNciADenrichments <- populateADenrichments(adMinusNci)

adMinusNci$enrichments <- arrange(adMinusNci$enrichments,fdr)
nciMinusAd$enrichments <- arrange(nciMinusAd$enrichments,fdr)
makeFilesForCytoscape(adMinusNci,'~/Projects/AMP-AD-Network-Analysis/adMinusNciNetwork.csv','~/Projects/AMP-AD-Network-Analysis/adMinusNciModules.csv')
makeFilesForCytoscape(nciMinusAd,'~/Projects/AMP-AD-Network-Analysis/nciMinusAdNetwork.csv','~/Projects/AMP-AD-Network-Analysis/nciMinusAdModules.csv')

neuron <- filter(adMinusNci$enrichments,GeneSetName=='Zhang:Neuron')
black <- filter(nciMinusAd$enrichments,ComparisonName=='black')
darkred <- filter(nciMinusAd$enrichments,ComparisonName=='darkred')


nciRidgeObj <- synGet('syn4919750')
load(nciRidgeObj@filePath)
#PPI
ppiNets <- synGet('syn4896428')
ppiNets@filePath
load(ppiNets@filePath)
ppiNew <- Matrix(ppi + t(ppi) !=0,sparse=TRUE)
diag(ppiNew) <- FALSE
ppiNCIdiff <- sparseNetwork - ppiNew
sum(ppiNCIdiff==1)/2

