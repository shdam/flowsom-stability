##########################
### FlowSOM clustering ###
##########################

# Load packages
list.of.packages <- c("flowCore", "FlowSOM", "optparse", "Sys.time")
loading = suppressWarnings(suppressMessages(lapply(list.of.packages, require, character.only = TRUE)))
start_time <- Sys.time()

option_list = list(
  make_option(c("-p", "--params"), type="integer", default=1,
              help="Parameter index to evaulate on", metavar="integer")
)

# Parse command-line arguments
opt = parse_args(OptionParser(option_list=option_list))


# Load data file and functions
datafile <- "../data/data_transformed.Rdata"
parameterfile <- '../data/01_parameter_grid.RData'
source("functions.R")

# Load data
load(datafile, envir = parent.frame(), verbose = FALSE)
load(parameterfile)

# Initialize parameters
lineage_channels <- c("CD57", "CD19", "CD4", "CD8", "IgD", "CD11c", "CD16", "CD3", "CD38",
                      "CD27", "CD14", "CXCR5", "CCR7", "CD45RA", "CD20", "CD127", "CD33",
                      "CD28", "CD161", "TCRgd", "CD123", "CD56", "HLADR", "CD25")
n_stable <- 1000
reps     <- 10       # Has to be >1 to calculate Rand Index

patient <- parameter_grid$patient[opt$params]
size <- parameter_grid$size[opt$params]
seed <- parameter_grid$seed[opt$params]
nclust <- parameter_grid$nclust[opt$params]

# Sort input data based on patient
if(patient == "all"){data <- expr_trans
} else{data <- expr_trans[expr_trans$sample==patient, ]}

# Run FlowSOM
labels <- repFlowSOM(data, marker_cols = lineage_channels, nclust = nclust, seed = seed, n = size, n_stable = n_stable, reps = reps)
end_time <- Sys.time()
time_spent = end_time - start_time
time_spent = paste(signif(time_spent[[1]], digits = 5), attr(time_spent, 'units'))
params = data.frame(patient, seed, size, reps, nclust, time_spent)
# Save result to file:
save(lineage_channels, params, labels, file=paste0('../results/02_flowsom1/flowsom1_', patient, '_', seed, '_',
                                                   size, '_', nclust, '.RData'))



