# Install the R packages used in analysis/DE_analysis.Rmd
# Run from the repository folder: Rscript scripts/install_packages.R
options(repos = c(CRAN = "https://cloud.r-project.org"))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
install.packages(c("tidyverse", "here", "rmarkdown", "pheatmap", "ggrepel", "msigdbr", "languageserver"))
BiocManager::install(c("DESeq2", "edgeR", "limma", "apeglm", "fgsea", "tximport", "GEOquery"), update = FALSE, ask = FALSE)
