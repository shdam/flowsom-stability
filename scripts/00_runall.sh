#!/bin/sh
# General options
### Account information
#PBS -W group_list=dp_immunoth -A dp_immunoth
# -- JobName --
#PBS -N cluster-stab-flowsom
# -- stdout/stderr redirection --
#PBS -o log/$PBS_JOBNAME.$PBS_JOBID.out
#PBS -e log/$PBS_JOBNAME.$PBS_JOBID.err
# -- specify queue --
##PBS -q hpc
# -- user email address --
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
#PBS -M s153398@student.dtu.dk
# -- mail notification --
##PBS -m abe
# -- Job array specification --
#PBS -t 1-4000%10
# Number of cores
#PBS -l nodes=2:ppn=28:thinnode
### Memory
#PBS -l mem=120gb
# specify the wall clock time (48 hours)
#PBS -l walltime=02:00:00:00
# Execute the job from the current working directory
cd $PBS_O_WORKDIR

# Load all required modules for the job
module load tools
module load intel/perflibs/64
module load R/3.6.1
# Program_name_and_options
Rscript 01_make_parameter_grid.R
mkdir -p ../results/02_flowsom1
mkdir -p ../results/02_flowsom2
Rscript 02_flowsom.R -p $PBS_ARRAYID
Rscript 02_flowsom2.R -p $PBS_ARRAYID
# Compute evaluations
echo ../results/02_flowsom1/* | Rscript 03_computeEvaluation.R -f ../results/03_flow1Result.RData
echo ../results/02_flowsom2/* | Rscript 03_computeEvaluation.R -f ../results/03_flow2Result.RData
# Create plots
mkdir -p ../results/04_figs
Rscript 04_resultAnalysis.R
