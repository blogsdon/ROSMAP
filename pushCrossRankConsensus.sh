#!/bin/bash

Rscript ../metanetworkSynapse/pushConsensus.R "methods.txt" "s3://metanetworks/ROSMAP/CROSS2/"

echo "syn4922930" > synRosmapCross.txt
echo "syn4922926" >> synRosmapCross.txt
echo "syn4922923" >> synRosmapCross.txt

echo "https://github.com/blogsdon/ROSMAP/blob/master/runRosmapCross.sh" > codeRosmapCross.txt

aws s3 cp s3://metanetworks/ROSMAP/CROSS/result_rankConsensus.rda ./
aws s3 cp s3://metanetworks/ROSMAP/CROSS/sparsity.csv ./
../metanetworkSynapse/pushNet.sh -a "syn5177040" -b "codeRosmapCross.txt" -c "synRosmapCross.txt" -z -r "None" -s "HomoSapiens" -t "NCI_MCI_AD" -u "DLPFC" -x "../metanetworkSynapse/pushSparseNetworkSynapse.R"
