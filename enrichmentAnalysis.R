###script to do quick meta enrichment analysis for talk

require(synapseClient)
synapseLogin()

#get consensus enrichments
foo <- synGet('syn4894899')

require(data.table)
require(dplyr)

enrichments <- fread(foo@filePath) %>% data.frame
#enrichments2 <- filter(enrichments,category=='ADRelated')
enrichments2 <- arrange(enrichments,pval)
brown <- filter(enrichments2,ComparisonName=='brown')

foo <- synGet('syn4893262')

require(data.table)
require(dplyr)

enrichmentsR <- fread(foo@filePath) %>% data.frame
#enrichments2 <- filter(enrichments,category=='ADRelated')
enrichmentsR2 <- arrange(enrichmentsR,pval)
brown <- filter(enrichmentsR2,ComparisonName=='brown')


#pull all ad enrichments.  rank methods based on how they do.

foo <- synQuery('select name,id from file where projectId==\'syn2397881\' and moduleMethod==\'igraph:fast_greedy\' and disease==\'AD\'')
keep <- grep('AD Fisher',foo$file.name)
foo <- foo[keep,]

fooObj <- lapply(foo$file.id,synGet)
annos <- lapply(fooObj,function(x){y <- synGetAnnotations(x);return(y[c('method','sparsityMethod')])})

dfs <- lapply(fooObj,function(x){ require(data.table);return(fread(x@filePath)%>%data.frame)})
dfs <- lapply(dfs,function(x) {return(filter(x,ngenes>20))})

for (i in 1:length(dfs)){
  dfs[[i]]$method <- annos[[i]]['method']
  dfs[[i]]$sparsityMethod <- annos[[i]]['sparsityMethod']
}

allADenr <- do.call('rbind',dfs)
allADenr <- arrange(allADenr,pval)
allADenr <- filter(allADenr,ngenes<500)

finalEnr <- filter(allADenr,method=='sparsityconsensus' & sparsityMethod=='sparrow2Bonferroni')

modsFinalEnr <- lapply(names(table(finalEnr$ComparisonName)),function(x,y){return(filter(y,ComparisonName==x))},finalEnr)
names(modsFinalEnr) <- names(table(finalEnr$ComparisonName))
modsFinalEnr <- lapply(modsFinalEnr,function(x){if(sum(x[,2]<0.05)==0){return(NULL)}else{return(x)}})
z <- sapply(modsFinalEnr,is.null)
modsFinalEnr <- modsFinalEnr[!z]





###get other enrichments
foo <- synQuery('select name,id from file where projectId==\'syn2397881\' and disease==\'AD\' and method==\'sparsityconsensus\' and sparsityMethod==\'sparrow2Bonferroni\'')

networkObj <- synGet(foo$file.id[1])
modulesObj <- synGet(foo$file.id[2])
enrichmentObj <- synGet(foo$file.id[3])
nodeProperities <- synGet(foo$file.id[4])
load(networkObj@filePath)
mods <- fread(modulesObj@filePath) %>% data.frame
tab <- table(mods$moduleNumber)
mods <- filter(mods,mods$moduleNumber%in%1:37)
brownAdj <- sparseNetwork[mods$modulelabels=='brown',mods$modulelabels=='brown'] %>% as.matrix

library(metanetwork)
edgeList <- rankedEdgeList(brownAdj,symmetric=T)


exprFile <- synGet('syn4259377')
require(data.table);
expr <- fread(exprFile@filePath,header=T)
expr <- data.frame(expr)

edgeList$var1 <- expr$hgnc_symbol[mods$modulelabels=='brown'][edgeList$var1]
edgeList$var2 <- expr$hgnc_symbol[mods$modulelabels=='brown'][edgeList$var2]
edgeList <- filter(edgeList,!is.na(var1))
edgeList <- filter(edgeList,!is.na(var2))
edgeList <- filter(edgeList,var1!='')
edgeList <- filter(edgeList,var2!='')
write.csv(edgeList,file='~/Desktop/brown.csv',quote=F,row.names=F)
bar <- fread('~/Desktop/brownProp.csv') %>%data.frame(stringsAsFactors=F)
bar <- select(bar,name,Degree,AverageShortestPathLength,BetweennessCentrality,ClosenessCentrality,ClusteringCoefficient)
bar$Degree <- as.numeric(bar$Degree)
bar <- arrange(bar,desc(Degree))
write.csv(bar,file='~/Desktop/topgenesbrown.csv',quote=F,row.names=F)
