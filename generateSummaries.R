#######build results


require(dplyr)
require(data.table)
source('networkSummary.R')
require(synapseClient)
synapseLogin()
method <- 'rankconsensus'
sparsityMethod <- 'sparrow2Bonferroni'
projectId <- 'syn2397881'
model <- list()

model$rosmapbraak12res<-grabNetworkAnalysisResults3(method,sparsityMethod,'BRAAK12',projectId,'DLPFC')
model$rosmapbraak34res<-grabNetworkAnalysisResults3(method,sparsityMethod,'BRAAK34',projectId,'DLPFC')
model$rosmapbraak56res<-grabNetworkAnalysisResults3(method,sparsityMethod,'BRAAK56',projectId,'DLPFC')
model$rosmapncires<-grabNetworkAnalysisResults3(method,sparsityMethod,'NCI',projectId,'DLPFC')
model$rosmapmcires<-grabNetworkAnalysisResults3(method,sparsityMethod,'MCI',projectId,'DLPFC')
model$rosmapadres<-grabNetworkAnalysisResults3(method,sparsityMethod,'AD',projectId,'DLPFC')

model$mssmcdr01stg<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR0_1',projectId,'STG')
model$mssmcdr01phg<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR0_1',projectId,'PHG')
model$mssmcdr01fp<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR0_1',projectId,'FP')
model$mssmcdr25stg<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR2_5',projectId,'STG')
model$mssmcdr25phg<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR2_5',projectId,'PHG')
model$mssmcdr25fp<-grabNetworkAnalysisResults3(method,sparsityMethod,'CDR2_5',projectId,'FP')

adapply <- lapply(model,populateADenrichments)
enrichSum <- lapply(model,makeEnrichmentSummary)
