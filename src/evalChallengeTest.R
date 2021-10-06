evalChallengeTest <- function(tgt, naidx, dnimp) {
    source('evalPtTensorImpImportTrTeChallenge.R')

    timp = list()
    for (i in pts.te) {
        fn = sprintf('%s/%s.csv', dnimp, i)
        # row is time, column is variable
        timp[[i]] = read.csv(fn, row.names = 1, header = FALSE)
        rownames(timp[[i]]) <- 1:nrow(timp[[i]])
    }
    # names(timp) = as.character(1:length(timp))

    nrmse = evalPtTensorImpImportTrTeChallenge(timp, tgt, naidx, metric='RMSE range norm')
    cat(sprintf('%s nRMSE\n', dnimp))
    print(nrmse)
}

