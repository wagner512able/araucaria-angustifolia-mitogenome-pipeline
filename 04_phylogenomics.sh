#!/usr/bin/env bash
# =============================================================================
# 04_phylogenomics.sh
# Phylogenetic analysis based on shared single-copy mitochondrial PCGs.
#
# Input: one FASTA file per gene (*.fasta), containing the sequences of all
#        species.
# Requires: MAFFT, trimAl, catfasta2phyml, IQ-TREE 3
# =============================================================================

# 1. Align each gene with MAFFT
for f in *.fasta; do
    mafft "$f" > "$f.ali"
done

# 2. Trim alignments with trimAl
for f in *.fasta.ali; do
    trimal -in "$f" -out "$f.trim" -automated1
done

# 3. Concatenate the trimmed alignments (supermatrix) with catfasta2phyml
catfasta2phyml -c -f *.fasta.ali.trim > concatenated.fasta

# 4. Partition file: see partitions.nex (gene boundaries must match the
#    trimmed alignment lengths in the concatenation order).

# 5. Maximum-likelihood tree with IQ-TREE 3
#    -m MFP+MERGE : ModelFinder with partition merging
#    -B 1000      : 1,000 ultrafast bootstrap replicates
iqtree3 -s concatenated.fasta -p partitions.nex -m MFP+MERGE -B 1000 -T 30
