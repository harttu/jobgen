#!/bin/bash


############################################################################################
##                                                                                        ##
## JOBGEN: This file generates grid slurm jobs that can be executed after                 ##
##                                                                                        ##
############################################################################################

# TODO:
#1. implement SCRIPTDIR variable, to run from different folders
# https://stackoverflow.com/a/246128
#SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
#)"
# 2. Consider placing the output file directly to the runs dir instead of root
#
# 3. Different running times might on different models, might not be too much advantage, 
# and makes things messy...

##!!
#
cat << EOS
#############################################################
Welcome to using JOBGEN
###                                                       ###
This scripts automates creation of grid runs for slurm-system. 
Output file will begin by JOBGEN_ extension
and can be executed by 
bash begin.bash JOBGEN_...
Please edit this file directly to change parameters
OR
use 
bash start.bash --data_dir=path --run_name=distinct_name_for_run
#############################################################
EOS
#
##!!

############################################################################################
##                                                                                        ##
## VARIABLE SETUP: Here we define constant variables for datasets and models              ##
## E.g To select a dataset:                                                               ##
##     datadir=${Data[gellus]}                                                            ##
##                                                                                        ##
##                                                                                        ##
############################################################################################



## Internal BASH setup for error handling
#
set -euo pipefail
# -e 			exit on fail 
# -u 			exit when empty variable is used
# -o pipefail		exit if any consequent pipe fails


# These are the datasets
#
declare -A Data
Data[gellus]="data/GELLUS-1.0.3/conll/standard/"
Data[bc2gmnarrow]="data/bc2gm-corpus/combined-data/conll-narrow/"
Data[bc2gmwide]="data/bc2gm-corpus/combined-data/conll-wide/"
Data[bc2gmwidesmaller]="data/bc2gm-corpus-smaller/conll-wide"
Data[s800]="data/s800/conll/"
Data[s800_conll2]="data/s800/conll2/"
Data[ncbi]="data/ncbi-disease/conll/"
Data[chemdner]="/data/chemdner-corpora/conll"
Data[chemdnersmaller]="data/chemdner-smaller/conll"
Data[linnaeus]="data/linnaeus-corpus/conll"
Data[linnaeus_train_s800_test]="data/linnaeus_train_s800_devtest/conll"
Data[s800_train_linnaeus_test]="data/s800_train_linnaeus_devtest/conll"
Data[linnaeus_devtraincombined]="/data/linnaeus_devtrain_combined/conll"
Data[anatEM]="/data/AnatEM-1.0.2/conll"
Data[anatEMSingle]="/data/AnatEM-1.0.2/conll_single_class"
Data[anatEMSingleConll2]="/data/AnatEM-1.0.2/conll2_single_class"
Data[news800]="/data/news800/s800-tools/conll"
Data[revision-s800]="/data/s800-revision-data/conll"
Data[linnaeus_general_removed_s800_devel_test]="data/linnaeus-corpus/conll_general_removed_s800_devel_test"
Data[revision-s800-v3]="/data/s800-revision-data-v3/conll"
Data[revision-s800-v5]="/data/s800-revision-data-v5/s800-tools/conll"
Data[revision-s800-v6]="/data/s800-revision-v6/s800-tools/conll"
Data[revision-s800-latest-onlySpecies]="/data/s800-revision-latest/s800-tools/conllOnlySpecies"
Data[revision-s800-latest-SpeciesAndGenus]="/data/s800-revision-latest/s800-tools/conllSpeciesAndGenus"
Data[s800BenchMark]="/data/s800BenchMark/conll"
Data[s800Comparison]="/data/s800-comparison-with-transformers/"
Data[s800-101120]="/data/s800-101120/"
Data[s800-101120-onlySpecies]="/data/s800-101120/onlySpecies/"
Data[linnaeus_filtered]="/data/linnaeus-corpus/conll_filtered/"


### Common
Data[linnaeus]="data/linnaeus-corpus/conll"
Data[linnaeus_filtered]="/data/linnaeus-corpus/conll_filtered/"

### S800-1011

#in-corpus
Data[s800-101120]="/data/s800-101120-only-species/conll"

