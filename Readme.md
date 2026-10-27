**Transcriptomic Biomarker Discovery in Rheumatoid Arthritis (GSE294225)**  
Pipeline to identify peripheral blood mononuclear cell (PBMC) transcriptomic signatures distinguishing Healthy Controls from Rheumatoid Arthritis (RA) patients.  
**🚀 Project Overview**  
- **Dataset:** NCBI GEO Series `GSE294225` (PBMC RNA-seq profiling)  
- **Sample Size:** 24 clinical samples  
- **Methodology:** DESeq2 differential expression analysis coupled with a tuned Random Forest machine learning classifier under a rigorous 5-fold cross-validation framework.  
- **Performance: 92% Cross-Validated Accuracy** (Kappa: 0.832)  
  
---  
**📊 Pipeline Architecture**  
1. **Data Acquisition & Preprocessing (`01_data_loading.R`)**: Automated retrieval via `GEOquery`, sample metadata parsing, string matching reconciliation (`gsub`), and count-matrix integer formatting for DESeq2 compatibility.  
2. **Differential Expression Analysis (`02_deseq2_deg.R`)**: Normalization, variance stabilizing transformation (VST), and identification of statistically significant differentially expressed genes (\`padj < 0.05\`).  
3. **Machine Learning Classification (`03_random_forest.R`)**: Matrix-based interfaces to prevent formula memory overflows, followed by 5-fold cross-validation\[cite: 5\] to mitigate overfitting and "split luck."  
  
---  
**🔬 Key Biological Findings & Biomarkers**  
Feature importance ranking (% increase in classification error) identified key immunological and metabolic drivers:  
- **`PTGS2` (COX-2):** Classic pro-inflammatory mediator heavily implicated in synovial inflammation and joint pathology.  
- **`GPR84`:** Upregulated free fatty acid receptor indexing activated myeloid/innate immune cells in systemic circulation.  
- **`GOT2`:** Reflects metabolic reprogramming (amino acid metabolism/shuttling) in activated immune cells.  
  
---  
**📂 Repository Structure**  
- `scripts/`: Modular R scripts executing data cleaning, DESeq2 modeling, and ML classification.  
- `results/`: Tabulated differential expression statistics and Random Forest feature importance metrics.  
- `figures/`: High-resolution plots including exploratory PCA and the top predictive biomarker ranking chart.  
  
---  
**🛠️ Getting Started & Dependencies**  
**Prerequisites**  
Ensure you have **R** (>= 4.2) installed along with the following Bioconductor and CRAN packages:  
```  
if (!requireNamespace("BiocManager", quietly = TRUE))  
     install.packages("BiocManager")  
   
 BiocManager::install(c("GEOquery", "DESeq2"))  
 install.packages(c("randomForest", "caret", "dplyr", "ggplot2"))  
   
```  
