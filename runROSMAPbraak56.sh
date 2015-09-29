#!/bin/bash

rm codeBraak56.txt
rm synBraak.txt

#./grabCMCdata.sh

echo "syn3191087" >> synBraak.txt
echo "syn4935408" >> synBraak.txt

echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPbraak56.sh" >> codeBraak56.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/getROSMAPrnaseqBraak.R" >> codeBraak56.txt

cd /shared/metanetworkSynapse/
qsub -v dataFile="/shared/ROSMAP/BRAAK56rna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigressRootN=1,elasticNetAIC=1,elasticNetBIC=1,elasticNetCVmin=1,elasticNetCV1se=1,numberCore=150,outputpath="/shared/ROSMAP/BRAAK56/" -pe orte 150 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/ROSMAP/NCI/",aracne=1,aracneFull=1,correlation=1,correlationBonferroni=1,correlationFDR=1,wgcna=1,numberCore=1,outputpath="/shared/ROSMAP/NCI/" -pe orte 1 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/ROSMAP/NCI/",aracne=1,aracneFull=1,numberCore=1,outputpath="/shared/ROSMAP/NCI/" -pe orte 1 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCVmin=1,ridgeCVmin=1,numberCore=150,outputpath="/shared/ROSMAP/NCI/" -pe orte 150 buildNet.sh


#new submissions
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/metanetworkSynapse/",lassoCVmin=1,ridgeCVmin=1,numberCore=479,outputpath="/shared/ROSMAP/NCI/" -pe orte 479 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/ROSMAP/NCI/",aracneFull=1,numberCore=1,outputpath="/shared/ROSMAP/NCI/" -pe orte 1 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/ROSMAP/NCI/",sparrowZ=1,numberCore=319,outputpath="/shared/ROSMAP/NCI/" -pe orte 319 buildNet.sh

#qsub -v dataFile="../CMC/controlData.csv",pathv="/shared/metanetworkSynapse/ARACNE/",aracne=1,correlation=1,numberCore=8 -pe orte 8 buildNet.sh
#./pushNet.sh -a "syn3526285" -b "../CMC/code.txt" -c "../CMC/syn.txt" -defghijklmnopq -r "SVA" -s "HomoSapiens" -t "Schizophrenia" -u "DorsolateralPrefrontalCortex"
#./cleanNet.sh

