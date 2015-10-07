require(synapseClient)
synapseLogin()

synObj <- synGet('syn3505720')
synClin <- synGet('syn3191087')
synId <- synGet('syn3799513')
#test
fpkm <- read.delim(synObj@filePath,stringsAsFactors=F)
clin <- read.delim(synClin@filePath,stringsAsFactors=F,sep=',')
idkey <- read.delim(synId@filePath,stringsAsFactors=F,sep='\t')
samp2 <- sapply(colnames(fpkm)[-c(1:2)],function(x){return(strsplit(strsplit(x,'_')[[1]][1],'X')[[1]][2])})

idkey2 <- sapply(idkey$mirna_id,function(x){return(strsplit(x,'_')[[1]][2])})

#test
synmirna <- synGet('syn3387327')

tab1 <- read.delim(synmirna@filePath,skip=2)
