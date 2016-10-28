require(synapseClient)
synapseLogin()
foo = synGet('syn7450379')

system(paste0('tar -xzvf ',foo@filePath))
foo1 = 'ROSMAP_eqtl_combined+CI_chr19_maf0.02_cis.out'
foo2 = 'ROSMAP_eqtl_combined+CI_chr8_maf0.02_cis.out'


library(data.table)
chr19 = fread(foo1,data.table=F)
chr8 = fread(foo2,data.table=F)
ABCA7geneId = 'ENSG00000064687'
CLUgeneId = 'ENSG00000120885'


library(dplyr)

eqtlabca7 = dplyr::filter(chr19,gene==ABCA7geneId)
eqtlclu = dplyr::filter(chr8,gene==CLUgeneId)

eqtlabca7=dplyr::filter(eqtlabca7,FDR<=0.05)
eqtlclu = dplyr::filter(eqtlclu,FDR<=0.05)


rSynapseUtilities::makeTable(df = eqtlabca7,projectId = 'syn7419026',tableName = 'ABCA7 ROSMAP eQTLs')
