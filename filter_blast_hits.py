#!/usr/bin/env python3
"""
filter_blast_hits.py

Filter the BLASTn table (tabular format 6) of mitochondrial SSR flanking
sequences against the chloroplast genome.

Each row of the input is a mitochondria-exclusive SSR that obtained some
degree of similarity (hit) in the chloroplast. Hits with >= 80% identity and
>= 30 bp alignment length are kept, and their query IDs are written to a list
of SSRs to discard.
"""

import pandas as pd

BLAST_FILE = "blast_chloroplast_result.tsv"
OUTPUT_FILE = "ssrs_to_discard.txt"
MIN_IDENTITY = 80.0   # percent
MIN_LENGTH = 30       # bp

col_names = ["qseqid", "sseqid", "pident", "length", "mismatch", "gapopen",
             "qstart", "qend", "sstart", "send", "evalue", "bitscore"]
df = pd.DataFrame(columns=col_names)

try:
    df = pd.read_csv(BLAST_FILE, sep="\t", names=col_names)
except pd.errors.EmptyDataError:
    print("No alignments found! All sequences are exclusively mitochondrial.")

if not df.empty:
    filtered = df[(df["pident"] >= MIN_IDENTITY) & (df["length"] >= MIN_LENGTH)]
    print(f"Total SSRs with similarity in the chloroplast: {len(filtered)}")
    print(filtered[["qseqid", "pident", "length", "evalue"]])

    # Save the list of IDs to remove
    filtered["qseqid"].to_csv(OUTPUT_FILE, index=False, header=False)
