#!/bin/bash

rm codeAD.txt
#rm syn.txt

#./grabCMCdata.sh

#echo "syn4259377" >> syn.txt
#echo "syn4259379" >> syn.txt

echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPad.sh" >> codeAD.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/getROSMAPrnaseq.R" >> codeAD.txt

cd ../metanetworkSynapse/
qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigress=1,numberCore=150,outputpath="/shared/ROSMAP/AD/" -pe orte 150 buildNet.sh
qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/ROSMAP/AD/",aracne=1,aracneFull=1,correlation=1,correlationBonferroni=1,correlationFDR=1,wgcna=1,numberCore=1,outputpath="/shared/ROSMAP/AD/" -pe orte 1 buildNet.sh
qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/ROSMAP/AD/",aracne=1,aracneFull=1,numberCore=1,outputpath="/shared/ROSMAP/AD/" -pe orte 1 buildNet.sh


#new submissions
qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigress=1,numberCore=479,outputpath="/shared/ROSMAP/AD/" -pe orte 479 buildNet.sh
qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/ROSMAP/AD/",aracne=1,aracneFull=1,numberCore=1,outputpath="/shared/ROSMAP/AD/" -pe orte 1 buildNet.sh

qsub -v dataFile="../ROSMAP/ADrna.csv",pathv="/shared/metanetworkSynapse/",lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigress=1,numberCore=543,outputpath="/shared/ROSMAP/AD/" -pe orte 543 buildNet.sh

qsub -v s3="s3://metanetworks/ROSMAP/AD/",dataFile="/shared/ROSMAP/ADrna.csv",pathv="/shared/metanetworkSynapse/",tigressRootN=1,elasticNetAIC=1,elasticNetBIC=1,elasticNetCVmin=1,elasticNetCV1se=1,numberCore=320,outputpath="/shared/ROSMAP/AD/" -pe orte 320 -S /bin/bash -V -cwd -N rosmapAd -e /shared/ROSMAP/AD/error.txt -o /shared/ROSMAP/AD/out.txt buildNet.sh


#qsub -v dataFile="../CMC/controlData.csv",pathv="/shared/metanetworkSynapse/ARACNE/",aracne=1,correlation=1,numberCore=8 -pe orte 8 buildNet.sh
#./pushNet.sh -a "syn3526285" -b "../CMC/code.txt" -c "../CMC/syn.txt" -defghijklmnopq -r "SVA" -s "HomoSapiens" -t "Schizophrenia" -u "DorsolateralPrefrontalCortex"
#./cleanNet.sh

