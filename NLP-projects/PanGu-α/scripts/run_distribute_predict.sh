#!/bin/bash
execute_path=$(pwd)
script_self=$(readlink -f "$0")
self_path=$(dirname "${script_self}")
export RANK_SIZE=$1
export RANK_TABLE_FILE=$2
export STRATEGY=$3
export TOKENIZER=$4
export CKPT_PATH=$5
export CKPT_NAME=$6
export MODE=$7

for((i=0;i<$RANK_SIZE;i++));
do
  rm -rf ${execute_path}/device_$i/
  mkdir ${execute_path}/device_$i/
  cd ${execute_path}/device_$i/ || exit
  export RANK_ID=$i
  export DEVICE_ID=$i
  python -s ${self_path}/../run_pangu_alpha_predict.py --strategy_load_ckpt_path=$STRATEGY --tokenizer_path=$TOKENIZER --load_ckpt_path=$CKPT_PATH \
                  --load_ckpt_name=$CKPT_NAME --mode=$MODE  >train_deep$i.log 2>&1 &
done
