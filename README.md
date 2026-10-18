# Transcriptomic signatures of tamoxifen resistance in ER+ breast cancer

> 🚧 Work in progress / 进行中

## Question

Which genes and pathways change consistently when ER-positive breast cancer cells become resistant to tamoxifen, across several independent cell lines?

## Data

- **GEO:** [GSE111151](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE111151) (SRA: SRP133519, BioProject PRJNA436018)
- **Paper:** PubMed [30143015](https://pubmed.ncbi.nlm.nih.gov/30143015/)
- **Samples:** 11 bulk RNA-seq libraries (Illumina HiSeq 2000) from 4 ER+ cell lines, each with its tamoxifen-sensitive parental line and 1–2 tamoxifen-resistant derivatives

| Cell line | Parental | Resistant |
|---|---|---|
| MCF-7 | 1 | 1 |
| T-47D | 1 | 2 |
| ZR-75-1 | 1 | 2 |
| BT-474 | 1 | 2 |

## Workflow

1. `scripts/01_get_metadata.sh`: fetch run metadata from ENA
2. `scripts/02_download_fastq.sh`: download FASTQ files and check MD5 sums
3. `scripts/03_make_samplesheet.py`: build the nf-core samplesheet and sample annotation
4. [nf-core/rnaseq](https://nf-co.re/rnaseq) (Nextflow): QC, trimming and Salmon quantification against GENCODE v46
5. `analysis/DE_analysis.Rmd`: exploratory analysis, DESeq2 with a paired design (`~ cell_line + condition`), comparison with edgeR and limma-voom, and GSEA on MSigDB Hallmark gene sets

## Results

_Coming soon: PCA, volcano plot, top genes, enriched pathways and interpretation._

## Reproduce

```bash
conda env create -f environment.yml
conda activate rnaseq-tamres

bash scripts/01_get_metadata.sh
bash scripts/02_download_fastq.sh
python scripts/03_make_samplesheet.py

nextflow run nf-core/rnaseq -r 3.14.0 -profile singularity -params-file nextflow/params.yaml
# on a Slurm cluster (e.g. Spartan) use instead: sbatch scripts/run_nfcore.slurm

Rscript -e 'rmarkdown::render("analysis/DE_analysis.Rmd")'
```

## Limitations

- One library per cell line and condition, so the four cell lines serve as the biological replicates
- Cell-line models only; findings need validation in patient data

## Repository layout

```
├── analysis/      R Markdown analysis
├── metadata/      run and sample tables
├── nextflow/      nf-core parameters and cluster config
├── results/       figures and tables (raw data is not tracked)
└── scripts/       data download and preparation
```
