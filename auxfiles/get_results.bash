#!/bin/bash

#
# This file is part of the JOBGEN package, which builds pipeline for slurm runs
#

# run awk script on every file and output results
echo "" > tmp
for f in `ls *.out`
do
 awk -f jobgenreport.awk $f >> tmp
done

# remember to filter out blank lines
cat tmp | egrep -v "^$" | awk -f avg_std_parser.awk | sort -r -s -n -k 16 -k 15 


