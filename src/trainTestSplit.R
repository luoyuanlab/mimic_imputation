trainTestSplit <- function(fnpt, fntr, fnte, ptr=0.7) {
    ## fnpt, list of pts; fntr, list of training pts
    ## trainTestSplit(fnpt='/data/mghcfl/mgh_time_series/ptads_val.csv', fntr='/data/mghcfl/mgh_time_series/ptads_val_tr_0.5.csv', fnte='/data/mghcfl/mgh_time_series/ptads_val_te_0.5.csv', ptr=0.5)
    set.seed(110315)
    pts = read.csv(fnpt, header=F)
    pts = as.vector(pts[,1])
    npt = length(pts)
    perm.pts = sample(pts, size=npt, replace=F)
    ntr = round(npt*ptr)
    pt.tr = perm.pts[1:ntr]
    pt.te = perm.pts[(ntr+1):npt]
    write.table(pt.tr, file=fntr, quote=F, row.names=F, col.names=F)
    write.table(pt.te, file=fnte, quote=F, row.names=F, col.names=F)
}
