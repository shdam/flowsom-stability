# Make parameter_grid file

# Set variable parameters to run through
patients <- c('001', '284d2', '84-0001-01', '885d1', '885d3', '885d4', '885d5', 'Pat03', 'Pat05', "all")
seeds    <- c(42, 200, 404, 666, 1337)
sizes    <- c(10000, 20000, 50000, 100000, -1) # Consider including sizes between 100000 and -1.
nclusts  <- 15:30

# Save parameter grid:
parameter_grid <- expand.grid(patients, sizes, seeds, nclusts)
names(parameter_grid) <- c('patient', 'size', 'seed', 'nclust')
save(parameter_grid, file='../data/01_parameter_grid.RData')
