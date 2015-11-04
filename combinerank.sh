#!/bin/sh

echo "s3://metanetworks/ROSMAP/NCI/result_rankConsensus.rda" > method_file.txt
echo "s3://metanetworks/ROSMAP/MCI/result_rankConsensus.rda" >> method_file.txt
echo "s3://metanetworks/ROSMAP/AD/result_rankConsensus.rda" >> method_file.txt

Rscript ../metanetworkSynapse/combineRankconsensus.R "method_file.txt" "s3://metanetworks/ROSMAP/"
