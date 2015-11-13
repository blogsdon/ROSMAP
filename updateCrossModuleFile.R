source('makeCrossRosmapModule.R')
tempMod <- makeTemporaryRosmapModules('syn5177050')

masterFileObj <- synGet('syn5260130')
masterFile <- read.csv(masterFileObj@filePath,stringsAsFactors=F,row.names=1)
masterFile[1:5,]
tempMod[1:5,]
masterFile2 <- dplyr::select(masterFile,geneName,hgncName,megenaModule,speakeasyModule)
masterFile2[1:5,]
masterFile2 <- merge(masterFile2,dplyr::select(tempMod,geneName,metanetworkModule),by='geneName')
masterFile2[1:5,]

write.csv(masterFile2,file='ROSMAP_metanetwork_megena_speakeasy_modules.csv',quote=F)
