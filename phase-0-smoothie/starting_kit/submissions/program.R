program <-
function (mix = NULL, ref = NULL, ...) 
{
    installed_packages <- installed.packages()
    for (package in c("zip", "nnls")) {
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
    idx_feat = intersect(rownames(mix), rownames(ref))
    prop = apply(mix[idx_feat, ], 2, function(b, A) {
        tmp_prop = nnls(b = b, A = A)$x
        tmp_prop = tmp_prop/sum(tmp_prop)
        return(tmp_prop)
    }, A = ref[idx_feat, ])
    rownames(prop) = colnames(ref)
    return(prop)
}
