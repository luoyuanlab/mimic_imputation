library(hash)
source('constructPtTensor.R')
source('maskPtTensorImport.R')
source('evalPtTensorImpImportTrTe.R')
source('splitTrainTestTensor.R')
fncf='mimicConfig.R'
## ptt = constructPtTensor(fncf=fncf)
source(fncf)
missingRate<-function(t.trte, trte) {
    testcnt = rep(0, length(tests))
    names(testcnt) = tests
    testnacnt.nat = rep(0, length(tests))
    names(testnacnt.nat) = tests
    testnacnt = rep(0, length(tests))
    names(testnacnt) = tests
    
    ptt = t.trte[[trte]]
    h = maskPtTensorImport(ptt, fncf=fncf)
    t = h[['t']]
    tna = h[['tna']]
    for (pt in names(t)) {
        ptad.na = tna[[pt]]
        ptad = t[[pt]]
        for (test in tests) {
            testcnt[test] = testcnt[test] + dim(ptad)[2]
            testnacnt.nat[test] = testnacnt.nat[test] + sum(is.na(ptad[test,]))
            testnacnt[test] = testnacnt[test] + sum(is.na(ptad.na[test,]))
        }
    }
    list(cnt=testcnt, nacnt=testnacnt, nacnt.nat=testnacnt.nat)
}
load(sprintf('%s/ptt.RData', dndata))
t.trte = splitTrainTestTensor(ptt, fncf=fncf)

ctr=missingRate(t.trte, 'tr')
cte=missingRate(t.trte, 'te')

na.pct = (ctr$nacnt + cte$nacnt) / (ctr$cnt + cte$cnt)
na.pct.nat = (ctr$nacnt.nat + cte$nacnt.nat) / (ctr$cnt + cte$cnt)

write.csv(t(rbind(na.pct, na.pct.nat)), file='missing_rate.csv', quote=F)

## get inter-quartile range
mat = do.call(cbind, ptt)
apply(mat, 1, function(x) {quantile(x, c(0.25, 0.75), na.rm=T)})
