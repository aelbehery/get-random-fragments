#!/usr/bin/env python
from Bio import SeqIO
import sys
import random

selected = []
first_record = SeqIO.parse(sys.argv[1], "fasta").next()
genome = "_".join(first_record.description.split("_")[:-1])
records = [first_record]
for record in SeqIO.parse(sys.argv[1], "fasta"):
    if "_".join(record.description.split("_")[:-1]) == genome:
        records.append(record)
    else:
        selected.append(random.choice(records))
        genome = "_".join(record.description.split("_")[:-1])
        records = [record]
selected.append(random.choice(records))
SeqIO.write(selected, sys.argv[2], "fasta")
