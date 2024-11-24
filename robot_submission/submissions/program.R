#' The function to predict the A matrix
#' In the provided example, we use basic non-negative least squares (package "nnls"), which consists in minimizing the error term $||Mix - Ref \times Prop||^2$ with only positive entries in the prop matrix.
#'
#' @param mix a matrix of bulk samples (columns) and features (rows)
#' @param ref a matrix of pure cell types (columns) and features (rows)
#' @param ... other parameters that will be ignored
#' 
#' @return the predicted A matrix
#' @examples
#' 
program = function(mix=NULL, ref=NULL, ...) {
  ##
  ## YOUR CODE BEGINS HERE
  ##
  
  idx_feat = intersect(rownames(mix), rownames(ref))
  prop = apply(mix[idx_feat,], 2, function(b, A) {
    tmp_prop = nnls::nnls(b=b, A=A)$x
    tmp_prop = tmp_prop / sum(tmp_prop) # Sum To One
    return(tmp_prop)
  }, A=ref[idx_feat,])  
  rownames(prop) = colnames(ref)
  
  return(prop)
  
  ##
  ## YOUR CODE ENDS HERE
  ##
}
