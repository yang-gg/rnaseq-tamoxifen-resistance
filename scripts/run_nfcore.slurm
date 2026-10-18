#!/bin/bash
# Submit with: sbatch scripts/run_nfcore.slurm
# This job only runs the Nextflow "head" process; Nextflow submits each step as its own Slurm job.
#SBATCH --job-name=nfcore-rnaseq
#SBATCH --partition=sapphire
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --output=logs/nfcore_%j.log

set -euo pipefail
cd "$SLURM_SUBMIT_DIR"
mkdir -p logs
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate rnaseq-tamres
module load Apptainer 2>/dev/null || module load Singularity 2>/dev/null || true

export NXF_SINGULARITY_CACHEDIR="$PWD/.singularity_cache"
nextflow run nf-core/rnaseq -r 3.14.0 \
  -profile singularity \
  -params-file nextflow/params.yaml \
  -c nextflow/slurm.config \
  -resume
