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

write.csv(bar,file='rosmapRNAseq.csv',quote=F)