# combo
Data[cross_TRAIN_linnaeus-and-s800-1011_DEVEL_linnaeus]="/data/cross_TRAIN_linnaeus-and-s800-1011_DEVEL_linnaeus"				
Data[cross_TRAIN_linnaeus-and-s800-1011_DEVEL_s800-1011]="/data/cross_TRAIN_linnaeus-and-s800-1011_DEVEL_s800-1011"	
Data[cross_TRAIN_linnaeus-filtered-and-s800-1011_DEVEL_linnaeus_filtered]="/data/cross_TRAIN_linnaeus-filtered-and-s800-1011_DEVEL_linnaeus_filtered"
Data[cross_TRAIN_linnaeus-filtered-and-s800-1011_DEVEL_s800-1011]="/data/cross_TRAIN_linnaeus-filtered-and-s800-1011_DEVEL_s800-1011"

#cross
Data[cross_TRAIN_s800-1011_DEVEL_linnaeus_filtered]="/data/cross_TRAIN_s800-1011_DEVEL_linnaeus_filtered"
Data[cross_TRAIN_s800-1011_DEVEL_linnaeus]="/data/cross_TRAIN_s800-1011_DEVEL_linnaeus"
Data[cross_TRAIN_linnaeus_DEVEL_S800_1011]="/data/cross_TRAIN_linnaeus_DEVEL_S800_1011"
Data[cross_TRAIN_linnaeus_filtered_DEVEL_S800_1011]="/data/cross_TRAIN_linnaeus_filtered_DEVEL_S800_1011"

### S800 -original

Data[cross_TRAIN_linnaeus-and-s800-original_DEVEL_linnaeus]="/data/cross_TRAIN_linnaeus-and-s800-original_DEVEL_linnaeus"
Data[cross_TRAIN_linnaeus-and-s800-original_DEVEL_s800-original]="/data/cross_TRAIN_linnaeus-and-s800-original_DEVEL_s800-original"
Data[cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_linnaeus_filtered]="/data/cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_linnaeus_filtered"	
Data[cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_s800-original]="/data/cross_TRAIN_linnaeus-filtered-and-s800-original_DEVEL_s800-original"

#cross
Data[cross_TRAIN_s800-original_DEVEL_linnaeus_filtered]="/data/cross_TRAIN_s800-original_DEVEL_linnaeus_filtered"
Data[cross_TRAIN_s800-original_DEVEL_linnaeus]="/data/cross_TRAIN_s800-original_DEVEL_linnaeus"
Data[cross_TRAIN_linnaeus_DEVEL_S800_original]="/data/cross_TRAIN_linnaeus_DEVEL_S800_original"
Data[cross_TRAIN_linnaeus_filtered_DEVEL_S800_original]="/data/cross_TRAIN_linnaeus_filtered_DEVEL_S800_original"

#datadir=${Data[cross_TRAIN_linnaeus_filtered_DEVEL_S800_1011]}

#datadir=${Data[cross_TRAIN_linnaeus-filtered-and-s800-1011_DEVEL_s800-1011]}

##########
#
# Select a dataset to be used in this run

datadir=${Data[linnaeus]}


############################################################################################
##                                                                                        ##
## MODEL SELECTION: We will iterate through all the models                                ##
## To use: Uncomment the ones you want to use	                                          ##
##                                                                                        ##
##                                                                                        ##
############################################################################################ 
# This variable holds the models knows to the system
declare -A Models;
#Models[biobert_large]=/scratch/project_2001426/models/biobert_large 
#Models[NCBI_uncased_L12]=/scratch/project_2001426/models/NCBI_BERT_pubmed_uncased_L-12_H-768_A-12
Models[biobert_pubmed]=/scratch/project_2001426/models/biobert_v1.1_pubmed_std_naming
#Models[scibert_uncased]=/scratch/project_2001426/models/scibert_scivocab_uncased
#Models[scibert_cased]=/scratch/project_2001426/models/scibert_scivocab_cased
#Models[biobert_pubmed_pmc]=/scratch/project_2001426/models/biobert_v1.0_pubmed_pmc
#Models[NCBI_uncased_L24]=/scratch/project_2001426/models/NCBI_BERT_pubmed_uncased_L-24_H-1024_A-16
#Models[wwm_cased_L24]=/scratch/project_2001426/models/wwm_cased_L-24_H-1024_A-16
#Models[uncased_L24]=/scratch/project_2001426/models/uncased_L-24_H-1024_A-16
#Models[uncased_L12]=/scratch/project_2001426/models/uncased_L-12_H-768_A-12
#Models[cased_L12]=/scratch/project_2001426/models/cased_L-12_H-768_A-12

