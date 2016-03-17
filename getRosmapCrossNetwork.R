#get chris version of data
require(synapseClient)
synapseLogin()

require(data.table)
require(dplyr)

foo <- synGet('syn4922930')
bar <- fread(foo@filePath,data.table = F)

foo <- synGet('syn4922926')
geneName <- scan(foo@filePath,what='character')
colnames(bar) <- geneName

foo <- synGet('syn4922923')
sampleId <- scan(foo@filePath,what='character')
rownames(bar) <- sampleId

winsorize <- function(x,per=.99){
up <- quantile(x,per)
low <- quantile(x,1-per)
x[x>=up] <- up
x[x<=low] <- low
return(x)
}
bar <- apply(bar,2,winsorize)
bar <- scale(bar)


write.csv(bar,file='rosmapRNAseq.csv',quote=F)
