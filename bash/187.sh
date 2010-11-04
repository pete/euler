#!/bin/bash
# This takes a comically long time to run, but it's accurate to as large a
# number as seq(1) and factor(1) can handle.  Interestingly enough, the real
# bottleneck is the grep.
# WITNESS!
# real    162m35.043s
# user    193m12.447s
# sys     0m18.399s

time seq 4 100000000 | xargs factor | grep ': [^ ][^ ]* [^ ][^ ]*$' | wc -l
