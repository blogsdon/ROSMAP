#!/bin/bash

#rm codeRosmapCross.txt
#rm synRosmapCross.txt

#./grabCMCdata.sh

echo "syn4922930" > synRosmapCross.txt
echo "syn4922926" >> synRosmapCross.txt
echo "syn4922923" >> synRosmapCross.txt

echo "https://github.com/blogsdon/ROSMAP/blob/master/runRosmapCross.sh" > codeRosmapCross.txt

cd /shared/metanetworkSynapse/
#qsub -v s3="s3://metanetworks/ROSMAP/CROSS/",dataFile="/shared/ROSMAP/rosmapRNAseq.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigressRootN=1,elasticNetAIC=1,elasticNetBIC=1,elasticNetCVmin=1,elasticNetCV1se=1,numberCore=319,outputpath="/shared/ROSMAP/CROSS/" -pe orte 319 -S /bin/bash -V -cwd -N rosmapCross -e /shared/ROSMAP/CROSS/error.txt -o /shared/ROSMAP/CROSS/out.txt buildNet.sh

qsub -v s3="s3://metanetworks/ROSMAP/CROSS2/",dataFile="/shared/ROSMAP/rosmapRNAseq.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,lassoCV1se=1,lassoCVmin=1,lassoAIC=1,lassoBIC=1,ridgeCV1se=1,ridgeCVmin=1,ridgeAIC=1,ridgeBIC=1,genie3=1,tigressRootN=1,elasticNetAIC=1,elasticNetBIC=1,elasticNetCVmin=1,elasticNetCV1se=1,numberCore=319,outputpath="/shared/ROSMAP/CROSS/" -pe orte 319 -S /bin/bash -V -cwd -N rosmapCross -e /shared/ROSMAP/CROSS/error.txt -o /shared/ROSMAP/CROSS/out.txt buildNet.sh
