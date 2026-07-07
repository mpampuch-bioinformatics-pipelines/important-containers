# README

Tests I ran so far

## All Available Dimensionality Reduction techniques

```bash
# inside here /ibex/scratch/projects/c2303/20260614_make-kmer-ord-singularity-container
srun --pty --cpus-per-task=8 --mem=128G --time=02:00:00 bash
conda activate $(realpath env)

apptainer shell --bind "$PWD:/data" --pwd /data kmer-ord.linux.amd64.potentiallyWorking.needsTesting.20260629.sif

# Inside container
kmer-ord project --dr umap,tsne,trimap,pacmap,localmap,pca,sparse_pca,kernel_pca,lle --tiara --input 63_Monoraphidiumcircinale.hifi_reads.subsampled.5percent.fasta --output testtodayalldr
```

Definitely worked! ✅

![20270707_web-app-view](../20260707_kmer-ord-results_from-sing-container-v1-and-web-app-from-docker-container-v1_tiara-1st-pass.png)