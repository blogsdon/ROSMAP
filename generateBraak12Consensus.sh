#!/bin/bash

qsub -v method="methods.txt",s3path="s3://metanetworks/ROSMAP/BRAAK12/"
