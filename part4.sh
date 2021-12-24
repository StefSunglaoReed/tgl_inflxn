#!/bin/bash
# Part 4.

set -eou pipefail

# Training.
fairseq-train \
    data-bin \
    --save-dir part4 \
    --source-lang tgl.lemma \
    --target-lang tgl.agfocnfin \
    --seed 11215 \
    --arch transformer \
    --batch-size 128 \
    --dropout .2 \
    --share-decoder-input-output-embed \
    --encoder-layers 4 \
    --encoder-attention-heads 4 \
    --encoder-embed-dim 128 \
    --encoder-normalize-before \
    --decoder-layers 4 \
    --decoder-attention-heads 4 \
    --decoder-embed-dim 128 \
    --decoder-output-dim 128 \
    --decoder-normalize-before \
    --activation-fn relu \
    --lr .0003 \
    --lr-scheduler inverse_sqrt \
    --warmup-init-lr 1e-7 \
    --optimizer adam \
    --adam-betas '(.9,.98)' \
    --clip-norm 1 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing .1 \
    --max-update 6000 \
    --wandb-project "TGL Inflection Training" \
    

# Development set WER.
readonly DEV_RESULT=part4.dev.txt
fairseq-generate \
    data-bin \
    --source-lang tgl.lemma \
    --target-lang tgl.agfocnfin \
    --path part4/checkpoint_best.pt \
    --gen-subset valid \
    --beam 8 \
    --wandb-project "TGL Dev Inflections" \
    --scoring bleu \
    > "${DEV_RESULT}" 2>/dev/null
echo "${DEV_RESULT}: $(./wer.py "${DEV_RESULT}")"


# Test set WER.
readonly TEST_RESULT=part4.test.txt
fairseq-generate \
    data-bin \
    --source-lang tgl.lemma \
    --target-lang tgl.agfocnfin \
    --path part4/checkpoint_best.pt \
    --gen-subset test \
    --beam 8 \
    --wandb-project "TGL Test Inflections" \
    --scoring bleu \
    > "${TEST_RESULT}" 2>/dev/null
echo "${TEST_RESULT}: $(./wer.py "${TEST_RESULT}")"

