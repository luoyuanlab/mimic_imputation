library(chron)
source('config.R')
subjs = read.csv(sprintf('%s/PATIENTS.csv', dn))
suids = unique(subjs$SUBJECT_ID)
esuids = read.csv('lvgen_duplicate.txt', header=F)
esuids = esuids[,1]
cnt = 0
lvcases = c()
for (suid in suids) {
    fnlv = sprintf('%s/lv_%s.RData', dnlv, suid)
    if (!(suid %in% esuids) & file.exists(fnlv)) {
        cnt = cnt + 1
        load(fnlv)
        caseids = unique(lv$HADM_ID); caseids = caseids[!is.na(caseids)]
        for (caseid in caseids){
            lvcase = sprintf('lv_%s_%s', suid, caseid)
            fnlvc = sprintf('%s/%s.csv', dnlvc, lvcase)
            lvcases = c(lvcases, lvcase)
            lvc = lv[!is.na(lv$HADM_ID) & lv$HADM_ID==caseid,]
            dts = t(as.data.frame(strsplit(as.character(lvc$CHARTTIME), ' ')))
            dts = chron(dates=dts[,1], times=dts[,2], format=c('y-m-d', 'h:m:s'))
            toff = min(dts)
            dts = round(as.numeric(difftime(dts, toff, unit="mins")))
            lvc[,'CHARTTIME'] = dts
            lvc = lvc[,c('CHARTTIME', tests)]
            ## add time point filters 3/14/2016
            ## tsrmax = apply(lvc[,-(1:2)], 1, function(x) {max(x, na.rm=T)})
            tsrnac = apply(lvc[,-(1:2)], 1, function(x) {sum(is.na(x))})
            ## rowsel = tsrmax<1000 & tsrnac<6
            rowsel = tsrnac<length(tests) # not all missing
            lvc = lvc[rowsel,]
            if (dim(lvc)[1]>1) {
                write.csv(lvc, quote=F, file=fnlvc, row.names=F, na='NaN')
            }
        }
        if (cnt %% 1000==0) {
            cat(sprintf('%d subjs\n', cnt))
        }
    }
}

cat(paste(lvcases, collapse="\n"), file=sprintf('%s/lvcase.csv', dn))
