#!/bin/bash
#simulate some data
qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/metanetworkSynapse/",sparrowZ=1,sparrow2Z=1,numberCore=160,outputpath="/shared/ROSMAP/NCI/" -pe orte 160 buildNet.sh
#qsub -v dataFile="../ROSMAP/NCIrna.csv",pathv="/shared/metanetworkSynapse/ARACNE/",correlation=1,correlationBonferroni=1,correlationFDR=1,wgcna=1,numberCore=160,outputpath="/shared/ROSMAP/NCI" -pe orte 160 buildNet.sh
#./pushNet.sh -a "syn4229809" -b "../ROSMAP/code.txt" -c "../ROSMAP/syn.txt" -defghijklmnopqv -r "none" -s "HomoZapiens" -t "bonitis" -u "blood" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"