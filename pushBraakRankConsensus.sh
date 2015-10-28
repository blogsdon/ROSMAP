#!/bin/bash

#push all rank consensus networks to Synapse
echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPbraak12.sh" > codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/generateBraak12Consensus.sh" >> codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/pushBraakRankConsensus.sh" >> codeFile.txt

echo "syn3191087" > synFile.txt
echo "syn4935408" >> synFile.txt

aws s3 cp s3://metanetworks/ROSMAP/BRAAK12/result_rankConsensus.rda /shared/ROSMAP/
/shared/metanetworkSynapse/pushNet.sh -a "syn5014784" -b "/shared/ROSMAP/codeFile.txt" -c "/shared/ROSMAP/synFile.txt" -z -r "None" -s "HomoSapiens" -t "BRAAK12" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"


echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPbraak34.sh" > codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/generateBraak34Consensus.sh" >> codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/pushBraakRankConsensus.sh" >> codeFile.txt

#echo "syn3191087" > synFile.txt
#echo "syn4935408" >> synFile.txt

aws s3 cp s3://metanetworks/ROSMAP/BRAAK34/result_rankConsensus.rda /shared/ROSMAP/
/shared/metanetworkSynapse/pushNet.sh -a "syn5014785" -b "/shared/ROSMAP/codeFile.txt" -c "/shared/ROSMAP/synFile.txt" -z -r "None" -s "HomoSapiens" -t "BRAAK34" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"


echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPbraak56.sh" > codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/generateBraak56Consensus.sh" >> codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/pushBraakRankConsensus.sh" >> codeFile.txt

#echo "syn3191087" > synFile.txt
#echo "syn4935408" >> synFile.txt

aws s3 cp s3://metanetworks/ROSMAP/BRAAK56/result_rankConsensus.rda /shared/ROSMAP/
/shared/metanetworkSynapse/pushNet.sh -a "syn5014786" -b "/shared/ROSMAP/codeFile.txt" -c "/shared/ROSMAP/synFile.txt" -z -r "None" -s "HomoSapiens" -t "BRAAK56" -u "DLPFC" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
