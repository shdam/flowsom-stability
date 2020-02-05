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
#PBS -l nodes=1:ppn=28:thinnode
### Memory
#PBS -l mem=120gb
# specify the wall clock time (16 hours)
#PBS -l walltime=60:00:00
# Execute the job from the current working directory
cd $PBS_O_WORKDIR

# Load all required modules for the job
module load tools
module load intel/perflibs/64
module load R/3.6.1
# Program_name_and_options
Rscript flowmeans.R -p $PBS_ARRAYID
