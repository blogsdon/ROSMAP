#!/bin/sh
#number of cores to reserve for job
nthreads=16

#full s3 path where networks will go
s3="s3://metanetworks/ROSMAP/metanetworksV2/AD/"

#location of data file
dataFile="/shared/ROSMAP/metanetworkV2/rosmapADRNAseq.csv"

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/local/ROSMAP/metanetworkV2/AD/"

#path within s3
s3b="ROSMAP/metanetworksV2/AD"

#id of folder with networks to combine
networkFolderId="syn5752534"

#id of folder on Synapse that file will go to
parentId="syn5752534"

#path to csv file with annotations to add to file on Synapse
annotationFile="/shared/ROSMAP/metanetworkV2/AD/annoFile.txt"

provenanceFile="/shared/ROSMAP/metanetworkV2/AD/provenanceFile.txt"

#path to error output
errorOutput="/shared/ROSMAP/metanetworkV2/AD/Aggregationerror.txt"

#path to out output
outOutput="/shared/ROSMAP/metanetworkV2/AD/Aggregationout.txt"

#job script name
jobname="rosmapADaggregation"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId -pe orte $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildConsensus.sh
