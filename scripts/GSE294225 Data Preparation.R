library(GEOquery)
library(DESeq2)
library(dplyr)
library(readr)

gse <- getGEO("GSE294225", GSEMatrix = TRUE)
metadata <- pData(phenoData(gse[[1]]))

sample_info <- metadata %>%
  dplyr::select(geo_accession, description, `subject status:ch1`) %>%
  mutate(sample_id = gsub("Library name: ", "", description)) %>%
  rename(condition = `subject status:ch1`)

sample_info$condition <- as.factor(sample_info$condition)

counts_raw <- read.csv("GSE294225_RNAseq_RA_Normalised_Counts.csv.gz", header = TRUE, row.names = 1, check.names = FALSE)

common_samples <- intersect(colnames(counts_raw), sample_info$sample_id)

counts_matrix <- counts_raw[, common_samples]
sample_info <- sample_info %>% filter(sample_id %in% common_samples)

sample_info <- sample_info[match(colnames(counts_matrix), sample_info$sample_id), ]

colData <- data.frame(
  row.names = sample_info$sample_id,
  condition = sample_info$condition
)

counts_matrix <- round(as.matrix(counts_matrix))

dds <- DESeqDataSetFromMatrix(
  countData = counts_matrix,
  colData = colData,
  design = ~ condition
)

keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]

dds <- DESeq(dds)
res <- results(dds)

write.csv(as.data.frame(res), file = "GSE294225_deseq2_results.csv")

vsd <- vst(dds, blind = FALSE)

ml_df <- as.data.frame(t(assay(vsd)))
ml_df$condition <- colData$condition

write.csv(ml_df, file = "GSE294225_ml_ready_data.csv")