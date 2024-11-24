program <-
function (mix = NULL, ref = NULL, ...) 
{
    idx_feat = intersect(rownames(mix), rownames(ref))
    prop = apply(mix[idx_feat, ], 2, function(b, A) {
        tmp_prop = lm(b ~ A - 1)$coefficients
        tmp_prop = tmp_prop/sum(tmp_prop)
        return(tmp_prop)
    }, A = ref[idx_feat, ])
    rownames(prop) = colnames(ref)
    return(prop)
}
