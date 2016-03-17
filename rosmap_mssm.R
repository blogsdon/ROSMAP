#function to integrate rosmap and mssm results
require(synapseClient)
synapseLogin()
mssmObj <- synGet('syn5321670')
rosmapObj <- synGet('syn5321075')

mssmOverall <- read.csv(mssmObj@filePath,header=T)
rosmapOverall <- read.csv(rosmapObj@filePath,header=T)

colnames(mssmOverall)[3:14] <- paste0('MSSM',colnames(mssmOverall)[3:14])
colnames(rosmapOverall)[3:6] <- paste0('ROSMAP',colnames(rosmapOverall)[3:6])
colnames(mssmOverall)[1:2] <- c('geneName','hgncName')

combinedModules <- merge(mssmOverall,rosmapOverall[,-2],by='geneName')
write.csv(combinedModules,file='combined_mssm_rosmap_modules.csv',quote=F,row.names=F)
