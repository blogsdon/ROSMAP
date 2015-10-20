#function to analyze both networks.
load('rankconsensussparrow2Bonferroni.rda')
require(data.table)

mods <- fread('rankconsensussparrow2Bonferroni.fast_greedy.tsv',
              data.table=F,
              stringsAsFactors=F)

enrichments <- fread('rankconsensussparrow2Bonferroni_fast_greedy_Enrichment_enrichmentResults.tsv',
                     data.table=F,
                     stringsAsFactors = F)

speakEasy <- fread('ROSMAP_SpeakEasy_genesymbols_clusterid.csv',
                   data.table=F,
                   stringsAsFactors = F)

expr <- fread('~/.synapseCache/105/5276105/ResidualGeneExpression.tsv')
expr <- data.frame(expr)
colnames(expr) <- expr[1,]
expr <- expr[-1,]
dim(expr)

hgnc <- expr$hgnc_symbol
names(hgnc) <- expr$ensembl_gene_id
mods$hgnc <- hgnc[mods$GeneIDs]

require(dplyr)

table1 <- table(mods$moduleNumber)
wbig <- names(which(table1>20))
mNmodsKeep <- filter(mods,moduleNumber%in%wbig)

table1 <- table(speakEasy$V2)
wbig <- names(which(table1>20))
sEmodsKeep <- filter(speakEasy,V2%in%wbig)


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

internal <- function(i,x){
  geneList <- x$hgnc[which(x$modulelabels==i)]
}

internal2 <- function(i,x){
  geneList <- x$V1[which(x$V2==i)]
}


filterNA <- function(x){
  return(x[!is.na(x) & x!=""])
}

mNlist <- lapply(names(table(mNmodsKeep$modulelabels)),internal,mNmodsKeep)
sElist <- lapply(names(table(sEmodsKeep$V2)),internal2,sEmodsKeep)
mNlist <- lapply(mNlist,filterNA)
sElist <- lapply(sElist,filterNA)
hgnc2 <- filterNA(hgnc)

outerSapply <- function(FUN,X,Y,...){
  require(dplyr)
  internal <- function(X,Y,FUN,...){
    return(Y%>% sapply(FUN,X,...))
  }
  return(X %>% sapply(internal,Y,FUN,...))
}

pvalTable <- outerSapply(fisherWrapperPval,mNlist,sElist,hgnc2)

enrTable <- outerSapply(fisherWrapperOR,mNlist,sElist,hgnc2)
rownames(enrTable) <- names(table(sEmodsKeep$V2))
colnames(enrTable) <- names(table(mNmodsKeep$modulelabels))

enrTable2 <- enrTable
enrTable2[which(pvalTable < 0.05/(47*21))] <- 0

library(gplots)
#o1 <- apply(enrTable2,1,order,decreasing=T)
#o2 <- apply(enrTable2,2,order,decreasing=T)
#o1 <- order(enrTable2,decreasing=T)

greedyOrder <- function(x){
  rowInd <- c()
  colInd <- c()
  count1 <- 0;
  count2 <- 0;
  while(count1<nrow(x) & count2 < ncol(x)){
    count1 <- count1+1;
    count2 <- count2+1;
    if(count1==1){
      foo <- which(x==max(x),T)
      rowInd <- c(rowInd,foo[1])
      colInd <- c(colInd,foo[2])
    }else{
      dummy <- x
      dummy[rowInd,] =0
      dummy[,colInd]=0
      foo <- which(dummy==max(x[-rowInd,-colInd]),T)
      rowInd <- c(rowInd,foo[1])
      colInd <- c(colInd,foo[2])
    }
    print(rowInd)
    print(colInd)
  }
  return(list(rowInd=rowInd,colInd=colInd))
}
perm1 <- greedyOrder(enrTable2)

enrTable3 <- enrTable2[perm1$rowInd,perm1$colInd]
perm2 <- greedyOrder(-log10(pvalTable))
rownames(pvalTable) <- rownames(enrTable)
colnames(pvalTable) <- colnames(enrTable)
pvalTableB <- pvalTable
pvalTableB[which(pvalTable > 0.05/(47*21))]<-0
pvalTableB[which(pvalTable < 0.05/(47*21))]<-1
addIndex <- c(perm2$rowInd,which(!(1:nrow(pvalTableB))%in%perm2$rowInd))

