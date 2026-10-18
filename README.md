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

**Upstream, on [Galaxy Australia](https://usegalaxy.org.au)** (a public bioinformatics platform):

1. Import FASTQ files from SRA (`fasterq-dump`)
2. Quality control with FastQC, adapter and quality trimming with fastp, summary with MultiQC
3. Transcript quantification with Salmon against GENCODE v46 human transcripts

**Downstream, in R** (`analysis/DE_analysis.Rmd`):

1. Gene-level summarisation with tximport
2. Exploratory analysis (VST, PCA, sample clustering)
3. Differential expression with DESeq2 using a paired design (`~ cell_line + condition`), with apeglm log fold change shrinkage
4. Comparison with edgeR (quasi-likelihood) and limma-voom
5. Gene set enrichment (fgsea, MSigDB Hallmark)

## Results

_Coming soon: PCA, volcano plot, top genes, enriched pathways and interpretation._

## Reproduce

1. Run the Galaxy steps above and download one Salmon `quant.sf` per run into `data/salmon/`, named by SRA run accession (e.g. `data/salmon/SRRxxxxxxx.tabular`).
2. Download the run table from the [SRA Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP133519) to `metadata/SraRunTable.csv`.
3. Install the R packages and render the report:

```bash
Rscript scripts/install_packages.R
Rscript -e 'rmarkdown::render("analysis/DE_analysis.Rmd")'
```

## Limitations

- One library per cell line and condition, so the four cell lines serve as the biological replicates
- Cell-line models only; findings need validation in patient data

## Repository layout

```
├── analysis/      R Markdown analysis
├── metadata/      sample annotation (GEO) and run table (SRA)
├── results/       figures and tables (raw data is not tracked)
└── scripts/       package installation
```
