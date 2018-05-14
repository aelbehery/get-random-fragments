#!/usr/bin/env python
from Bio import SeqIO
import sys
import random

selected = []
gen = SeqIO.parse(sys.argv[1], "fasta")
#filter out all records with one or more Ns
gen_wo_N = (record for record in gen if "N" not in record.seq)
first_record = gen_wo_N.next()
genome = "_".join(first_record.description.split("_")[:-1])
records = [first_record]

for record in gen_wo_N:
    if "_".join(record.description.split("_")[:-1]) == genome:
        records.append(record)
    else:
        selected.append(random.choice(records))
        genome = "_".join(record.description.split("_")[:-1])
        records = [record]

selected.append(random.choice(records))
SeqIO.write(selected, sys.argv[2], "fasta")
