#!/usr/bin/env Rscript
###########################
### Read cluster result ###
###########################

list.of.packages <- c('mclust', "optparse", "Sys.time", 'umap', 'ggplot2')
loading = suppressWarnings(suppressMessages(lapply(list.of.packages, require, character.only = TRUE)))

param_index <-readLines("stdin")

# param_index <- scan(file="stdin", quiet=TRUE)


setwd("~/Dropbox/DTU/SP/cluster-stability/flow/")
source('functions.R')
load('parameter_grid.RData')
datafile <- "~/Documents/FCS_data/data_transformed.Rdata"
load(datafile, envir = parent.frame(), verbose = FALSE)
n_stable <- 1000

#df <- data.frame('patient','seed', 'size', 'nclust','time_spent','meanARI', 'meanTrueARI')
results <- setNames(data.frame(matrix(ncol = 7, nrow = 0)), c('patient', 'sampleSize', 'seed', 'nclust', 'time_spent', 'meanARI', 'trueLabelARI'))
param_index <- strsplit(param_index, ' ')[[1]][c(TRUE, FALSE)]
for(par_ind in param_index){
  par_ind <- as.integer(par_ind)
  patient <- parameter_grid$patient[par_ind]
  size <- parameter_grid$size[par_ind]
  seed <- parameter_grid$seed[par_ind]
  nclust <- parameter_grid$nclust[par_ind]
  version <- 1
  load(paste0('results/flowsom', version, '/flowsom', version, '_', patient, '_',seed, '_',
                size, '_', nclust, '.RData'))
  
  if(patient == "all"){data <- expr_trans
  } else{data <- expr_trans[expr_trans$sample==patient, ]}
  
  sample_1k <- getSample(data[, lineage_channels], n = n_stable, seed = seed)
  sample_1k_ids <- getIDs(sample_1k)
  true_labs <- expr_trans[sample_1k_ids, ]$subpopulation
  
  num_labs <- 0
  sum_rand <- 0
  for(lab in labels){
    #print(length(unique(lab)))
    #print(adjustedRandIndex(true_labs, lab))
    sum_rand <- sum_rand + adjustedRandIndex(true_labs, lab)
    num_labs <- num_labs + 1
  }
  meanTrueARI <- sum_rand/num_labs
  
  fileResult <- c(toString(patient),seed,size,nclust,toString(params$time_spent), mean(meanARI(labels)), meanTrueARI)
  results[nrow(results)+1, ] <- fileResult
  
  print(mean(meanARI(labels)))
  
}
#save(results, file='flow1Result.RData')
stop()


# Data analysis
load('flow1Result.RData')

# patient <- parameter_grid$patient[param_index]
# size <- parameter_grid$size[param_index]
# seed <- parameter_grid$seed[param_index]
# nclust <- parameter_grid$nclust[param_index]

patient <- '001'
size <- -1
seed <- 42
nclust <- 20

version <- 1
load(paste0('results/flowsom', version, '/flowsom', version, '_', patient, '_',seed, '_',
            size, '_', nclust, '.RData'))

print(mean(meanARI(labels)))



# Load data
datafile <- "~/Documents/FCS_data/data_transformed.Rdata"
load(datafile, envir = parent.frame(), verbose = FALSE)
if(patient == "all"){data <- expr_trans
} else{data <- expr_trans[expr_trans$sample==patient, ]}

sample_1k <- getSample(data[, lineage_channels], n = n_stable, seed = seed)
sample_1k_ids <- getIDs(sample_1k)
true_labs <- expr_trans[sample_1k_ids, ]$subpopulation

num_labs <- 0
sum_rand <- 0
for(lab in labels){
  #print(length(unique(lab)))
  print(ARI(true_labs, lab))
  sum_rand <- sum_rand + ARI(true_labs, lab)
  num_labs <- num_labs + 1
}
print(sum_rand/num_labs)
