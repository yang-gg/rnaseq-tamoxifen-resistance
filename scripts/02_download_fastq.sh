#!/usr/bin/env bash
# Download FASTQ files listed in metadata/runinfo.tsv and check their MD5 sums.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data/fastq
tail -n +2 metadata/runinfo.tsv | while IFS=$'\t' read -r run _ _ _ _ ftp md5; do
  IFS=';' read -ra urls <<< "$ftp"
  IFS=';' read -ra sums <<< "$md5"
  for i in "${!urls[@]}"; do
    f="data/fastq/$(basename "${urls[$i]}")"
    [[ -s "$f" ]] || curl -sSf -o "$f" "https://${urls[$i]}"
    echo "${sums[$i]}  $f" | md5sum -c --quiet -
  done
  echo "done: $run"
done
