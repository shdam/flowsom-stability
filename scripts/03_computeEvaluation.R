##################################
### Save cluster result to file ##
##################################
# Usage:
# echo ../results/02_flowsom1/* | Rscript 03_computeEvaluation.R -f ../results/03_flow1Result.RData

list.of.packages <- c('optparse', 'aricode')
loading = suppressWarnings(suppressMessages(lapply(list.of.packages, require, character.only = TRUE)))

option_list = list(
  make_option(c("-f", "--filename"), type="character",
              help="File to output results to", default = '../results/03_flow1Result.RData')
)

# Parse command-line arguments
opt = parse_args(OptionParser(option_list=option_list))

filename <- readLines("stdin")

source('functions.R')


n_stable <- 1000
results <- setNames(data.frame(matrix(ncol = 7, nrow = 0)), c('patient', 'seed', 'sampleSize', 'nclust', 'time_spent','ARI','AMI'))# , 'trueLabelARI', 'trueLabelAMI')
filenames <- strsplit(filename, ' ')[[1]]

for(filename in filenames){
  load(filename)
  
  patient <- params$patient
  size <- params$size
  seed <- params$seed
  nclust <- params$nclust
  
  
  ##### Evaluation of the result compared to the manual gating - commented out, as it was deemed irrelevant
  # if(patient == "all"){data <- expr_trans
  # } else{data <- expr_trans[expr_trans$sample==patient, ]}
  # 
  # sample_1k <- getSample(data[, lineage_channels], n = n_stable, seed = seed)
  # sample_1k_ids <- getIDs(sample_1k)
  # true_labs <- factor(expr_trans[sample_1k_ids, ]$subpopulation)
  # 
  # num_labs <- 0
  # sum_ari <- 0
  # sum_ami <- 0
  # for(lab in labels){
  #   #print(length(unique(lab)))
  #   #print(adjustedRandIndex(true_labs, lab))
  #   sum_ari <- sum_ari + ARI(true_labs, lab)
  #   sum_ami <- sum_ami + AMI(true_labs, lab)
  #   num_labs <- num_labs + 1
  # }
  # meanTrueARI <- sum_ari/num_labs
  # meanTrueAMI <- sum_ami/num_labs
  
  fileResult <- c(toString(patient), seed, size, nclust, toString(params$time_spent), sapply(meanClustComp(labels), mean)[c('ARI','AMI')]) # , meanTrueARI, meanTrueAMI)
  results[nrow(results)+1, ] <- fileResult
  
}

save(results, file=opt$filename)
print('Done!\n')



# Calculate hours spent on computerome:
# qstat -t | grep 26145543 | grep C | awk '{print $4}' | tr : ' ' | awk '{sumh += $1; summ += $2; sums += $3/60} END {print sumh+(summ+sums)/60  " hrs"}'
