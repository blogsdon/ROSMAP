#!/bin/bash

rm codeMCI.txt
#rm syn.txt

#./grabCMCdata.sh

#echo "syn4259377" >> syn.txt
#echo "syn4259379" >> syn.txt

echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPmci.sh" >> codeMCI.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/getROSMAPrnaseq.R" >> codeMCI.txt

cd ../metanetworkSynapse/
qsub -v dataFile="../ROSMAP/MCIrna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigress=1,numberCore=150,outputpath="/shared/ROSMAP/MCI/" -pe orte 150 buildNet.sh
qsub -v dataFile="../ROSMAP/MCIrna.csv",pathv="/shared/ROSMAP/MCI/",aracne=1,aracneFull=1,correlation=1,correlationBonferroni=1,correlationFDR=1,wgcna=1,numberCore=1,outputpath="/shared/ROSMAP/MCI/" -pe orte 1 buildNet.sh
qsub -v dataFile="../ROSMAP/MCIrna.csv",pathv="/shared/ROSMAP/MCI/",aracne=1,aracneFull=1,numberCore=1,outputpath="/shared/ROSMAP/MCI/" -pe orte 1 buildNet.sh

#qsub -v dataFile="../CMC/controlData.csv",pathv="/shared/metanetworkSynapse/ARACNE/",aracne=1,correlation=1,numberCore=8 -pe orte 8 buildNet.sh
#./pushNet.sh -a "syn3526285" -b "../CMC/code.txt" -c "../CMC/syn.txt" -defghijklmnopq -r "SVA" -s "HomoSapiens" -t "Schizophrenia" -u "DorsolateralPrefrontalCortex"
#./cleanNet.sh

