#!/bin/bash

#push all rank consensus networks to Synapse
echo "https://github.com/blogsdon/ROSMAP/blob/master/runROSMAPbraak12.sh" > codeFile.txt
echo "https://github.com/blogsdon/ROSMAP/blob/master/generateBraak12Consensus.sh" >> codeFile.txt
echo "" >> codeFile.txt

echo "" > synFile.txt
echo "" >> synFile.txt

aws s3 cp s3://metanetworks/ROSMAP/BRAAK12/result_rankConsensus.rda /shared/ROSMAP/
/shared/metanetworkSynapse/pushNet.sh -a "syn4545005" -b "/shared/ROSMAP/codeFile.txt" -c "/shared/ROSMAP/synFile.txt" -z -r "None" -s "HomoSapiens" -t "Control" -u "FP" -x "/shared/metanetworkSynapse/pushSparseNetworkSynapse.R"
