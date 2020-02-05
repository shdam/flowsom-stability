###############################
### Cluster result analysis ###
###############################

list.of.packages <- c('optparse','graphics', 'aricode','ggplot2')
loading = suppressWarnings(suppressMessages(lapply(list.of.packages, require, character.only = TRUE)))


source('functions.R')
datafile <- "../data/data_transformed.Rdata" #'/home/shdam/Documents/FCS_data/data_transformed.Rdata'
load(datafile, envir = parent.frame(), verbose = FALSE)

n_stable <- 1000
patients <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")

system('mkdir -p ../results/04_figs')
system('mkdir -p ../results/04_figs/full')



###############################
### Full dataset analysis

## Population
ggplot(expr_trans, aes(x=sample, fill = population)) +
  geom_bar() +
  labs(x = 'Patient', y = 'Count', title = 'Cell type distribution for each patient', fill = 'Cell type')
ggsave('../results/04_figs/population.png', scale = 1.2)

for(version in 1:2){
  results <- loadResult(version)
  ## nclust vs samplesize - ARI
  ggplot(results, aes(x=nclust, y=ARI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - Adjusted Rand Index')) +
    labs(x='Number of clusters', y='Adjusted Rand Index') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ari_nc_ss.png'), scale=2)
  ## nclust vs samplesize - AMI
  ggplot(results, aes(x=nclust, y=AMI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v', version, ' - Adjusted Mutual Information')) +
    labs(x='Number of clusters', y='Adjusted Mutual Information') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ami_nc_ss.png'), scale=2)
  ## patients vs samplesize - ARI
  ggplot(results, aes(x=patient, y=ARI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - comparing patients across sample sizes')) +
    labs(x='Patient', y='Adjusted Rand Index') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ari_pat_ss.png'), scale=2)
  ## patients vs samplesize - AMI
  ggplot(results, aes(x=patient, y=AMI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - comparing patients across sample sizes')) +
    labs(x='Patient', y='Adjusted Mutual Information') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ami_pat_ss.png'), scale=2)
  ## samplesize vs patients - ARI
  ggplot(results, aes(x=sampleSize, y=ARI, fill=patient)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ patient, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - comparing patients across sample sizes')) +
    labs(x='Patient', y='Adjusted Rand Index') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ari_ss_pat.png'), scale=2)
  ## samplesize vs patients - AMI
  ggplot(results, aes(x=sampleSize, y=AMI, fill=patient)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21,position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ patient, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - comparing patients across sample sizes')) +
    labs(x='Patient', y='Adjusted Mutual Information') +
    coord_cartesian(ylim = c(0.7, 1))
  ggsave(paste0('../results/04_figs/full/flowsom',version,'_ami_ss_pat.png'), scale=2)
  
  
    ### Measure comparisons FULL:
  ## Compare number of clusters across all patients:
  sumARI <- summarySE(results, measurevar="ARI", groupvars=c("nclust"))
  sumAMI <- summarySE(results, measurevar="AMI", groupvars=c("nclust"))
  su <- cbind(sumARI, sumAMI)
  names(su) <- c('nclust1', 'N1','ARI','sd1','seARI','ci1','nclust2', 'N2','AMI','sd2','seAMI','ci2')
  ggplot(su, aes(x=nclust1)) + 
    geom_line(aes(y = ARI, colour = "ARI", group=1)) +
    geom_errorbar(aes(ymin=ARI-seARI, ymax=ARI+seARI), width=.1) +
    geom_line(aes(y = AMI, colour = "AMI", group=1)) +
    geom_errorbar(aes(ymin=AMI-seAMI, ymax=AMI+seAMI), width=.1) +
    #
    geom_point(aes(y = ARI, colour='ARI')) +
    geom_point(aes(y = AMI, colour='AMI')) +
    ggtitle(paste0('Flowsom v',version,' - Measure comparison (Number of clusters)')) +
    labs(y='Score value', x='Number of clusters', colour='Measure')
  ggsave(paste0('../results/04_figs/full/comp_mes_nc_f',version,'.png'))
  
  ## Compare sample size across all patients:
  sumARI <- summarySE(results, measurevar="ARI", groupvars=c("sampleSize"))
  sumAMI <- summarySE(results, measurevar="AMI", groupvars=c("sampleSize"))
  su <- cbind(sumARI, sumAMI)
  names(su) <- c('sampleSize1', 'N1','ARI','sd1','seARI','ci1','sampleSize2', 'N2','AMI','sd2','seAMI','ci2')
  ggplot(su, aes(x=sampleSize1)) + 
    geom_line(aes(y = ARI, colour = "ARI", group=1)) +
    geom_errorbar(aes(ymin=ARI-seARI, ymax=ARI+seARI), width=.1) +
    geom_line(aes(y = AMI, colour = "AMI", group=1)) +
    geom_errorbar(aes(ymin=AMI-seAMI, ymax=AMI+seAMI), width=.1) +
    #
    geom_point(aes(y = ARI, colour='ARI')) +
    geom_point(aes(y = AMI, colour='AMI')) +
    ggtitle(paste0('Flowsom v',version,' - Measure comparison (Sample size)')) +
    labs(y='Score value', x='Sample size', colour='Measure')
  ggsave(paste0('../results/04_figs/full/comp_mes_ss_f',version,'.png'))
  
  
  ## Compare samplesizes across all patients - ARI:
  summ <- summarySE(results, measurevar="ARI", groupvars=c("nclust", 'sampleSize'))
  # Standard error of the mean
  pd <- position_dodge(0.1)
  ggplot(summ, aes(x=nclust, y=ARI, colour=sampleSize)) + 
    geom_errorbar(aes(ymin=ARI-se, ymax=ARI+se), width=.1, position=pd) +
    geom_line(aes(group=sampleSize),size=1, position=pd) +
    ggtitle(paste0('Flowsom v',version,' - Mean Adjusted Rand Index')) +
    geom_point(position=pd) +
    labs(y='Index value', x = 'Number of clusters', colour='Sample size')
  ggsave(paste0('../results/04_figs/full/ARI_f',version,'.png'))
  
  ## Compare samplesizes across all patients - AMI:
  summ <- summarySE(results, measurevar="AMI", groupvars=c("nclust", 'sampleSize'))
  # Standard error of the mean
  pd <- position_dodge(0.1)
  ggplot(summ, aes(x=nclust, y=AMI, colour=sampleSize)) + 
    geom_errorbar(aes(ymin=AMI-se, ymax=AMI+se), width=.1, position=pd) +
    geom_line(aes(group=sampleSize),size=1, position=pd) +
    ggtitle(paste0('Flowsom v',version,' - Mean Adjusted Mutual Information')) +
    geom_point(position=pd) +
    labs(y='Index value', x = 'Number of clusters', colour='Sample size')
  ggsave(paste0('../results/04_figs/full/AMI_f',version,'.png'))
}




###########################################
#### Patient specific analysis - Plots not included in report

### ggplots


for(version in 1:2){
results <- loadResult(version)

system(paste0('mkdir -p ../results/04_figs/meanARI_f',version))
system(paste0('mkdir -p ../results/04_figs/meanAMI_f',version))
system(paste0('mkdir -p ../results/04_figs/comp_mes_f',version))
system(paste0('mkdir -p ../results/04_figs/ARI_nclust_f',version))
system(paste0('mkdir -p ../results/04_figs/AMI_nclust_f',version))
system(paste0('mkdir -p ../results/04_figs/ARI_seed_f',version))
system(paste0('mkdir -p ../results/04_figs/AMI_seed_f',version))

## Compare sample sizes - TrueARI
# for(p in 1:10){
#   patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
#   
#   summ <- summarySE(results[results$patient==patient, ], measurevar="trueLabelARI", groupvars=c("nclust", 'sampleSize'))
#   summ <- summ[-length(summ[,1]),]
#   
#   # Standard error of the mean
#   pd <- position_dodge(0.1)
#   ggplot(summ, aes(x=nclust, y=trueLabelARI, colour=sampleSize)) + 
#     geom_errorbar(aes(ymin=trueLabelARI-se, ymax=trueLabelARI+se), width=.1, position=pd) +
#     geom_line(aes(group=sampleSize),size=1, position=pd) +
#     ggtitle(paste0('Flowsom v',version,' - Patient "', patient, '": True Label Mean Adjusted Rand Index')) +
#     geom_point(position=pd) +
#     labs(y='Index value', x = 'Number of clusters')
#   ggsave(paste0('results/figs/trueARI_f',version,'/trueARI_f',version,'_', patient, '.png'))
# }

## Compare sample sizes - ARI


for(p in 1:10){
  patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
  
  summ <- summarySE(results[results$patient==patient, ], measurevar="ARI", groupvars=c("nclust", 'sampleSize'))
  summ <- summ[-length(summ[,1]),]
  # Standard error of the mean
  pd <- position_dodge(0.1)
  ggplot(summ, aes(x=nclust, y=ARI, colour=sampleSize)) + 
    geom_errorbar(aes(ymin=ARI-se, ymax=ARI+se), width=.1, position=pd) +
    geom_line(aes(group=sampleSize),size=1, position=pd) +
    ggtitle(paste0('Flowsom v',version,' - Patient "',patient,'": Mean Adjusted Rand Index')) +
    geom_point(position=pd) +
    labs(y='Index value', x = 'Number of clusters')
  ggsave(paste0('../results/04_figs/meanARI_f',version,'/meanARI_f',version,'_',patient,'.png'))
}

## Compare sample sizes - AMI
for(p in 1:10){
  patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
  
  summ <- summarySE(results[results$patient==patient, ], measurevar="AMI", groupvars=c("nclust", 'sampleSize'))
  summ <- summ[-length(summ[,1]),]
  # Standard error of the mean
  pd <- position_dodge(0.1)
  ggplot(summ, aes(x=nclust, y=AMI, colour=sampleSize)) + 
    geom_errorbar(aes(ymin=AMI-se, ymax=AMI+se), width=.1, position=pd) +
    geom_line(aes(group=sampleSize),size=1, position=pd) +
    ggtitle(paste0('Flowsom v',version,' - Patient "',patient,'": Mean Adjusted Mutual Information')) +
    geom_point(position=pd) +
    labs(y='Index value', x = 'Number of clusters')
  ggsave(paste0('../results/04_figs/meanAMI_f',version,'/meanAMI_f',version,'_',patient,'.png'))
}

################################
## Measure comparison - ARI, AMI (based on number of clusters)

for(p in 1:10){
patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]

sumARI <- summarySE(results[results$patient==patient, ], measurevar="ARI", groupvars=c("nclust"))
sumARI <- sumARI[-length(sumARI[,1]),]

sumAMI <- summarySE(results[results$patient==patient, ], measurevar="AMI", groupvars=c("nclust"))
sumAMI <- sumAMI[-length(sumAMI[,1]),]

# sumTrueARI <- summarySE(results[results$patient==patient, ], measurevar="trueLabelARI", groupvars=c("nclust"))
# sumTrueARI <- sumTrueARI[-length(sumTrueARI[,1]),]

# sumTrueAMI <- summarySE(results[results$patient==patient, ], measurevar="trueLabelAMI", groupvars=c("nclust"))
# sumTrueAMI <- sumTrueAMI[-length(sumTrueAMI[,1]),]


su <- cbind(sumARI, sumAMI)#, sumTrueARI, sumTrueARI))
names(su) <- c('nclust1', 'N1','ARI','sd1','seARI','ci1','nclust2', 'N2','AMI','sd2','seAMI','ci2')
               #'nclust3', 'N3','trueARI','sd3','seTARI','ci3',,'nclust4', 'N4','trueAMI','sd4','seTAMI','ci4','nclust4'
ggplot(su, aes(x=nclust1)) + 
  geom_line(aes(y = ARI, colour = "ARI", group=1)) +
  geom_errorbar(aes(ymin=ARI-seARI, ymax=ARI+seARI), width=.1) +
  geom_line(aes(y = AMI, colour = "AMI", group=1)) +
  geom_errorbar(aes(ymin=AMI-seAMI, ymax=AMI+seAMI), width=.1) +
  # geom_line(aes(y = trueARI, colour = "trueARI", group=1)) +
  # geom_errorbar(aes(ymin=trueARI-seTARI, ymax=trueARI+seTARI), width=.1) +
  # geom_line(aes(y = trueAMI, colour = "trueAMI", group=1)) +
  # geom_errorbar(aes(ymin=trueAMI-seTAMI, ymax=trueAMI+seTAMI), width=.1) +
  #
  # geom_point(aes(y = trueARI, colour='trueARI')) +
  # geom_point(aes(y = trueAMI, colour='trueAMI')) +
  geom_point(aes(y = ARI, colour='ARI')) +
  geom_point(aes(y = AMI, colour='AMI')) +
  ggtitle(paste0('Flowsom v',version,' - Patient "', patient, '": Measure comparison')) +
  ylab('Score value') +
  xlab('Number of clusters')
ggsave(paste0('../results/04_figs/comp_mes_f',version,'/comp_mes_nc_f',version,'_',patient,'.png'))
}


#######################################################
## Measure comparison - ARI, AMI (based on sample size)

for(p in 1:10){
  patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
  
  sumARI <- summarySE(results[results$patient==patient, ], measurevar="ARI", groupvars=c("sampleSize"))
  sumARI <- sumARI[-length(sumARI[,1]),]

  
  sumAMI <- summarySE(results[results$patient==patient, ], measurevar="AMI", groupvars=c("sampleSize"))
  sumAMI <- sumAMI[-length(sumAMI[,1]),]
  
  # sumTrueARI <- summarySE(results[results$patient==patient, ], measurevar="trueLabelARI", groupvars=c("sampleSize"))
  # sumTrueARI <- sumTrueARI[-length(sumTrueARI[,1]),]
  # 
  # sumTrueAMI <- summarySE(results[results$patient==patient, ], measurevar="trueLabelAMI", groupvars=c("sampleSize"))
  # sumTrueAMI <- sumTrueAMI[-length(sumTrueAMI[,1]),]
  
  
  su <- cbind(sumARI, sumAMI)#, sumTrueARI, sumTrueARI))
  names(su) <- c('nclust1', 'N1','ARI','sd1','seARI','ci1','nclust2', 'N2','AMI','sd2','seAMI','ci2')
  #'nclust3', 'N3','trueARI','sd3','seTARI','ci3',,'nclust4', 'N4','trueAMI','sd4','seTAMI','ci4')#,'nclust4')
  
  ggplot(su, aes(x=nclust1)) + 
    geom_line(aes(y = ARI, colour = "ARI", group=1)) +
    geom_errorbar(aes(ymin=ARI-seARI, ymax=ARI+seARI), width=.1) +
    geom_line(aes(y = AMI, colour = "AMI", group=1)) +
    geom_errorbar(aes(ymin=AMI-seAMI, ymax=AMI+seAMI), width=.1) +
    # geom_line(aes(y = trueARI, colour = "trueARI", group=1)) +
    # geom_errorbar(aes(ymin=trueARI-seTARI, ymax=trueARI+seTARI), width=.1) +
    # geom_line(aes(y = trueAMI, colour = "trueAMI", group=1)) +
    # geom_errorbar(aes(ymin=trueAMI-seTAMI, ymax=trueAMI+seTAMI), width=.1) +
    #
    geom_point(aes(y = ARI, colour='ARI')) +
    geom_point(aes(y = AMI, colour='AMI')) +
    # geom_point(aes(y = trueARI, colour='trueARI')) +
    # geom_point(aes(y = trueAMI, colour='trueAMI')) +
    ggtitle(paste0('Flowsom v',version,' - Patient "', patient, '": Measure comparison')) +
    ylab('Score value') +
    xlab('Sample size')
  ggsave(paste0('../results/04_figs/comp_mes_f',version,'/comp_mes_ss_f',version,'_',patient,'.png'))
  
}

}

### Adjusted rand index varying over number of clusters (Patient specific)

for(version in 1:2){
results <- loadResult(version)

## nclust trueLabel
# for (p in 1:10){
#   ggplot(results[results$patient==patients[p],], aes(x=nclust, y=trueLabelARI, fill=sampleSize)) +
#     geom_boxplot(outlier.size = 0) +
#     geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
#     facet_wrap( ~ sampleSize, scales='free') +
#     ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted rand index varying over number of clusters')) +
#     labs(x='Number of clusters', y='Adjusted Rand Index (True Label)')
#   ggsave(paste0('results/figs/trueARI_nclust_f',version,'/trueARI_nclust_f',version,'_', patients[p], '.png'), scale=2)
# }

## seed trueLabel
# for (p in 1:10){
#   ggplot(results[results$patient==patients[p],], aes(x=seed, y=trueLabelARI, fill=sampleSize)) +
#     geom_boxplot(outlier.size = 0) +
#     geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
#     facet_wrap( ~ sampleSize, scales='free') +
#     ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted rand index varying over seed')) +
#     labs(x='Seed', y='Adjusted Rand Index (True Label)')
#   ggsave(paste0('results/figs/trueARI_seed_f',version,'/trueARI_seed_f',version,'_',patients[p],'.png'), scale=2)
# }

## nclust meanARI
for (p in 1:10){
  ggplot(results[results$patient==patients[p],], aes(x=nclust, y=ARI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted rand index varying over number of clusters')) +
    labs(x='Number of clusters', y='Adjusted Rand Index (Mean)')
  ggsave(paste0('../results/04_figs/ARI_nclust_f',version,'/ARI_nclust_f',version,'_',patients[p],'.png'), scale=2)
}

## nclust meanAMI
for (p in 1:10){
  ggplot(results[results$patient==patients[p],], aes(x=nclust, y=AMI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted mutual information varying over number of clusters')) +
    labs(x='Number of clusters', y='Adjusted Mutual Information (Mean)')
  ggsave(paste0('../results/04_figs/AMI_nclust_f',version,'/AMI_nclust_f',version,'_',patients[p],'.png'), scale=2)
}

## seed meanARI
for (p in 1:10){
  ggplot(results[results$patient==patients[p],], aes(x=seed, y=ARI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted rand index varying over seed')) +
    labs(x='Seed', y='Adjusted Rand Index (True Label)')
  ggsave(paste0('../results/04_figs/ARI_seed_f',version,'/ARI_seed_f',version,'_',patients[p],'.png'), scale=2)
}

## seed meanAMI
for (p in 1:10){
  ggplot(results[results$patient==patients[p],], aes(x=seed, y=AMI, fill=sampleSize)) +
    geom_boxplot(outlier.size = 0) +
    geom_point(pch=21, position=position_jitterdodge(), size=0.5) +
    facet_wrap( ~ sampleSize, scales='free') +
    ggtitle(paste0('Flowsom v',version,' - Patient "', patients[p], '": Adjusted mutual information varying over seed')) +
    labs(x='Seed', y='Adjusted Mutual Information (True Label)')
  ggsave(paste0('../results/04_figs/AMI_seed_f',version,'/AMI_seed_f',version,'_',patients[p],'.png'), scale=2)
}
}


# Population
# for(p in 1:9){
#   patient <- patients[p]
#   ggplot(expr_trans[expr_trans$sample==patient,], aes(subpopulation, fill=population)) +
#     geom_bar() +
#     coord_flip()
# }

######################################
### simple boxplots (plots not saved)
stop('Done!')
## Mean adjusted rand index - Boxplot

sizes <- c('10000','20000','50000','100000','All')
par(mfrow=c(1,5))
patient <- 'Pat03'
for( size in sizes){
  res <- results[results$sampleSize==size & results$patient==patient,]
  boxplot(as.numeric(res$AMI), main=size, ylim = c(0.7,1))
  
}
mtext(paste0('Flowsom1 Mean Adjusted Rand Index (',patient,')'), side = 3, line = -30, outer = TRUE)
#mean(as.numeric(sapply(pat_001$time_spent, function(x){strsplit(x, ' ')[[1]][1]})))


## Varying sample size for a specific case - fluctuation in rand index:
for(p in 1:10){
  patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
  sizes <- c('10000','20000','50000','1e+05','-1')
  seed <- '42'
  nclust <- '21'
  version <- 2
  par(mfrow=c(1,5))
  for( s in sizes){
    load(paste0('../results/02_flowsom', version, '/flowsom', version, '_', patient, '_', seed, '_',
                s, '_', nclust, '.RData'))
    
    l <- meanClustComp(labels)$ARI
    pat_001 <- results[results$sampleSize==s,]
    boxplot(l, main = s, ylim=c(0.6,1), ylab = 'Adjusted Rand Index')
  }
  mtext(paste0('flowsom', version, '_', patient, '_', seed, '_',
               nclust), side = 3, line = -30, outer = TRUE)
}


## See for a specific case:
result_number <- 3500

patient <- results$patient[result_number]
size <- results$sampleSize[result_number]
seed <- results$seed[result_number]
nclust <- results$nclust[result_number]
version <- 2
load(paste0('../results/02_flowsom', version, '/flowsom', version, '_', patient, '_', seed, '_',
            size, '_', nclust, '.RData'))

l <- meanARI(labels)
par(mfrow=c(1,1))
boxplot(l, main = paste0('flowsom', version, '_', patient, '_', seed, '_',
                         size, '_', nclust))
measures <- meanClustComp(labels)
meanMeas <- sapply(measures, mean)
boxplot(measures$ARI, main = paste0('flowsom', version, '_', patient, '_', seed, '_',
                                    size, '_', nclust))


## Varying sample size for a specific set of seed and ncluts - fluctuation in rand index:
for(p in 1:10){
  patient <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")[p]
  sizes <- c('10000','20000','50000','1e+05','-1')
  seed <- '42'
  nclust <- '21'
  version <- 1
  par(mfrow=c(1,5))
  for( s in sizes){
    load(paste0('../results/02_flowsom', version, '/flowsom', version, '_', patient, '_', seed, '_',
                s, '_', nclust, '.RData'))
    
    l <- meanClustComp(labels)
    sapply(l, mean)
    #pat_001 <- results[results$sampleSize==s,]
    boxplot(l$ARI, main = s, ylab = 'Adjusted Rand Index', ylim=c(0.6, 1))
  }
  mtext(paste0('flowsom', version, '_', patient, '_', seed, '_',
               nclust), side = 3, line = -30, outer = TRUE)
}
