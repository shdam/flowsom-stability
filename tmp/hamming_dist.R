# labels from cluster A will be matched on the labels from cluster B
minWeightBipartiteMatching <- function(clusteringA, clusteringB) {
  require(clue)
  idsA <- unique(clusteringA)  # distinct cluster ids in a
  idsB <- unique(clusteringB)  # distinct cluster ids in b
  nA <- length(clusteringA)  # number of instances in a
  nB <- length(clusteringB)  # number of instances in b
  if (length(idsA) != length(idsB) || nA != nB) {
    stop("number of cluster or number of instances do not match")
  }
  
  nC <- length(idsA)
  tupel <- c(1:nA)
  
  # computing the distance matrix
  assignmentMatrix <- matrix(rep(-1, nC * nC), nrow = nC)
  for (i in 1:nC) {
    tupelClusterI <- tupel[clusteringA == i]
    solRowI <- sapply(1:nC, function(i, clusterIDsB, tupelA_I) {
      nA_I <- length(tupelA_I)  # number of elements in cluster I
      tupelB_I <- tupel[clusterIDsB == i]
      nB_I <- length(tupelB_I)
      nTupelIntersect <- length(intersect(tupelA_I, tupelB_I))
      return((nA_I - nTupelIntersect) + (nB_I - nTupelIntersect))
    }, clusteringB, tupelClusterI)
    assignmentMatrix[i, ] <- solRowI
  }
  
  # optimization
  result <- solve_LSAP(assignmentMatrix, maximum = FALSE)
  attr(result, "assignmentMatrix") <- assignmentMatrix
  return(result)
}
matching <- minWeightBipartiteMatching(
  labels[[2]], 
  labels[[3]]
)

clusterA <- labels[[2]]  # map the labels from cluster A
tmp <- sapply(1:length(matching), function(i) {
  clusterA[which(labels[[2]] == i)] <<- matching[i]
})

clusterB <- labels[[3]]


matching <- minWeightBipartiteMatching(
  clusterA, 
  clusterB
)
library('e1071')
ham <- hamming.distance(clusterA,clusterB)
b <- length(clusterA)
ham_index <- (b-ham)/b
cbind(clusterA,clusterB)

for(lab in labels){
  print(length(unique(lab)))
}

hamdist <- function(labs){
  
}

