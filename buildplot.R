#script to build ppi  plots
require(synapseClient)
synapseLogin()

a <- synGet('syn4896557')

library(data.table)
require(dplyr)

   
b <- fread(a@filePath) %>% data.frame
b$method[b$method=='sparsityconsensus'] <- 'sparsity\nconsensus'

foo <-synGet('syn4896428')
bar <- synQuery('select name,id from file where projectId==\'syn2397881\' and disease==\'AD\' and method==\'rankconsensus\' and fileType==\'rda\'')

allRanks <- lapply(bar$file.id,synGet)
bar
load(allRanks[[6]]@filePath)
load(foo@filePath)
gc()


computePower <- function(net,true){
  power <- sum(net!=0 & true !=0)/(sum(true!=0)/2)
  cat(signif(power,2),'\n')
  return(power)
  
}

computeTDR <- function(net,true){
  tp <- sum(net!=0 & true !=0)
  fp <- sum(net!=0 & true ==0)
  tdr <- tp/(tp+fp)
  cat(signif(tdr,2),'\n')
  return(tdr)
}

spNet <- as.matrix(sparseNetwork)
ppiNet <- as.matrix(ppi)
computeTDR(spNet,ppiNet)

rankC <- synGet('syn4892899')
load(rankC@filePath)
spNet2 <- as.matrix(sparseNetwork)

b$tdrVec <- (b$tdrVec)*100
b$powerVec <- (b$powerVec)*100


require(ggplot2)

t <- ggplot(b, aes(method,tdrVec)) + geom_bar(stat='identity')
t + facet_wrap(~ sparsityMethod)


methodMeans <- aggregate(tdrVec ~ method, data = b, FUN = max)
methodMeans <- arrange(methodMeans, tdrVec)
sparsityMethodMeans <- aggregate(tdrVec ~ sparsityMethod, data = b, FUN = max)
sparsityMethodMeans <- arrange(sparsityMethodMeans, tdrVec)

methodMeans2 <- aggregate(powerVec ~ method, data=b, FUN = mean)
methodMeans2 <- arrange(methodMeans2,powerVec)
sparsityMethodMeans2 <- aggregate(powerVec ~ sparsityMethod, data = b, FUN = mean)
sparsityMethodMeans2 <- arrange(sparsityMethodMeans2, desc(powerVec))

b$method2 <- factor(b$method, levels = methodMeans$method)
b$method3 <- factor(b$method, levels = methodMeans2$method)


b$sparsityMethod2 <- factor(b$sparsityMethod, levels = sparsityMethodMeans$sparsityMethod)
b$sparsityMethod3 <- factor(b$sparsityMethod2, levels = sparsityMethodMeans2$sparsityMethod)


ggplot(b) + theme_bw() + geom_bar(aes(x = method2, y = tdrVec, fill = sparsityMethod2), position = "dodge", stat = "identity") + xlab("Method") + ylab("True Discovery Rate") + scale_fill_discrete(name = "Sparsity Method") + ggtitle("True Discovery Rate Human PPI")
ggsave(file='~/Desktop/tdr.png')

 ggplot(b) + theme_bw() + geom_bar(aes(x = method3, y = powerVec, fill = sparsityMethod3), position = "dodge", stat = "identity") + xlab("Method") + ylab("Power") + scale_fill_discrete(name = "Sparsity Method") + ggtitle("Power Human PPI")
 ggsave(file='~/Desktop/power.png')

 
 
 

 sparsityObj <- synGet('syn4595017')
 sparsity <- fread(sparsityObj@filePath) %>% data.frame
 
 map <- paste0('nEdges = ',sparsity$V2)
 names(map) <- sparsity$V1
 
 b_sc <- filter(b,method=='sparsity\nconsensus')
 b_sc$sparsityMethod <- map[as.character(b_sc$sparsityMethod)] 
  
 methodMeans <- aggregate(tdrVec ~ method, data = b_sc, FUN = max)
methodMeans <- arrange(methodMeans, tdrVec)
sparsityMethodMeans <- aggregate(tdrVec ~ sparsityMethod, data = b_sc, FUN = max)
sparsityMethodMeans <- arrange(sparsityMethodMeans, tdrVec)
 
b_sc$method2 <- factor(b_sc$method, levels = methodMeans$method)
b_sc$sparsityMethod2 <- factor(b_sc$sparsityMethod, levels = sparsityMethodMeans$sparsityMethod)
  
 #sub out sparsityMethod names
 
  
 ggplot(b_sc) + theme_bw() + geom_bar(aes(x = method2, y = tdrVec, fill = sparsityMethod2), position = "dodge", stat = "identity") + xlab("Method") + ylab("True Discovery Rate") + scale_fill_discrete(name = "Sparsity Method") + ggtitle("True Discovery Rate Human PPI")
 ggsave(file='~/Desktop/PPIconsensus.png')
 
 ggplot(b) + theme_bw() + geom_bar(aes(x = method3, y = powerVec, fill = sparsityMethod3), position = "dodge", stat = "identity") + xlab("Method") + ylab("Power") + scale_fill_discrete(name = "Sparsity Method") + ggtitle("Power Human PPI")
 ggsave(file='~/Desktop/power.png')
 
 