pvalTable2 <- pvalTableB[rev(addIndex),(perm2$colInd)]
heatmap.2(t(sqrt(enrTable3)),scale='none',Rowv=NA,Colv=NA,trace='none')
#heatmap.2((t(-log10(pvalTable2)))^(1/4),Rowv=NA,Colv=NA,trace='none')
heatmap((pvalTable2),Rowv=NA,Colv=NA,scale='none')

#####make a blockwise gene plot

mNmodsKeep2 <- filter(mNmodsKeep,hgnc%in%sEmodsKeep$V1)
sEmodsKeep2 <- filter(sEmodsKeep,V1%in%mNmodsKeep2$hgnc)
sEmodsKeep2 <- sEmodsKeep2[-which(duplicated(sEmodsKeep2$V1)),]

colIndexVec <- c()
for(i in 1:length(perm1$colInd)){
  colIndexVec <- c(colIndexVec,which(mNmodsKeep2$modulelabels==colnames(enrTable)[perm1$colInd][i]))
}
mNmodsKeep3 <- mNmodsKeep2[colIndexVec,]

rowIndexVec <- c()
for(i in 1:length(perm1$rowInd)){
  rowIndexVec <- c(rowIndexVec,which(sEmodsKeep2$V2==rownames(enrTable)[perm1$rowInd][i]))
}
rowIndexVec <- c(rowIndexVec,which(!(1:nrow(sEmodsKeep2))%in%rowIndexVec))
sEmodsKeep3 <- sEmodsKeep2[rowIndexVec,]

enrichments <- arrange(enrichments,fdr)

go2 <- fread('ROSMAP_SpeakEasy_ontology.001.csv',
             data.table=F,
             stringsAsFactors=T)
which(apply(pvalTable2,1,sum)==0)
which(apply(pvalTable2,2,sum)==0)

#257 187 131 128 127 126 125 123 122 118  22  18  13  11 233   2 
go2 <- arrange(go2,Pval.Bonferroni)
test <- filter(go2,ID==2)
test[1:5,]

#DIFFERNCES

######257
#126: mitochondria
#123: mitochondria
#118: protein modification by small protein conjugation or removal
#22: neuron development

############
#grey60: regulation of ossification
#lightyellow: cholesterol biosynthetic process


#similariies

#[1] "blue"         "turquoise"    "purple"       "brown"        "red"          "pink"         "magenta"      "black"        "salmon"       "royalblue"   
#[11] "yellow"       "tan"          "green"        "lightcyan"    "cyan"         "greenyellow"  "lightgreen"   "grey60"       "midnightblue" "lightyellow" 
#[21] "darkred"

test0 <-filter(enrichments,ComparisonName=='red' & (1:nrow(enrichments))%in%grep('GO',category))
test0[1:5,]

test1 <- filter(go2,ID==116)
test1[1:5,]
which(pvalTable2[,5]!=0)

#blue: axon ensheathment
#106: organic acid catabolic process
#110: ensheathment of neurons

#turquoise: rna splicing
#10: nuclear part
#8: RNA processing
#9: nucleus

#purple: activation of immune response
#5: none
#116: defense response/immune response

#brown: monocarboxylic acid metabolic process (astrocytes)
#109: transcription form RNA polII promoter
#106: organic acid catabolic process
#114: cytosol
#113: response to wounding
#107: intrinsic to membrane
#





#combinedMods <- merge(mNmodsKeep3,sEmodsKeep3,by.x="hgnc",by.y="V1")


###
#mNmodsKeep <- filter(mNmodsKeep,hgnc%in%sEmodsKeep$V1)
#sEmodsKeep <- filter(sEmodsKeep,V1%in%mNmodsKeep$hgnc)

#mNmodsKeep[1:5,]
#sEmodsKeep[1:5,]
