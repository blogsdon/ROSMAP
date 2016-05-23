#!/bin/sh
#number of cores to reserve for job
nthreads=16

#full s3 path where networks will go
s3="s3://metanetworks/ROSMAP/reprocessed/Full/"

#location of data file
dataFile="/shared/ROSMAP/reprocessed/rosmapRNAseq.csv"

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/local/ROSMAP/reprocessed/Full/"

#path within s3
s3b="ROSMAP/reprocessed/Full"

#id of folder with networks to combine
networkFolderId="syn6115574"

#id of folder on Synapse that file will go to
parentId="syn6115574"

#path to csv file with annotations to add to file on Synapse
annotationFile="/shared/ROSMAP/reprocessed/Full/annoFile.txt"

provenanceFile="/shared/ROSMAP/reprocessed/Full/provenanceFile.txt"

#path to error output
errorOutput="/shared/ROSMAP/reprocessed/Full/Aggregationerror.txt"

#path to out output
outOutput="/shared/ROSMAP/reprocessed/Full/Aggregationout.txt"

#job script name
jobname="rosmapFullaggregation"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId -pe orte $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildConsensus.sh