declare -A ModelSize
ModelSize[biobert_large]="L"
ModelSize[biobert_pubmed]="N"
ModelSize[NCBI_uncased_L12]="N"
ModelSize[scibert_uncased]="N"
ModelSize[scibert_cased]="N"
ModelSize[biobert_pubmed_pmc]="N"
ModelSize[NCBI_uncased_L24]="L"
ModelSize[wwm_cased_L24]="L"
ModelSize[uncased_L24]="L"
ModelSize[uncased_L12]="N"
ModelSize[cased_L12]="N"


############################################################################################
##                                                                                        ##
## PARAMETER SELECTION: Typ he desired parameters to the following arrays                 ##
## To use: Uncomment the ones you want to use	                                          ##
## For finetuning BERT, these are the best values                                         ##
## * Batch size: 16, 32									  ##
## * Learning rate (Adam): 5e-5, 3e-5, 2e-5                                               ##
## * Number of epochs: 2, 3, 4                                                            ##
## * Max sequence length: 512                                                             ##
##                                                                                        ##
############################################################################################ 

# How many times to repeat each parameter combination
readonly repeats_arr=(1 2 3)
#(1 2 3)
readonly epochs_arr=(6)
readonly max_seq_len_arr=(512) 
# 352 368 384 400)
#(64 128 192 256 320)
readonly learning_rate_arr=("5e-5" "3e-5" "2e-5")
readonly batch_size_arr=(2 4 8 16)

readonly timenow=$(date +"%m-%d-%T")
#use either test.tsv or devel.tsv
readonly testtype="devel.tsv"
readonly early_stopping=true

run_name="generic_run"

#
# is the script called without arguments
if [[ $# == 0 || -z "$1" ]]
then
	echo "Using data:$datadir"
	echo -e "\tusing:$testtype"
	echo "Using models:${Models[*]}"
	echo "Using following grid params:"
	echo -e "\tmax_seq_len:${max_seq_len_arr[*]}"
	echo -e "\tlearning_rate:${learning_rate_arr[*]}"
	echo -e "\tbatch_size:${batch_size_arr[*]}"
	echo -e "\tearly_stopping:${early_stopping[*]}"
	echo "Please give name description for this run (no spaces)"
	read run_name
else
	# in the case the script is called by another program we set up as following
	for i in "$@"
	do
	case $i in
    		-data_dir=*|--datadir=*)
    		datadir="${i#*=}"
    		shift # past argument=value
    		;;
    		-run_name=*|--runname=*)
    		run_name="${i#*=}"
    		shift # past argument=value
    		;;
    		--default)
    		DEFAULT=YES
    		shift # past argument with no value
    		;;
    		*)
          	# unknown option
    		;;
	esac
done

fi


# 'runs' is the default dictory where everything goes
readonly projectdir="runs/${run_name}"
# 'JOBGEN_ is the start for the files that this script produces
readonly OUTPUTFILE="JOBGEN_${run_name}_${timenow}.bash"

### Check if a directory already exists ###
if [ -d "$projectdir" ] 
then
    echo "Directory $projectdir already exists... Aborting." 
    exit 1 # die with error code 9999
fi

echo "# $run_name" > "$OUTPUTFILE"
echo "Creating directory: $projectdir"
mkdir "$projectdir"
mkdir "$projectdir/slurm/"
echo "#CREATED AT "`date` >> "${projectdir}/INFO"


############################################################################################
##                                                                                        ##
## LOOP: This loop will create each job as a command and put it in OUTPUTFILE             ##
##                                                                                        ##
############################################################################################ 

# counter for iteration in the loop
counter=0

