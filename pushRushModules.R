#########script to push modules to synapse

library(synapseClient)
synapseLogin()

bar = synGet('syn5909448',downloadFile=F)
bar2 = synGetAnnotations(bar)


foo = File('Rush_module_identifiers.csv',parentId='syn7169817')
synSetAnnotations(foo) = list(fileType = 'csv',
                              dataType = 'analysis',
                              tissueTypeAbrv = 'DLPFC',
                              analysisType = 'moduleIdentification',
                              study = 'ROSMAP',
                              method = 'SpeakEasy',
                              organism = 'HomoSapiens')
foo = synStore(foo,)