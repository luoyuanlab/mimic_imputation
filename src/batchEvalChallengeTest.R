source('evalChallengeTest.R')
source('mimicConfig.R')
pts.te = read.csv(sprintf('%s/pts.te.csv', dn), header=F)[,1]

## load(sprintf('%s/tgt.RData', dn))
tgt = list()
dn.tgt = sprintf('%s/test_groundtruth', dn)
for (i in pts.te) {
    fn = sprintf('%s/%d.csv', dn.tgt, i)
    tgt[[i]] = t(read.csv(fn))
}
names(tgt) = as.character(1:length(tgt))

naidx = read.csv(sprintf('%s/naidx.te.csv', dn), stringsAsFactors=F)


evalChallengeTest(tgt, naidx, sprintf('%s/test_results', dn))

