####
#library(WGCNA)

synapseClient::synapseLogin()
exprFile <- synGet('syn4259377')
require(data.table);
expr <- fread(exprFile@filePath,header=T)
expr <- data.frame(expr)

expr2 <- t(expr[,-c(1,2)])
colnames(expr2) <- expr$ensembl_gene_id
corMat <- cor(expr2)

powers = c(c(1:10), seq(from = 12, to=22, by=2))
sft = WGCNA::pickSoftThreshold.similarity(similarity=corMat, powerVector = powers, verbose = 5)
softPower = 22

adjacency = WGCNA::adjacency.fromSimilarity(similarity = corMat,power = softPower)

TOM = WGCNA::TOMsimilarity(adjacency)
dissTOM = 1-TOM