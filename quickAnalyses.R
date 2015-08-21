alzGenes <- scan('~/Desktop/alzgenes.txt',what='character')
alzGenes <- unique(alzGenes)
library(metaNet)
enr1<-metaNet::enrichmentPath(rankedList = newDf$hgncSymbol,targetList = alzGenes)

library(ggplot2)




enr1$pval <- -log10(as.numeric(enr1$pval))
enr1$enr <- as.numeric(enr1$enr)
enr1$rank <- 1:nrow(enr1)
require(dplyr)
enrichmentDf <- data.frame(class=newDf$driverScore %>% unique)
enrichmentDf$enrichment <- rep(0,enrichmentDf$class %>% length)
enrichmentDf$log10pvalue <- rep(0,enrichmentDf$class %>% length)
enrichmentDf$ngenes <- rep(0,enrichmentDf$class %>% length)

for (i in 1:nrow(enrichmentDf)){
  enrRes <- metaNet::enrichment(alzGenes,newDf$hgncSymbol[newDf$driverScore>=enrichmentDf$class[i]],newDf$hgncSymbol)
  print(enrRes)
  enrichmentDf$ngenes[i] <- as.integer(sum(newDf$driverScore>=enrichmentDf$class[i]))
  enrichmentDf$enrichment[i] <- as.numeric(enrRes$enr)
  enrichmentDf$log10pvalue[i] <- -log10(as.numeric(enrRes$pval))
}
enrichmentDf$pvalue <- 10^(-enrichmentDf$log10pvalue)

str(enr1)

a <- ggplot(enrichmentDf,aes(ngenes,pvalue))
a + geom_bar(stat='identity',aes(fill=class)) + scale_x_log10() + xlab('Number of Genes') + ylab('P-value') +scale_y_log10() + theme_classic() + scale_fill_continuous(name='Driver Score\nGreater Than') + ggtitle('Enrichment of Known Alzheimer Genetic Loci')+ xlim(800,max(enrichmentDf$ngenes))

a <- ggplot(enrichmentDf,aes(ngenes,enrichment))
a + geom_bar(stat='identity',aes(fill=class)) + scale_x_log10() + xlab('Number of Genes') + ylab('Enrichment') + theme_classic() + scale_fill_continuous(name='Driver Score\nGreater Than') + ggtitle('Enrichment of Known Alzheimer Genetic Loci') + xlim(800,max(enrichmentDf$ngenes))



plot(-log10(as.numeric(enr1$pval[1:5000])))
