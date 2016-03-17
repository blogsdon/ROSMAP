#!/bin/bash

rm codePhgCase.txt
rm synPhgCase.txt

#./grabCMCdata.sh

echo "syn4921702" >> synPhgCase.txt
echo "syn4921703" >> synPhgCase.txt

echo "https://github.com/blogsdon/MSSM/blob/master/runMSSMphgCase.sh" >> codePhgCase.txt

cd /shared/metanetworkSynapse/
  qsub -v s3="s3://metanetworks/MSSM/PHG/CDR2_5/",dataFile="/shared/MSSM/phgCase.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigressRootN=1,elasticNetAIC=1,elasticNetBIC=1,elasticNetCVmin=1,elasticNetCV1se=1,tigressRootN=1,numberCore=319,outputpath="/shared/MSSM/PHG/CDR2_5/" -pe orte 319 buildNet.sh