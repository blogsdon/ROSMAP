#!/bin/sh

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N pushingcmcnetworks
#$ -e error.txt
#$ -o out.txt


#nci
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"

#mci
/shared/metanetworkSynapse/pushNet.sh -a "syn4545013" -b "/shared/ROSMAP/codeMCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "MCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"

#ad
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeAD.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "AD" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"