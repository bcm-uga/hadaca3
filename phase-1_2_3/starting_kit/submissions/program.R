program <-
function (mix_rna = NULL, mix_met = NULL, ref_rna = NULL, ref_met = NULL) 
{
    requiered_packages = c("nnls")
    installed_packages <- installed.packages()
    for (package in requiered_packages) {
        if (!{
            package %in% installed_packages
        }) {
            print(x = paste("Installation of ", package, sep = ""))
            install.packages(pkgs = package, repos = "https://cloud.r-project.org")
        }
        else {
            print(x = paste(package, " is installed.", sep = ""))
        }
        library(package, character.only = TRUE)
    }
    remove(list = c("installed_packages", "package"))
    if (!(is.null(x = mix_rna))) {
        res_rna <- apply(X = mix_rna, MARGIN = 2, FUN = nnls, 
            A = ref_rna)
        prop_rna <- sapply(res_rna, function(res_bulk_i) {
            tmp_prop <- res_bulk_i$x
            tmp_prop <- tmp_prop/sum(tmp_prop)
            return(tmp_prop)
        })
        rownames(prop_rna) <- colnames(ref_rna)
    }
    if (!(is.null(mix_met))) {
        res_met <- apply(X = mix_met, MARGIN = 2, FUN = nnls, 
            A = ref_met)
        prop_met <- sapply(res_met, function(res_bulk_i) {
            tmp_prop <- res_bulk_i$x
            tmp_prop <- tmp_prop/sum(tmp_prop)
            return(tmp_prop)
        })
        rownames(prop_met) <- colnames(ref_met)
    }
    if (!is.null(x = mix_met)) {
        if (!is.null(x = mix_rna)) {
            stopifnot(identical(x = dim(prop_rna), y = dim(prop_met)))
            prop <- (prop_rna + prop_met)/2
        }
        else {
            prop <- prop_met
        }
    }
    else {
        prop <- prop_rna
    }
    if (any(colSums(prop) != 1)) {
        prop <- sapply(1:ncol(prop), function(col_i) {
            prop[, col_i]/sum(prop[, col_i])
        })
    }
    return(prop)
}
