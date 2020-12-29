evalChallengeTest <- function(tgt, naidx, dnimp) {
    source('evalPtTensorImpImportTrTeChallenge.R')

    timp = list()
    for (i in pts.te) {
        fn = sprintf('%s/%d.csv', dnimp, i)
        timp[[i]] = t(read.csv(fn))
    }
    names(timp) = as.character(1:length(timp))

    nrmse = evalPtTensorImpImportTrTeChallenge(timp, tgt, naidx, metric='RMSE range norm')
    cat(sprintf('%s nRMSE\n', dnimp))
    print(nrmse)
}

