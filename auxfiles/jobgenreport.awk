#
# This file is part of the JOBGEN package, 
# it will extract info from the output of ner.py file and transfrom it into a space separated data, which is easy to paste to excel
# It is highly dependent of the output of run-JOBGEN.py file
# 

# TODO:
# update run-JOBGEN to use JSON-like output strategy


# A sample output file look the following:
#######################################################################################

#START 3464445 (scripts/run-JOBGEN.sh): Tue Sep 22 10:11:49 EEST 2020
#BC2GM script with the following parameters:
###########################################
#time: Tue Sep 22 10:11:49 EEST 2020
#Arguments:
#datadir: /users/htoivone/links/august/scripts/..//users/htoivone/links/august/data/s800-revision-data-v3/conll
#traindata: /users/htoivone/links/august/scripts/..//users/htoivone/links/august/data/s800-revision-data-v3/conll/train.tsv
#testdata: /users/htoivone/links/august/scripts/..//users/htoivone/links/august/data/s800-revision-data-v3/conll/devel.tsv
#init. modeldir: /scratch/project_2001426/models/biobert_large
#checkpoint modeldir: /users/htoivone/links/august/scripts/../ner-models/s800-v3-grid_3
#batch_size: 2
#learning rate: 5e-5
#max seq length: 256
#epochs: 4
#early stopping: true
#comment: s800-v3-grid
#saving in: /users/htoivone/links/august/scripts/../ner-models/s800-v3-grid_3
#END 3464445 (scripts/run-JOBGEN.sh): Tue Sep 22 10:11:49 EEST 2020
#Job ID: 3464445
#Cluster: puhti
#User/Group: htoivone/htoivone
#State: RUNNING
#Cores: 1
#CPU Utilized: 00:00:00
#CPU Efficiency: 0.00% of 00:00:01 core-walltime
#Job Wall-clock time: 00:00:01
#Memory Utilized: 0.00 MB (estimated maximum)
#Memory Efficiency: 0.00% of 16.00 GB (16.00 GB/node)
#Job consumed 0.02 CSC billing units based on following used resources
#CPU BU: 0.00
#Mem BU: 0.00
#GPU BU: 0.02
#WARNING: Efficiency statistics may be misleading for RUNNING jobs.
#########################################################################################

BEGIN{ 
job_id="-";
model_dir="-";
data_dir="-"
max_seq_len="-";
batch_size="-";
learning_rate="-";
epochs="-";
accuracy="0 0 0 0";
memory="0"
time="0"
test="0"
losses="0"
starttime="0"
comment="-"
ner_model="-"
groupby="-"
}
{
if( /START/ ) { 
job_id=$2;   
tmp=""
#for(i=2;i<=NF;++i)
#{tmp=tmp" "$i}
#starttime=tmp
starttime=$4"_"$5"_"$6"_"$7"_"$8"_"$9
}
if(/^init. modeldir/){
gsub(/\/scratch\/project_2001426\/models\//,"")
model_dir=$3 
}
if(/datadir/) { 
gsub(/\/scratch\/project_2001426\/harttu\/july-2020\/keras-bert-ner\/scripts\/\.\./,"")
data_dir=$2
}
if(/^checkpoint modeldir/){
gsub(/\/users\/htoivone\/links\/august\/scripts\/..\/ner-models\//,"")
ner_model=$3 
}

if(/^max seq length/){ max_seq_len=$NF }
if(/^batch_size/) { batch_size=$NF }
if(/^learning rate/) { learning_rate=$NF }
if(/^epochs/) { epochs=$NF}

# change here to capture only e.g. Species
if(/^accuracy/) { 
gsub(/%;/," ")
accuracy=$2" "$4" "$6" "$8
}
if(/groupby/ ) {groupby=$2 }
if(/Job Wall-clock time/ ) { time=$4 }
if(/comment/) { comment=$NF }
if(/Memory Utilized/) { memory=$3 }
if(/testdata/) { 
gsub(/devel.tsv/," devel.tsv")
gsub(/test.tsv/," test.tsv")
test=$3 }
if( /loss:/ ) {
losses=losses" "$9}
}
# this is the output syntax for excel sheet
END{ print starttime" "job_id" "groupby" "ner_model" "model_dir" "data_dir" "test" "max_seq_len" "batch_size" "learning_rate" "epochs" "accuracy" X X "memory" "time" "losses }
