# Install CRAN packages
install.packages(c("Seurat", "tidyverse", "Matrix", "scales", "cowplot", "RCurl"))

# Install Bioconductor manager if not already installed
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Install Bioconductor packages
BiocManager::install("SingleCellExperiment")

# Load libraries
library(SingleCellExperiment)
library(Seurat)
library(tidyverse)
library(Matrix)
library(scales)
library(cowplot)
library(RCurl)

# How to read in 10X data for a single sample (output is a sparse matrix)
ctrl_counts <- Read10X(data.dir = "data/ctrl_raw_feature_bc_matrix")

# Turn count matrix into a Seurat object (output is a Seurat object)
ctrl <- CreateSeuratObject(counts = ctrl_counts,
                           min.features = 100)

head(ctrl@meta.data)

for (file in c("ctrl_raw_feature_bc_matrix", "stim_raw_feature_bc_matrix")){
  seurat_data <- Read10X(data.dir = paste0("data/", file))
  seurat_obj <- CreateSeuratObject(counts = seurat_data, 
                                   min.features = 100, 
                                   project = file)
  assign(file, seurat_obj)
}

head(ctrl_raw_feature_bc_matrix@meta.data)
head(stim_raw_feature_bc_matrix@meta.data)

# Create a merged Seurat object
merged_seurat <- merge(x = ctrl_raw_feature_bc_matrix, 
                       y = stim_raw_feature_bc_matrix, 
                       add.cell.id = c("ctrl", "stim"))

# Check that the merged object has the appropriate sample-specific prefixes
head(merged_seurat@meta.data)
tail(merged_seurat@meta.data)

# Assuming 'ctrl' is your Seurat object created from ctrl_raw_feature_bc_matrix
cell_info <- ctrl@meta.data["AAACATACATTTCC-1", c("nFeature_RNA", "nCount_RNA")]
print(cell_info)


# Create a list to store Seurat objects, if not already done
seurat_objects <- list()

# Assuming you have the file names and corresponding Seurat objects
# Let's assume 'ctrl_raw_feature_bc_matrix' and 'stim_raw_feature_bc_matrix' are already loaded and named appropriately
seurat_objects[["ctrl"]] <- ctrl_raw_feature_bc_matrix
seurat_objects[["stim"]] <- stim_raw_feature_bc_matrix

# Merging the Seurat objects
merged_seurat <- merge(x = seurat_objects[["ctrl"]], y = seurat_objects[["stim"]], add.cell.ids = c("ctrl", "stim"))

# Check the first and last few rows of the metadata to confirm merge
print(head(merged_seurat@meta.data))
print(tail(merged_seurat@meta.data))

View(merged_seurat@meta.data)

