#!/bin/sh

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N nci_rosmap_networks
#$ -e error_nci_networks.txt
#$ -o out_nci_networks.txt
#$ -pe orte 16


#nci
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopqv -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -dmnopq -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -dmnopq -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -dv -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"
/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -d -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
#/shared/metanetworkSynapse/pushNet.sh -a "syn4545016" -b "/shared/ROSMAP/codeNCI.txt" -c "/shared/ROSMAP/syn.txt" -defghijklmnopq -r "None" -s "HomoSapiens" -t "NCI" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapseAracne.R"
