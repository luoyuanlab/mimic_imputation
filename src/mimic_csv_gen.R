library(hash)
source('constructPtTensor.R')
source('maskPtTensorImport.R')
source('splitTrainTestTensor.R')

fncf='mimicConfig.R'
source(fncf)

ptt = constructPtTensor(fncf=fncf)
t.trte = splitTrainTestTensor(ptt, fncf=fncf)

## train
h = maskPtTensorImport(t.trte[['tr']], fncf=fncf)
tgt.tr = h[['t']]
tnagt.tr = h[['tna']]

names(tgt.tr) = as.character(1:length(tgt.tr))
names(tnagt.tr) = as.character(1:length(tnagt.tr))

for (i in 1:length(tgt.tr)) {
    dnout = sprintf('%s/train_groundtruth', dn)
    fn = sprintf('%s/%d.csv', dnout, i)
    write.csv(t(tgt.tr[[i]]), file=fn, quote=F, row.names=F)
}

for (i in 1:length(tnagt.tr)) {
    dnout = sprintf('%s/train_with_missing', dn)
    fn = sprintf('%s/%d.csv', dnout, i)
    write.csv(t(tnagt.tr[[i]]), file=fn, quote=F, row.names=F)
}

write.table(1:length(tgt.tr), file=sprintf('%s/pts.tr.csv', dn), row.names=F, col.names=F, quote=F)


## test
h = maskPtTensorImport(t.trte[['te']], fncf=fncf)
tgt.te = h[['t']]
tnagt.te = h[['tna']]

names(tgt.te) = as.character(1:length(tgt.te))
names(tnagt.te) = as.character(1:length(tnagt.te))

for (i in 1:length(tgt.te)) {
    dnout = sprintf('%s/test_groundtruth', dn)
    fn = sprintf('%s/%d.csv', dnout, i)
    write.csv(t(tgt.te[[i]]), file=fn, quote=F, row.names=F)
}

for (i in 1:length(tnagt.te)) {
    dnout = sprintf('%s/test_with_missing', dn)
    fn = sprintf('%s/%d.csv', dnout, i)
    write.csv(t(tnagt.te[[i]]), file=fn, quote=F, row.names=F)
}

write.table(1:length(tgt.te), file=sprintf('%s/pts.te.csv', dn), row.names=F, col.names=F, quote=F)
