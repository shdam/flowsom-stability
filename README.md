## FlowSOM stability analysis

The 00_runall.sh should be run on a supercomputer like Computerome.

Step 1:
Make a grid of parameters to be evaluated

Step 2:
Run FlowSOM - The programs run 10 iterations of the clustering algorithm with varying seed.
There are two versions of FlowSOM. Flowsom1 resample the subsample using a varying seed, but keeps the clustering seed constant. Flowsom2, on the other hand, keeps the subsample stable, but varies the seed used for clustering.

Step 3:
Evaluate the generated results and combine them into a single file.

Step 4:
Create various graphs for analysis.
