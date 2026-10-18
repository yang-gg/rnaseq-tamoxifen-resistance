#!/usr/bin/env bash
# Download run metadata for GSE111151 (BioProject PRJNA436018) from ENA.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p metadata
FIELDS="run_accession,experiment_title,sample_title,library_layout,read_count,fastq_ftp,fastq_md5"
curl -sSf "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJNA436018&result=read_run&fields=${FIELDS}&format=tsv" \
  -o metadata/runinfo.tsv
echo "Saved $(($(wc -l < metadata/runinfo.tsv) - 1)) runs to metadata/runinfo.tsv"
