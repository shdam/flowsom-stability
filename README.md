## FlowSOM stability analysis


The 00\_runall.sh will run everything - i.e. FlowSOM 1 and 2 will be run with 4000 different configurations. The script is set up to run on Computerome 1.0 and should be run from the scripts folder.

Step 1:\
Make a grid of parameters to be evaluated:\
*$ Rscript 01_make_parameter_grid.R*

Step 2:\
Run FlowSOM - The programs run 10 iterations of the clustering algorithm with varying seed.\
There are two versions of FlowSOM. Flowsom1 resample the subsample using a varying seed, but keeps the clustering seed constant. Flowsom2, on the other hand, keeps the subsample stable, but varies the seed used for clustering.\
*$ Rscript 02_flowsom.R -p $PBS_ARRAYID*\
*$ Rscript 02_flowsom2.R -p $PBS_ARRAYID*\
The variable PBS\_ARRAYID refers to the job array values. If a specific parameter set is desired to be run, the position in parameter grid can be used. The function 'file2param' can be used for this. The input is a filename - an example is:\
'flowsom1\_001\_42\_1e+05\_16.RData'.\
*\> file2param("\<flowsom-version\>\_\<patient\>\_\<seed\>\_\<sample-size\>\_\<nclust\>.RData")*

Step 3:/
Evaluate the generated results and combine them into a single file.\
*$ echo ../results/02_flowsom1/ | Rscript 03_computeEvaluation.R -f ../results/03_flow1Result.RData*\
*$ echo ../results/02_flowsom2/ | Rscript 03_computeEvaluation.R -f ../results/03_flow2Result.RData*

Step 4:\
Create various graphs for analysis.\
*$ Rscript 04_resultAnalysis.R*
