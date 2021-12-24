#!/bin/bash
# Part 2.

set -eou pipefail

./split.py \
    --seed 11215 \
    --input_path tgl.tsv \
    --train_path train.tgl.tsv \
    --dev_path dev.tgl.tsv \
    --test_path test.tgl.tsv
