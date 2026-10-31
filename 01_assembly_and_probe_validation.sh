#!/usr/bin/env bash
# =============================================================================
# 01_assembly_and_probe_validation.sh
# Mitogenome assembly of Araucaria angustifolia from ONT reads and validation
# of ambiguous assembly-graph junctions using probe-to-read alignments.
#
# NOTE: This file documents the workflow step by step (some steps are manual,
# e.g. Bandage/Geneious). Run the commands interactively, block by block.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Download SRA reads and assemble
# -----------------------------------------------------------------------------
conda activate sra

# Download the SRA files
prefetch ERR14084558 ERR14173458 --max-size 400G

# Convert to FASTQ
fasterq-dump --split-3 --threads 100 --progress ERR14084558
fasterq-dump --split-3 --threads 100 --progress ERR14173458

# Merge both runs into a single FASTQ
cat ERR14084558.fastq ERR14173458.fastq > ONT_unified.fastq

conda deactivate
conda activate himt_env

# Assembly with HiMT (plant mode, ONT reads)
./himt assemble \
    -i /home/wagner/mtDNA_araucaria/ONT_unified.fastq \
    -o /home/wagner/mtDNA_araucaria/ONT_unified \
    -s plant \
    -d ONT \
    -t 90


# -----------------------------------------------------------------------------
# 2. Aligning probes to the raw reads
# -----------------------------------------------------------------------------
# ---- HUB 1 (single molecule) -------------------------------------------------
# Four 2,000-bp probes (FASTA) were built manually (e.g. in Geneious), each by
# joining the last 1,000 bp of one edge to the first 1,000 bp of the next edge.
#
# Inputs (arriving at edge_1932-):
#   Probe In-A  (edge_3839+ > edge_1932-): last 1,000 bp of edge_3839+ +
#               first 1,000 bp of edge_1932-  -> Probe_InA_3839_1932.fasta
#   Probe In-B  (edge_3954- > edge_1932-): last 1,000 bp of edge_3954- +
#               first 1,000 bp of edge_1932-  -> Probe_InB_3954_1932.fasta
#
# Outputs (leaving edge_1932-):
#   Probe Out-C (edge_1932- > edge_462-):  last 1,000 bp of edge_1932- +
#               first 1,000 bp of edge_462-   -> Probe_OutC_1932_462.fasta
#   Probe Out-D (edge_1932- > edge_1933+): last 1,000 bp of edge_1932- +
#               first 1,000 bp of edge_1933+  -> Probe_OutD_1932_1933.fasta
#
# Each probe was aligned to the ONT long reads, then sorted and indexed for
# visual inspection in Tablet.

# 2.1 Probe In-A
minimap2 -ax map-pb Probe_InA_3839_1932.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o alignment_InA.bam
samtools index alignment_InA.bam

# 2.2 Probe In-B
minimap2 -ax map-pb Probe_InB_3954_1932.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o alignment_InB.bam
samtools index alignment_InB.bam

# 2.3 Probe Out-C
minimap2 -ax map-pb Probe_OutC_1932_462.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o alignment_OutC.bam
samtools index alignment_OutC.bam

# 2.4 Probe Out-D
minimap2 -ax map-pb Probe_OutD_1932_1933.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o alignment_OutD.bam
samtools index alignment_OutD.bam


# -----------------------------------------------------------------------------
# 3. Head-to-tail test of the full 1.93 Mb "master circle"
#    (rules out possible linear breaks)
# -----------------------------------------------------------------------------
# The 56-step path validated in Bandage was exported as a single sequence.
# The last 1,000 bp and the first 1,000 bp were extracted and joined in this
# exact order (end + start) to form a 2,000-bp junction probe:
#   Probe_MasterCircle_Junction.fasta

minimap2 -ax map-pb Probe_MasterCircle_Junction.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o alignment_MasterCircle.bam
samtools index alignment_MasterCircle.bam


# -----------------------------------------------------------------------------
# 4. Subcircle 2 (edge_2096, 642,497 bp)
# -----------------------------------------------------------------------------
# edge_2096 was imported into Geneious; the first and last 1,000 bp were
# extracted and concatenated in this order: last 1,000 bp + first 1,000 bp.
# The resulting 2,000-bp sequence was exported with a single header as
#   Probe_MegaCircle_2096.fasta
# (minimap2 v2.1.1, samtools v1.16.1)

minimap2 -ax map-pb Probe_MegaCircle_2096.fasta ONT_unified.fastq \
    | samtools view -F 4 -u \
    | samtools sort -o MegaCircle_aligned.bam

# Index for visualization in Tablet
samtools index MegaCircle_aligned.bam
