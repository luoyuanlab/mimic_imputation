evalPtTensorImpImportTrTeChallenge <- function(timp, tgt, naidx, metric='RMSE range norm') {
    library(hash)
    qtl = (1:10)/10
    stopifnot(metric=='RMSE range norm')
    tests = c('PCL', 'PK', 'PLCO2', 'PNA', 'HCT', 'HGB', 'MCV', 'PLT', 'WBC', 'RDW', 'PBUN', 'PCRE', 'PGLU')

    nrmse = rep(0, length(tests))
    names(nrmse) = tests
    nrmse.v = list()
    for (test in tests) {
        nrmse.v[[test]] = c()
    }
    n = dim(naidx)[1]
    for(i in 1:n) {
        ipt = naidx[i, "pt"]; iv = naidx[i, "test"]; it = naidx[i, "i"]
        eimp = timp[[ipt]][it, iv]; eraw = tgt[[ipt]][it, iv]

        if (metric=='RMSE range norm') {
            update = ((eimp - eraw) / (max(tgt[[ipt]][iv,], na.rm=T) - min(tgt[[ipt]][iv,], na.rm=T)))^2
        }

        if (is.na(update) | is.infinite(update)) {
            cat(sprintf('%s, %s, %s\n', ipt, iv, it))
        }
        nrmse[iv] = nrmse[iv] + update
        if (metric=='RMSE range norm') {
            nrmse.v[[iv]] = c(nrmse.v[[iv]], sqrt(update))
        }

    }
    for(test in tests){
        if (metric=='RMSE range norm') {
            nrmse[test] = sqrt(nrmse[test] / sum(naidx$test==test))
        }

    }
    return (nrmse);
}
