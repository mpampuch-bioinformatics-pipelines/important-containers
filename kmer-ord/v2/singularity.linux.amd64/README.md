# README

This one should have seqkit installed in the base path

Tests I ran so far:

`kmer-ord setup` outputs:

```
----------------------------------------------------------------------

Starting kmerord setup... ───────────────────────────────────────────────────────────────
    kmerord-dependencies-0.1 already exists. Skipping.
    kmerord-tiara-0.1 already exists. Skipping.

Installing Rust-based tool... ───────────────────────────────────────────────────────────
    kmer-counter already installed in kmerord-dependencies-0.1. Skipping.
    Rust tool installation complete.

Setting up rDNA-miner... ────────────────────────────────────────────────────────────────
    kmerord-rdna-0.1 already exists. Skipping.

Verifying external tools... ─────────────────────────────────────────────────────────────
    kmer-counter detected and working
    tiara detected and working
    barrnap detected and working
    flye detected and working
    minimap2 detected and working
    samtools detected and working
    Rscript detected and working
----------------------------------------------------------------------
    
All tools verified successfully

Setup complete. kmerord is ready to use.
```

## All Available Dimensionality Reduction techniques

```bash
# inside here /ibex/scratch/projects/c2303/20260614_make-kmer-ord-singularity-container
srun --pty --cpus-per-task=8 --mem=128G --time=02:00:00 bash
conda activate $(realpath env)

apptainer shell --bind "$PWD:/data" --pwd /data kmer-ord.linux.amd64.potentiallyWorking.needsTesting.20260719.sif

# Inside container
kmer-ord project --dr umap,tsne,trimap,pacmap,localmap,pca,sparse_pca,kernel_pca,lle --tiara --input 63_Monoraphidiumcircinale.hifi_reads.subsampled.5percent.fasta --output test_20260719_all_dr
```