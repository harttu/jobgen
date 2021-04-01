#!/bin/bash
set -euo pipefail
OUT="runs/"`head -1 $1 | awk '{print $2}'`"/JOBS"
bash $1 >> $OUT
cat $OUT
awk '{print "scancel "$4}' $OUT > "${OUT}.SCANCEL"

