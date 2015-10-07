#!/bin/bash

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N rank_consensus.sh
#$ -e rc_error.txt
#$ -o rc_out.txt
#$ -pe orte 16

rm aggregateRank.rda
Rscript /shared/ROSMAP/consensus.R
