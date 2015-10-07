###Simulate small data-set

n <- as.numeric(commandArgs(TRUE)[[1]])
p <- as.numeric(commandArgs(TRUE)[[2]])
prop <- as.numeric(commandArgs(TRUE)[[3]])
file <- as.character(commandArgs(TRUE)[[4]])

require(MASS)
LAM <- matrix(rnorm(p^2)*rbinom(p^2,1,prop),p,p)
diag(LAM) <- 1;
OM <- LAM%*%t(LAM)



Y <- mvrnorm(n,rep(0,p),solve(OM))

rn <- sapply(1:n,function(i){return(paste(sample(letters,5,replace=T),collapse=''))})
cn <- sapply(1:p,function(i){return(paste(sample(letters,5,replace=T),collapse=''))})

while(sum(duplicated(rn))>0){
  k <- sum(duplicated(rn))
  rn[duplicated(rn)] <- sapply(1:k,function(i){return(paste(sample(letters,5,replace=T),collapse=''))})
}

while(sum(duplicated(cn))>0){
  k <- sum(duplicated(cn))
  cn[duplicated(cn)] <- sapply(1:k,function(i){return(paste(sample(letters,5,replace=T),collapse=''))})
}

rownames(Y) <- rn
colnames(Y) <- cn

rownames(OM) <- cn
colnames(OM) <- cn

write.csv(Y,file=file,quote=F)
write.csv(OM,file='truth.csv',quote=F)
cat('syn3157146','syn3157148',file='syn.txt',sep='\n')
cat('https://github.com/blogsdon/CMC/blob/master/simulation.R','https://github.com/blogsdon/CMC/blob/master/testpipelinesim.sh',file='code.txt',sep='\n')
