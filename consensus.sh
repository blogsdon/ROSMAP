#!/bin/bash

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N rank_consensus.sh
#$ -e rc_error.txt
#$ -o rc_out.txt

rm aggregateRank.rda
Rscript consensus.R
