#!/bin/bash

qsub -v method="methods.txt",s3path="s3://metanetworks/ROSMAP/BRAAK34/" -pe orte 16 -S /bin/bash -V -cwd -N braak34cons -e /shared/ROSMAP/braak34error.txt -o /shared/ROSMAP/braak34out.txt /shared/metanetworkSynapse/pushConsensus.sh
