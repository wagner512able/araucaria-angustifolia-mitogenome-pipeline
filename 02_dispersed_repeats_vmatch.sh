#!/usr/bin/env bash
# =============================================================================
# 02_dispersed_repeats_vmatch.sh
# Identification of dispersed repeats in mitochondrial chromosomes 1 and 2
# using Vmatch.
#
# Parameters:
#   -l 30  : minimum repeat length of 30 bp
#   -h 3   : up to 3 mismatches (Hamming distance)
#   -d -p  : report direct (forward) and palindromic (reverse-complement) matches
# =============================================================================

# ---- Chromosome 1 ------------------------------------------------------------
# Build the suffix-array index
mkvtree -db CHROMOSOME_1.fasta -dna -pl 7 -allout

# Search for repeats
vmatch -d -p -l 30 -h 3 CHROMOSOME_1.fasta > results_chr1_repeats.txt

# ---- Chromosome 2 ------------------------------------------------------------
mkvtree -db CHROMOSOME_2.fasta -dna -pl 7 -allout

vmatch -d -p -l 30 -h 3 CHROMOSOME_2.fasta > results_chr2_repeats.txt
