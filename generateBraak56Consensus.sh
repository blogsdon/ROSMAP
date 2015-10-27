#!/bin/bash

qsub -v method="methods.txt",s3path="s3://metanetworks/ROSMAP/BRAAK56/" -pe orte 16 -S /bin/bash -V -cwd -N braak56cons -e /shared/ROSMAP/braak56error.txt -o /shared/ROSMAP/braak56out.txt /shared/metanetworkSynapse/pushConsensus.sh
