####################################
### FlowMeans clustering Wrapper ###
####################################

# Load packages
list.of.packages <- c("flowCore", "flowMeans", 'mclust', 'optparse', "Sys.time")
loading = suppressWarnings(suppressMessages(lapply(list.of.packages, require, character.only = TRUE)))
start_time <- Sys.time()

option_list = list(
  make_option(c("-p", "--params"), type="integer", default=1,
              help="Parameter index to evaulate on", metavar="integer")
)

# Parse command-line arguments
opt = parse_args(OptionParser(option_list=option_list))



# Load data file and functions
datafile <- "../data_transformed.Rdata"
source("functions.R")

# Load data
load(datafile, envir = parent.frame(), verbose = FALSE)

# Initialize parameters
#lineage_channels <- c("CD57", "CD19", "CD4", "CD8", "IgD", "CD11c", "CD16", "CD3", "CD38",
#                      "CD27", "CD14", "CXCR5", "CCR7", "CD45RA", "CD20", "CD127", "CD33",
#                      "CD28", "CD161", "TCRgd", "CD123", "CD56", "HLADR", "CD25")            # Original
lineage_channels <- c("CD4", "CD8", "IgD", "CD16", "CD3", "CD38", "CCR7",
                      "CD45RA", "CD161", "TCRgd", "CD123", "CD56", "CD25")          # High correlation are removed

n_stable <- 1000
reps     <- 10       # Has to be >1 to calculate Rand Index

# Set variable parameters to run through
patients <- c(unique(expr_trans$sample), "all")
seeds    <- c(42, 43, 44, 45, 46)
sizes    <- c(10000, 15000, 20000, 50000, 100000)
nclusts  <- c(15, 20, 21, 25, 30)

parameter_grid <- expand.grid(patients, sizes, seeds, nclusts)[opt$params,]
patient <- toString(parameter_grid[[1]])
size <- parameter_grid[[2]]
seed <- parameter_grid[[3]]
nclust <- parameter_grid[[4]]

# Initial columns for output file:
columns <- paste("patient", "seed", "size", "reps", "nclust", "ARI", "Running Time", sep = ',')


if(patient == "all"){data <- expr_trans
} else{data <- expr_trans[expr_trans$sample==patient, ]}


file <- 'results/output_flowmeans.csv'
if(!file.exists(file)){
  cat('Lineage channels:', lineage_channels, "\n", file=file, sep=',', append=TRUE)
  cat(columns,  file=file, sep="\n", append=TRUE)
}

# Run FlowMeans
labels <- repFlowMeans(data, marker_cols = lineage_channels, nclust = nclust, seed = seed, n = size, n_stable = n_stable, reps = reps)
end_time <- Sys.time()
time_spent = end_time - start_time
time_spent = paste(signif(time_spent[[1]], digits = 5), attr(time_spent, 'units'))
cat(c(patient, seed, size, reps, nclust, meanARI(labels), time_spent), file=file, sep="\n", append=TRUE)
