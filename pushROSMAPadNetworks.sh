#!/bin/sh

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N ad_rosmap_networks
#$ -e error_ad_networks.txt
#$ -o out_ad_network.txt
#$ -pe orte 16


#ad
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeAD.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "AD" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeAD.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopq -r "None" -s "HomoSapiens" -t "AD" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeAD.txt" -c "/shared/ROSMAP/syn.txt" -y -r "None" -s "HomoSapiens" -t "AD" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeAD.txt" -c "/shared/ROSMAP/syn.txt" -z -r "None" -s "HomoSapiens" -t "AD" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"


