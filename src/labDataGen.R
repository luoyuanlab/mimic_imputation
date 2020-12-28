source('mimicConfig.R')
items = read.csv(sprintf('%s/D_LABITEMS.csv', dn))
subjs = read.csv(sprintf('%s/PATIENTS.csv', dn))
suids = subjs$SUBJECT_ID
dnle = sprintf('%s/perSubj/LabEvents', dn)
dnld = sprintf('%s/perSubj/LabData', dn)
cnt = 0
for (suid in suids) {
    cnt = cnt + 1
    fnle = sprintf('%s/le_%s.csv', dnle, suid)
    fnld = sprintf('%s/ld_%s.RData', dnld, suid)
    if (file.exists(fnle)) {
        le = read.csv(fnle)
        ld = merge(le, items, by=c('ITEMID'))
        save(ld, file=fnld)
        if (cnt %% 1000==0) {
            cat(sprintf('%d subjs\n', cnt))
        }
    }else {
        cat(sprintf('no lab events for %s\n', suid))
    }
}