for model in "${!Models[@]}"
do
	# prepare a propriate slurm script for the run
	slurmscript="${projectdir}/slurm/slurm-${model}.sh"
	
	## This feature is optional and does not count on small runs
	## For larger models, we use a different slurm setup, this helps getting the jobs in the queue
	if [ "${ModelSize[$model]}" == "L" ]
	then
		awk -v gputype="gpu" -v mem="16G" -v time="02:00:00" -v dir="${run_name}" -f JOBGEN/slurm-template/template_parser.awk JOBGEN/slurm-template/slurm.template > "$slurmscript"
	elif [ "${ModelSize[$model]}" == "N" ]
	then
		awk -v gputype="gpu" -v mem="16G" -v time="01:00:00" -v dir="${run_name}" -f JOBGEN/slurm-template/template_parser.awk JOBGEN/slurm-template/slurm.template > "$slurmscript"
	else
		echo "No match for $model in $ModelSize"
		exit 1
	fi
	
	# Main loops
	for max_seq_len in "${max_seq_len_arr[@]}"; 
	do
		for learning_rate in "${learning_rate_arr[@]}";
		do
			for batch_size in "${batch_size_arr[@]}";
			do
				for epochs in "${epochs_arr[@]}";
				do
					for repeat in "${repeats_arr[@]}";
					do
						# counter is needed to differentiate every folder for the model dir
						counter=$((counter+1))
						model_dir="${Models[$model]}"
						#epochs=${epochs_arr[0]}
						groupby="msq_${max_seq_len}_lr_${learning_rate}_bs_${batch_size}_e_${epochs}"
						ner_saving_dir="${run_name}_$counter"
						#echo "sbatch $slurmscript scripts/run-JOBGEN.sh $datadir $model_dir $batch_size $learning_rate $max_seq_len $epochs \"$comment\" $ner_saving_dir $testtype" >> $OUTPUTFILE

# this is the main command
sbatch_cmd="sbatch $slurmscript scripts/run-JOBGEN.sh --data_dir=$datadir \
--init_model_dir=$model_dir --batch_size=$batch_size --learning_rate=$learning_rate \
--max_seq_length=$max_seq_len --epochs=$epochs --comment=\"$run_name\" --ner_model_dir_name=$ner_saving_dir \
--test_file=$testtype --early_stopping=$early_stopping --groupby=$groupby"

# OPTIONAL
# for evaluation, uncomment
#sbatch_cmd_eval="sbatch $slurmscript scripts/run-JOBGEN.sh --data_dir=$datadir \
#--init_model_dir=$model_dir --batch_size=$batch_size --learning_rate=$learning_rate \
#--max_seq_length=$max_seq_len --epochs=$epochs --comment=\"$comment\" --ner_model_dir_name=$ner_saving_dir \
#--test_file=train.tsv --early_stopping=false --groupby=$groupby"

# write sbatch commands to the file
echo $sbatch_cmd >> $OUTPUTFILE

					done
				done 
			done
		done
	done
done

echo -n -e "Total of JOBS:\t$counter\t were created."

############################################################################################
##                                                                                        ##
## COPY AUXFILES: We will copy the aux files from JOBGEN to the project dir               ##
##                                                                                        ##
############################################################################################ 
#exit 1
# generate a file that can be easily used for launching the evaluation test

#
# copy auxiliary files for the project dir
echo "Copying files..."
cp JOBGEN/auxfiles/jobgenreport.awk $projectdir
cp JOBGEN/auxfiles/copy_best_model_and_clean.sh $projectdir
cp JOBGEN/auxfiles/avg_std_parser.awk $projectdir
cp JOBGEN/auxfiles/send_results.bash $projectdir
cp JOBGEN/auxfiles/get_results.bash $projectdir

# PUHTI-specific:
# make a DEBUG prefix file that will run one test run on gpu-test partition
command=`head -1 $OUTPUTFILE | awk '{ gsub(/slurm-run/,"slurm-run-gputest"); print; }'`
echo $command >> "${OUTPUTFILE}.DEBUG"

# make the main files executable 
chmod +x $OUTPUTFILE
chmod +x "${OUTPUTFILE}.DEBUG"

# keep record of the runs
echo -e `date`"\t$run_name" >> runs/runs.log

# The end
echo -e "Written:\t$OUTPUTFILE"
