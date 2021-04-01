#!/bin/bash

BESTLINE=$(bash get_results.bash|head -1)
MODEL="../../ner-models/"$(echo $BESTLINE | cut -d " " -n -f 4)
FSCORE=$(echo $BESTLINE | cut -d " " -n -f 15)
echo "Best model is $MODEL with F-score $FSCORE"

echo "Copying the best model here"
cp -v -r $MODEL .

read -p "Deleting the models from ner-models. Press Ctrl + C to quit."
MODELS=$(bash get_results.bash | cut -d " " -n -f 4)
for d in $MODELS; do
 rm -r "../../ner-models/$d"
done



