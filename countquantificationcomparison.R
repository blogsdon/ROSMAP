#compare count quantifications

#get jishu counts
library(synapseClient)
synapseLogin()

library(dplyr)
library(data.table)
foo <- synGet('syn7838048',downloadLocation = './')
foobar <- system(paste0('gunzip ',foo@filePath),intern = TRUE)

bar <- fread('RSEM_Phase1_Phase2_gene_expected_count.txt',data.table=F) %>% data.frame(check.names=F,stringsAsFactors=F)


foo <- synGet('syn7750270',downloadLocation = './')
baz <- read.delim('ROSMAP_synB_quant_matrix.txt',check.names = FALSE) %>% data.frame(check.names=F,stringsAsFactors=F)

#intersect(colnames(baz),colnames(bar))
rownames(bar) <- bar$gene_id
bar <- bar[,-c(1:7)]
View(bar)

reformatColnames <- function(x){
  foo <- strsplit(x,'_')[[1]]
  bar <- paste0(foo[1:2],collapse='_')
  return(bar)
}

newColNames <- sapply(colnames(bar),reformatColnames)

colnames(bar) <- newColNames
bar <- log(bar)/log(2)
baz <- log(baz)/log(2)

medBar <- apply(data.matrix(bar),1,median)
medBaz <- apply(data.matrix(baz),1,median)

barFilter <- quantile(medBar,.5)
bazFilter <- quantile(medBaz,.5)
bar <- bar[medBar>barFilter,]
baz <- baz[medBaz>bazFilter,]

keepCols <- intersect(colnames(bar),colnames(baz))
keepRows <- intersect(rownames(bar),rownames(baz))

bar <- bar[keepRows,keepCols]
baz <- baz[keepRows,keepCols]
View(bar)
View(baz)
bar <- t(bar)
baz <- t(baz)

#foobar <- mapply(cor,bar,baz)
corState <- rep(0,ncol(bar))
for (i in 1:ncol(bar)){
  corState[i] <- cor(bar[,i],baz[,i],method = 'spearman')
}

png(file='correlationDiagnostic.png',pointsize = 12)
hist(corState,xlab='Spearman Correlation between Sage and Broad Counts\nacross samples for each gene',main='Spearman Correlation for genes with median count > 0 (p = 4526)')

legend('topleft',c('mean correlation: 0.83'),box.lty=0)
dev.off()

f1 <- File('correlationDiagnostic.png',parentId='syn6828905')
f1 <- synStore(f1,used <- as.list(c('syn7838048','syn7750270')),executed <- as.list(c('')))
