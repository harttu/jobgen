#!/bin/bash

####
#
# This file is part of the jobgen package, which automates running jobs in the slurm system
# It will scan a set of specific data sets ALLDATAS and start running jobs, whose parameters are set in the start.bash
# and will feed them in when there is room in the queue
#
# Please refer to start.bash for more detailed overview
#
####

##
# TODO:
# If the number of jobs in each of the grid runs is greater than max, there should be error
#

# make this script safer
set -euo pipefail

##
# these are the datasets that will be studied
ALLDATAS=("data/cross_TRAIN_linnaeus-and-s800-original_DEVEL_linnaeus" "data/cross_TRAIN_linnaeus-and-s800-original_DEVEL_s800-original" "data/cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_linnaeus_filtered" "data/cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_s800-original" "data/cross_TRAIN_s800-original_DEVEL_linnaeus_filtered" "data/cross_TRAIN_s800-original_DEVEL_linnaeus" "data/cross_TRAIN_linnaeus_DEVEL_S800_original" "data/cross_TRAIN_linnaeus_filtered_DEVEL_S800_original")

#ALLDATAS=("data/s800-original-only-species/conll/") # Debugging

##
# number of jobs at anytime in the queue, the program will never put more jobs to the queue
MAX_JOBS=120

# check to see all the data dirs exist
for d in "${ALLDATAS[@]}"
do
	#$(file "${d}/train.tsv")
	if [ ! -f "${d}/train.tsv" ]; then 
		echo "$d missing dir or file"
		exit 1
	fi
done

# go through every datadir
for d in "${ALLDATAS[@]}"
do
	echo "Processing $d"
	# differentiate each run
	COMMENT="gradu_512_grid_"$(echo $d | tr '/' '_' ) 
	# prepare the running file file 
	OUTPUT=$(bash start.bash --data_dir=$d --run_name=$COMMENT)
	# how many runs did start.bash produce	
	JOBS_FOR_RUN=$(echo $OUTPUT | awk '{ print $2 }')
        # BEGIN holds the file name e.g: JOBGEN_generic_run_04-01-13:12:35.bash
	BEGIN=$(echo $OUTPUT | awk '{print $NF}')
	echo "$d will make $JOBS_FOR_RUN jobs."
	# exit 0
	# Check what is going on in the queue
	JOBS_RUNNING=$(sacct | egrep 'RUNNING' | egrep 'gpu' | wc -l)
	JOBS_PENDING=$(sacct | egrep 'PENDING' | wc -l)
	JOBS_IN_QUEUE=$((JOBS_RUNNING+JOBS_PENDING))
	echo -e "${JOBS_IN_QUEUE} in total.\n\t$JOBS_RUNNING running\n\t$JOBS_PENDING pending\n\t$MAX_JOBS is the maximum number of jobs."
	#echo  $((JOBS_FOR_RUN+JOBS_IN_QUEUE)) 
	# Wai until there is room for the jobs
	while [ $((JOBS_FOR_RUN+JOBS_IN_QUEUE)) -gt "$MAX_JOBS" ]
	do
		echo "Sleeping for 10 minutes"
		#echo "${JOBS_IN_QUEUE} in RUNNING or PENDING. $MAX_JOBS is the maximum number of jobs."
		echo -e "${JOBS_IN_QUEUE} in total.\n\t$JOBS_RUNNING running\n\t$JOBS_PENDING pending\n\t$MAX_JOBS is the maximum number of jobs."
		sleep 600
		JOBS_RUNNING=$(sacct | egrep 'RUNNING' | egrep 'gpu' | wc -l)
		JOBS_PENDING=$(sacct | egrep 'PENDING' | wc -l)
		JOBS_IN_QUEUE=$((JOBS_RUNNING+JOBS_PENDING))
	done # while
	# Launch the jobs
	JOB_INFO=$(bash begin.bash $BEGIN)
	#NOTHING_TO_SEE=$(sbatch scripts/slurm-run.sh scripts/dummy_wait.bash 120)
	echo $JOB_INFO

	echo "Waiting the queue to settle down"
	sleep 20
done # for


