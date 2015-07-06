#!/bin/sh

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N mci_rosmap_networks
#$ -e error_mci_networks.txt
#$ -o out_mci_network.txt
#$ -pe orte 16


#mci
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545013" -b "/shared/ROSMAP/codeMCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "MCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"
/shared/metanetworkSynapse/pushNet.sh -a "syn4545013" -b "/shared/ROSMAP/codeMCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopq -r "None" -s "HomoSapiens" -t "MCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"