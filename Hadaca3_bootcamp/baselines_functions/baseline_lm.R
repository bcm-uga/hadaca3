#' The function to estimate the A matrix
#' In the provided example, we use basic non-negative least squares (package "nnls"), which consists of minimizing the error term $||Mix - Ref \times Prop||^2$ with only positive entries in the prop matrix.
#'
#' @param mix a matrix of bulks (columns) and features (rows)
#' @param ref a matrix pure types (columns) and features (rows)
#' @param ... other parameters that will be ignored
#' 
#' @return an estimation of matrix A
#' 
program = function(mix=NULL, ref=NULL, ...) {

  ##
  ## YOUR CODE BEGINS HERE
  ##

  # idx_feat corresponds to the intersection of features present in the references and in the mixtures.
  idx_feat = intersect(rownames(mix), rownames(ref))
  
  # Estimation of proportions
  prop = apply(mix[idx_feat,], 2, function(b, A) {
    tmp_prop = lm(b ~ A - 1)$coefficients  # Using `-1` to remove the intercept
    tmp_prop[tmp_prop < 0] = 0
    tmp_prop = tmp_prop / sum(tmp_prop)    # Sum To One
    return(tmp_prop)
  }, A=ref[idx_feat,])

  # Labeling of estimated proportions 
  rownames(prop) = colnames(ref)
  return(prop)
  
  ##
  ## YOUR CODE ENDS HERE
  ##
}
