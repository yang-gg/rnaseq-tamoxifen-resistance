# Install the R packages used in analysis/DE_analysis.Rmd
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
install.packages(c("tidyverse", "here", "rmarkdown", "pheatmap", "ggrepel", "msigdbr"))
BiocManager::install(c("DESeq2", "edgeR", "limma", "apeglm", "fgsea", "tximport"), update = FALSE)
