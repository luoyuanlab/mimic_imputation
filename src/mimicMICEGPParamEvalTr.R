#' ---
#' title: "Temporal MICE-GP Train Evaluation for MIMIC"
#' author: "Yuan Luo"
#' always_allow_html: yes
#' ---
library(hash)
source('temporalMICEGP.R')


fncf='mimicConfig.R'
source(fncf)

pts.tr = read.csv(sprintf('%s/pts.tr.csv', dn), header=F)[,1]

## load(sprintf('%s/tgt.tr.RData', dn))
tgt.tr = list()
dn.tgt = sprintf('%s/train_groundtruth', dn)
for (i in pts.tr) {
    fn = sprintf('%s/%d.csv', dn.tgt, i)
    tgt.tr[[i]] = t(read.csv(fn))
}
names(tgt.tr) = as.character(1:length(tgt.tr))

## load(sprintf('%s/tnagt.tr.RData', dn))
tnagt.tr = list()
dn.tnagt = sprintf('%s/train_with_missing', dn)
for (i in pts.tr) {
    fn = sprintf('%s/%d.csv', dn.tnagt, i)
    tnagt.tr[[i]] = t(read.csv(fn))
}
names(tnagt.tr) = as.character(1:length(tnagt.tr))

naidx = read.csv(sprintf('%s/naidx.tr.csv', dn), stringsAsFactors=F)

h = hash()
h[['t']] = tgt.tr
h[['tna']] = tnagt.tr
h[['naidx']] = naidx

## nimp specifies how many MICE imputation to perform, ncores specifies how many cores to parallel the multiple imputations. nimp should be a multiply of ncores. You can set ncores to higher or lower values depending on the machine capacity. On a 20 core machine, this code should run in less than a day.
rmicegp.tr = temporalMICEGP(h, m=2, trte='tr', nimp=40, ncores=20, fncf=fncf)



