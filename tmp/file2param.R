#!/usr/bin/env Rscript
#####################
### File to param ###
#####################

library('optparse')

option_list = list(
  make_option(c("-f", "--filename"), type="character",
              help="File to convert to param", default = NULL)
)

# Parse command-line arguments
opt = parse_args(OptionParser(option_list=option_list))


if (is.null(opt$filename)) {
  opt$filename <- readLines("stdin")
}
setwd("~/Dropbox/DTU/SP/cluster-stability/flow/")
load('parameter_grid.RData')
for(filename in strsplit(opt$filename, ' ')[[1]]){
  filename <- gsub('.RData', '', filename)
  filename <- strsplit(filename, '_')[[1]]
  patient <- filename[2]
  size <- filename[4]
  seed <- filename[3]
  nclust <- filename[5]
  
  param_index <- which(parameter_grid$patient == patient & parameter_grid$size == size & parameter_grid$seed == seed & parameter_grid$nclust == nclust)
  #cat(param_index, ' ')
  # Find which parameter combination is lacking from the parameter grid
  parameter_grid <- parameter_grid[-param_index, ]
  
}

print(parameter_grid)
  
