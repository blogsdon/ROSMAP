#!/bin/bash

qsub -v method="methods.txt",s3path="s3://metanetworks/ROSMAP/BRAAK12/" -pe orte 16 -S /bin/bash -V -cwd -N braak12cons -e /shared/ROSMAP/braak12error.txt -o /shared/ROSMAP/braak12out.txt /shared/metanetworkSynapse/pushConsensus.sh
