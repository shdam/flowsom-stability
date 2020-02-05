########################################
### FlowSOM dependencies ###
########################################

# Install packages:
install.packages(c("BiocManager","aricode", "ggplot2" , "graphics", "devtools", "mclust", "Sys.time", "umap"))
library(BiocManager)
BiocManager::install(c("flowCore", "FlowSOM", "FlowMeans"))