###THIS...IS....SPPPPPAAAAAARRRRRRROOOOOOOOWWWWWW!!!!!

require(synapseClient)
synapseLogin()


exprFile <- synGet('syn4259377')
require(data.table);
expr <- fread(exprFile@filePath,header=T)
expr <- data.frame(expr)


sparrow2Nets<-c('syn4593567','syn4594107','syn4594686')
a <- lapply(sparrow2Nets,synGet)
buildNets <- function(x){
  load(x@filePath)
  return(sparseNetwork)
}
b <- lapply(a,buildNets)
names(b) <- c('AD','MCI','NCI')

hubScores <- sapply(b,rowSums)
hubScores <- cbind(hubScores,hubScores[,1]-hubScores[,2],hubScores[,1]-hubScores[,3],hubScores[,2]-hubScores[,3])
colnames(hubScores) <- c('AD','MCI','NCI','AD.MCI','AD.NCI','MCI.NCI')

#add differential expression.
sum(hubScores[,5]>5)
gene <- expr$hgnc_symbol[abs(hubScores[,6])>4]
cat(gene,file='~/Desktop/diffHub.txt',sep='\n')
hubScoresNormalized <- apply(hubScores,2,scale)
hubScoresNormalized <- data.frame((hubScoresNormalized))
hubScoresNormalized <- dplyr::mutate(hubScoresNormalized,overall = AD + MCI + abs(AD.NCI) + abs(MCI.NCI))
hubScoresNormalized <- dplyr::mutate(hubScoresNormalized,average = AD + MCI + NCI)
expr$hgnc_symbol[order(hubScoresNormalized$MCI,decreasing=T)][1:20]





alzGenes <- scan('~/Desktop/alzgenes.txt',what='character')
alzGenes <- unique(alzGenes)

isGWAS <- expr$hgnc_symbol %in% alzGenes

ad <- glm(isGWAS ~ AD,data=hubScoresNormalized,family='binomial')
mci <- glm(isGWAS ~ MCI, data=hubScoresNormalized,family='binomial')
nci <- glm(isGWAS ~ NCI, data=hubScoresNormalized,family='binomial')


par(mfcol=c(1,3))
plot(as.factor(isGWAS),hubScoresNormalized[,1],xlab='isGWAS',ylab='Sparrow Driver Score',main='AD')
plot(as.factor(isGWAS),hubScoresNormalized[,2],xlab='isGWAS',ylab='Sparrow Driver Score',main='MCI')
plot(as.factor(isGWAS),hubScoresNormalized[,3],xlab='isGWAS',ylab='Sparrow Driver Score',main='NCI')

enr <- enrichmentPath(rankedList = expr$hgnc_symbol[order(hubScoresNormalized$overall,decreasing=T)],alzGenes)

genes <- expr$hgnc_symbol[order(hubScoresNormalized$MCI,decreasing=T)]
d <- synGet('syn4867851')
load(d@filePath)

gb1 <- sapply(GeneSets,length)


fastlm2<-function(y,x){
  require(dplyr)
  X <- x %>% as.matrix
  n1 <- X %>% nrow
  X <- (1 %>% rep(n1)) %>% cbind(X)
  ginv <- t(X)%*%X %>% solve();
  Xhat <- ginv%*%t(X);
  betahat <- Xhat%*%y;
  sig <- (((y-X%*%betahat)^2) %>% mean)*((n1)/(n1- X %>% ncol));
  zval <- betahat/((sig*(ginv %>% diag)) %>% sqrt);
  #print('In cleaning')
  return(list(z=zval[-1],beta=betahat[-1]));
}

getPvalues <- function(g,expr,score){
  y <- expr$hgnc_symbol%in%g
  return(fastlm2(score,y))
}

getPvalues(GeneSets$Achilles_fitness_decrease[[1]],expr,hubScoresNormalized$MCI)

res <- t(sapply(GeneSets$GO_Molecular_Function,getPvalues,expr,hubScoresNormalized$MCI))
resZ <- res[order(abs(unlist(res[,1])),decreasing=T),]
resB <- res[order(abs(unlist(res[,2])),decreasing=T),]
resZ[1:5,]
resB[1:5,]


res <- t(sapply(GeneSets$GO_Biological_Process,getPvalues,expr,hubScoresNormalized$MCI))
resZ <- res[order(abs(unlist(res[,1])),decreasing=T),]
resB <- res[order(abs(unlist(res[,2])),decreasing=T),]
resZ[1:5,]
resB[1:5,]

res <- t(sapply(GeneSets$CMAP_down,getPvalues,expr,hubScoresNormalized$MCI))
resZ <- res[order(abs(unlist(res[,1])),decreasing=T),]
resB <- res[order(abs(unlist(res[,2])),decreasing=T),]
resZ[1:5,]
resB[1:5,]


kinases <- 