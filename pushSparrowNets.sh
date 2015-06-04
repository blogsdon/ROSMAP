#!/bin/sh

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N pushingnetworks
#$ -e error.txt
#$ -o out.txt


/shared/metanetworkSynapse/pushNet.sh -a "syn4261317" -b "/shared/ROSMAP/code.txt" -c "/shared/ROSMAP/syn.txt" -dev -r "none" -s "HomoSapiens" -t "Control" -u "DLPFC" -x "/shared/metanetworkSynapse/pushNetworkSynapse.R"