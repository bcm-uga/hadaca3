sub_program <- 
    
    ##
    ## YOUR CODE BEGINS HERE
    ## 

    function(D_matrix,  k = 5){
        if ( !{ "NMF" %in% installed.packages( ) } ) {
            install.packages(pkgs = "NMF", repos = "https://cloud.r-project.org")
        }

        ## we compute the estimation of A for the data set :
        A_matrix <- NULL
        if ( !is.null(x = D_matrix) ) {
          
            ## /!\ temporary hack : we keep only the 10 000 first lines in order to save time for the baseline
            if ( nrow(x = D_matrix) > 1e4 ) {
                D_matrix[seq_len(length.out = 1e4), ]
            }
            ## /!\ END of temporary hack 
            
            #use NMF as deconvolution algorithm
            res   <- NMF::nmf(x = D_matrix, rank = k, method = "lee") 
            
            #transform the matrix res into a proportion matrix
            A_matrix <- apply(
                X      = res@fit@H
              , MARGIN = 2
              , FUN    = function( x ) {
                  x / sum( x )
              }
            )
            
            # estimate the cell-type specific profiles
            T_matrix = NMF::basis(res)
            
            remove(list = "res")
        }

    
    return( list(A_matrix = A_matrix, T_matrix = T_matrix) )
    }