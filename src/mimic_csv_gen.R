library(hash)
source('constructPtTensor.R')
source('maskPtTensorImport.R')
source('splitTrainTestTensor.R')
source('trainTestSplit.R')

fncf='mimicConfig.R'
source(fncf)

ptt = constructPtTensor(fncf=fncf)
trainTestSplit(fnpt=fnptads.val, fntr=sprintf(fntr.tmp, rtrte), fnte=sprintf(fnte.tmp, rtrte), ptr=rtrte)
t.trte = splitTrainTestTensor(ptt, fncf=fncf)

## train
h = maskPtTensorImport(t.trte[['tr']], fncf=fncf)
tgt.tr = h[['t']]
tnagt.tr = h[['tna']]
naidx.tr = h[['naidx']]

# names(tgt.tr) = as.character(1:length(tgt.tr))
# names(tnagt.tr) = as.character(1:length(tnagt.tr))

for (i in names(tgt.tr)) {
    dnout = sprintf('%s/train_groundtruth', dn)
    fn = sprintf('%s/%s.csv', dnout, i)
    write.csv(tgt.tr[[i]], file=fn, quote=F, row.names=F)
}

for (i in names(tnagt.tr)) {
    dnout = sprintf('%s/train_with_missing', dn)
    fn = sprintf('%s/%s.csv', dnout, i)
    write.csv(tnagt.tr[[i]], file=fn, quote=F, row.names=F)
}

write.table(names(tgt.tr), file=sprintf('%s/pts.tr.csv', dn), row.names=F, col.names=F, quote=F)
write.csv(naidx.tr, file=sprintf('%s/naidx.tr.csv', dn), quote=F)

## test
h = maskPtTensorImport(t.trte[['te']], fncf=fncf)
tgt.te = h[['t']]
tnagt.te = h[['tna']]
naidx.te = h[['naidx']]

# names(tgt.te) = as.character(1:length(tgt.te))
# names(tnagt.te) = as.character(1:length(tnagt.te))

for (i in names(tgt.te)) {
    dnout = sprintf('%s/test_groundtruth', dn)
    fn = sprintf('%s/%s.csv', dnout, i)
    write.csv(tgt.te[[i]], file=fn, quote=F, row.names=F)
}

for (i in names(tnagt.te)) {
    dnout = sprintf('%s/test_with_missing', dn)
    fn = sprintf('%s/%s.csv', dnout, i)
    write.csv(tnagt.te[[i]], file=fn, quote=F, row.names=F)
}

write.table(names(tgt.te), file=sprintf('%s/pts.te.csv', dn), row.names=F, col.names=F, quote=F)
write.csv(naidx.te, file=sprintf('%s/naidx.te.csv', dn), quote=F)
