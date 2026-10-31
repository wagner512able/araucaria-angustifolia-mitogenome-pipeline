# Scripts – Mitochondrial genome of *Araucaria angustifolia*

Scripts used in the article on the mitochondrial genome of *Araucaria angustifolia*.

| File | Description |
|------|-------------|
| `01_assembly_and_probe_validation.sh` | SRA download, ONT assembly with HiMT, and validation of ambiguous graph junctions and circular topology by aligning junction probes to raw reads (minimap2 + samtools; visualization in Tablet) |
| `02_dispersed_repeats_vmatch.sh` | Dispersed repeats (≥ 30 bp, ≤ 3 mismatches) in chromosomes 1 and 2 with Vmatch |
| `03_ssr_chloroplast_blast.sh` | BLASTn of the flanking regions of mitochondria-exclusive SSRs (MICRO-MINE) against the chloroplast genome |
| `filter_blast_hits.py` | Filters BLAST hits (identity ≥ 80%, length ≥ 30 bp) and lists SSRs to discard |
| `04_phylogenomics.sh` | Phylogeny from mitochondrial PCGs: MAFFT, trimAl, catfasta2phyml, IQ-TREE 3 |
| `partitions.nex` | Gene partitions (NEXUS) used by IQ-TREE 3 |

## Software

HiMT, SRA Toolkit (prefetch, fasterq-dump), minimap2, samtools, Tablet, Bandage, Vmatch, BLAST+, Python 3 (pandas), MAFFT, trimAl, catfasta2phyml, IQ-TREE 3.

## Notes

- Script 01 is a step-by-step record: probe construction (Geneious/Bandage) was done manually and the commands are meant to be run block by block.
- Adjust file names and paths (e.g. `/home/wagner/...`) to your environment.
- `partitions.nex`: gene coordinates refer to the concatenated trimmed alignment and must be regenerated if the input genes or trimming change.

## Citation

If you use these scripts, please cite the article (add reference/DOI here).
