#!/bin/bash

# This file is part of JOBGEN scripting package, which builds automation pipeline for slurm scripts

# Consider the running folder
# https://stackoverflow.com/a/246128
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make bash safer
set -euo pipefail

# default value
early_stopping=false

# extract arguments from command line
for i in "$@"
do
case $i in
    -bs=*|--batch_size=*)
    batch_size="${i#*=}"
    shift # past argument=value
    ;;
    -lr=*|--learning_rate=*)
    learning_rate="${i#*=}"
    shift # past argument=value
    ;;
    -msl=*|--max_seq_length=*)
    max_seq_length="${i#*=}"
    shift # past argument=value
    ;;
    -e=*|--epochs=*)
    epochs="${i#*=}"
    shift # past argument=value
    ;;
    -c=*|--comment=*)
    comment="${i#*=}"
    shift # past argument=value
    ;;
    -es=*|--early_stopping=*)
    early_stopping="${i#*=}"
    shift # past argument=value
    ;;
    -c=*|--comment=*)
    comment="${i#*=}"
    shift # past argument=value
    ;;
    -imd=*|--init_model_dir=*)
    init_model_dir="${i#*=}"
    shift # past argument=value
    ;;
    -tf=*|--test_file=*)
    test_file="${i#*=}"
    shift # past argument=value
    ;;
    -nmdn=*|--ner_model_dir_name=*)
    ner_model_dir_name="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--data_dir=*)
    data_dir="${i#*=}"
    shift # past argument=value
    ;;
    -gb=*|--groupby=*)
    groupby="${i#*=}"
    shift
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

# DEPRECATED, clean at some point
#datadir="$SCRIPTDIR/../$1"
#modeldir="$2"
#batch_size="$3"
#learning_rate="$4"
#max_seq_length="$5"
#epochs="$6"
#comment="$7"
#ner_model_dir_name="$8"
#testtype="$9"

data_dir="$SCRIPTDIR/../$data_dir"
train_data="$data_dir/train.tsv"
test_data="${data_dir}/${test_file}"
ner_model_dir="$SCRIPTDIR/../ner-models/$ner_model_dir_name"

init_model="$init_model_dir/bert_model.ckpt"
vocab="$init_model_dir/vocab.txt"
config="$init_model_dir/bert_config.json"

echo "BC2GM script with the following parameters:"
echo "###########################################"
echo "time: "`date`
echo "Arguments: $@"
echo "datadir: $data_dir"
echo "traindata: $train_data"
echo "testdata: $test_data"
echo "init. modeldir: $init_model_dir"
echo "checkpoint modeldir: $ner_model_dir"
echo "batch_size: $batch_size"
echo "learning rate: $learning_rate"
echo "max seq length: $max_seq_length"
echo "epochs: $epochs"
echo "early stopping: $early_stopping"
echo "comment: $comment"
echo "groupby: $groupby"
echo "saving in: $ner_model_dir"

if [ ! -e "$data_dir" ]; then
    echo "Data not found in:$data_dir (run scripts/get-turku-ner.sh?)" >&2
    exit 1
fi

if [ ! -e "$init_model_dir" ]; then
    echo "Model not found (run scripts/get-models.sh?)" >&2
    exit 1
fi

rm -rf "$ner_model_dir"
mkdir -p "$ner_model_dir"

echo "Now training:"

pythonargs="--vocab_file $vocab \
    --bert_config_file $config \
    --init_checkpoint $init_model \
    --learning_rate $learning_rate \
    --num_train_epochs $epochs \
    --max_seq_length $max_seq_length \
    --batch_size $batch_size \
    --train_data $train_data \
    --test_data $test_data \
    --ner_model_dir $ner_model_dir
"

# TODO: is there a better way, this is clumsy
# add early stopping if not there
if test $early_stopping = true; then
pythonargs="$pythonargs --early_stopping"
fi
#echo $pythonargs

python "$SCRIPTDIR/../ner_v2.py" $pythonargs

