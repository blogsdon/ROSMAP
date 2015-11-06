echo "https://github.com/blogsdon/ROSMAP/blob/master/combinerank.sh" > codeFile.txt

echo "syn4259379" > synFile.txt
echo "syn4259377" >> synFile.txt

aws s3 cp s3://metanetworks/ROSMAP/result_rankConsensus.rda ./
aws s3 cp s3://metanetworks/ROSMAP/sparsity.csv ./
../metanetworkSynapse/pushNet.sh -a "syn4545002" -b "codeFile.txt" -c "synFile.txt" -z -r "None" -s "HomoSapiens" -t "NCI_MCI_AD" -u "DLPFC" -x "../metanetworkSynapse/pushSparseNetworkSynapse.R"
