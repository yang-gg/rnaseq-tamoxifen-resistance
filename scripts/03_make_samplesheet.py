"""Build the nf-core/rnaseq samplesheet and a sample annotation table
from metadata/runinfo.tsv.

Outputs:
  nextflow/samplesheet.csv   sample,fastq_1,fastq_2,strandedness
  metadata/sample_info.csv   sample,cell_line,condition,run
"""
import re
from pathlib import Path

import pandas as pd

root = Path(__file__).resolve().parent.parent
runs = pd.read_csv(root / "metadata/runinfo.tsv", sep="\t")


def geo_title(row):
    # ENA experiment_title looks like "GSM3024053: MCF-7 Tam1; Homo sapiens; RNA-Seq"
    m = re.match(r"GSM\d+:\s*([^;]+)", str(row.experiment_title))
    return (m.group(1) if m else str(row.sample_title)).strip()


rows, info = [], []
for _, r in runs.iterrows():
    title = geo_title(r)
    condition = "resistant" if re.search(r"tam", title, re.I) else "parental"
    cell_line = re.sub(r"\s*tam\s*\d*$", "", title, flags=re.I)
    cell_line = cell_line.upper().replace("-", "").replace(" ", "")  # BT-474 / BT474 -> BT474
    sample = re.sub(r"[^A-Za-z0-9]+", "_", title).strip("_")
    files = sorted(str(root / "data/fastq" / Path(u).name) for u in str(r.fastq_ftp).split(";"))
    rows.append({
        "sample": sample,
        "fastq_1": files[0],
        "fastq_2": files[1] if len(files) > 1 else "",
        "strandedness": "auto",
    })
    info.append({"sample": sample, "cell_line": cell_line, "condition": condition, "run": r.run_accession})

pd.DataFrame(rows).to_csv(root / "nextflow/samplesheet.csv", index=False)
info = pd.DataFrame(info).sort_values(["cell_line", "condition", "sample"])
info.to_csv(root / "metadata/sample_info.csv", index=False)
print(info.to_string(index=False))
