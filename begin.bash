#!/bin/bash

##
# This script is part of the JOBGEN package, see start.bash for more reference
# This script is to be used on JOBGEN_name.bash files produced by the start.bash script
##

# make bash safer
set -euo pipefail

# grabs the name of the run
# e.g. head -1 $1 is -> # test_run 
OUT="runs/"`head -1 $1 | awk '{print $2}'`"/JOBS"
# start the slurm runs in the script
# redirect the the output, that is jobs number to a file in the output dir
bash $1 >> $OUT
# print the files
cat $OUT
# make auxiliary file that can be used to easily cancel the run
awk '{print "scancel "$4}' $OUT > "${OUT}.SCANCEL"

