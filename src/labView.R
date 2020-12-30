labView <- function(suid, dups=NULL) {
    ## suid = 21144
    library(hash)
    source('facToStr.R')
    source('mimicConfig.R')
    dnld = sprintf('%s/perSubj/LabData', dn)
    dnlv = sprintf('%s/perSubj/LabView', dn)
    idx = c('CHARTTIME', 'HADM_ID')
    vnp = c(idx, 'ITEMID', 'VALUENUM') # value number projection
    vcp = c(idx, 'ITEMID', 'VALUE')
    ## Some variables are recorded as NA, this is potentially different from non-recorded variables. For now, I treated them as same.
    vars = c('PCL', 'PK', 'PLCO2', 'PNA', 'HCT', 'HGB', 'MCV', 'PLT', 'WBC', 'RDW', 'PBUN', 'PCRE', 'PGLU') # 'Lactate', 
    cat(sprintf('%s\n', suid))
    fnld = sprintf('%s/ld_%s.RData', dnld, suid)

    if (file.exists(fnld)) {
        load(fnld); ld = facToStr(ld)
        if (dim(ld)[1]>1) {
            cat(sprintf('#adm: %d\n', length(unique(ld$HADM_ID))))
            cts = unique(ld[,idx])
            ctsc = as.character(unique(ld[,'CHARTTIME']))
            if (dim(cts)[1]==length(ctsc)) {
                cts2 = cts
                for (i in 1:dim(cts)[1]) {
                    ct = cts[i,]
                    if (grepl('01:00:00', ct$CHARTTIME)) {
                        cta = ct
                        cta[,'CHARTTIME'] = gsub('01:00:00', '03:00:00', ct$CHARTTIME)
                        if (!(cta$CHARTTIME %in% cts2$CHARTTIME)) {
                            cts2 = rbind(cts2, cta)
                        }
                    }
                }
                lv = cts2[order(cts2$CHARTTIME),]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%chloride%') group by itemid;
                PCL = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50902, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%potassium%') group by itemid;
                PK = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50971, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%bicarb%') group by itemid;
                PLCO2 = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50882, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%sodium%') group by itemid;
                PNA = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50983, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%hematocrit%') group by itemid;
                ## didn't include calculated
                HCT = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51221, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%hemoglobin%') group by itemid;
                ## didn't include blood gas
                HGB = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51222, vnp] 
                MCV = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51250, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%platelet%') group by itemid;
                ## didn't include platelet smear
                PLT = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51265, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%white%') group by itemid;
                ## use 51516 instead of 51300
                WBC = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51301, vnp] 
                RDW = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51277, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%urea%') group by itemid;
                PBUN = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==51006, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%creatinine%') group by itemid;
                ## didn't include urine creatinine
                PCRE = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50912, vnp]
                ## select itemid, count(*) c from labevents where itemid in (select itemid from d_labitems where label like '%glucose%') group by itemid;
                PGLU = ld[!is.na(ld$ITEMID) & !is.na(ld$VALUENUM) & ld$ITEMID==50931, vnp]

                for (vn in vars) {
                    var = eval(parse(text=vn)) # get var content from the name
                    colnames(var) = c(idx, 'ITEMID', vn)
                    varp = unique(var[,c(idx, vn)])
                    var = var[rownames(varp),]
                    var = facToStr(var)
                    
                    ## clean duplicates w.r.t. daylight saving time
                    cts = var$CHARTTIME
                    cts = cts[grepl('01:00:00', cts)]
                    tabt = table(cts)
                    tabt = tabt[tabt>1]
                    for (ct in names(tabt)) {
                        if (tabt[ct]==2) {
                            ctrp = gsub('01:00:00', '03:00:00', ct)

                            rowid = max(rownames(var[stt.sel,]))
                            cat(sprintf('%s duplicately for %s in %s, picked %s\n', ct, vn, suid, rowid))
                            var[rownames(var)==rowid,] = ctrp

                            cat(sprintf('changed %s for %s in %s\n', ct, vn, suid))
                        }
                    }

                    ## detect duplicates wo cleaning, 
                    var = unique(var[,c(idx, vn)])
                    tabt = table(var$CHARTTIME)
                    tabt = tabt[tabt>1]
                    if (length(tabt)>0) {
                        cat(sprintf('duplicate in %s for %s\n', vn, suid))
                        print(tabt)
                        if (!is.null(dups)) {
                            dups[[suid]] = 1
                        }
                    }
                    
                    lv = merge(lv, var, all.x=T)
                }
                lv = lv[rowSums(is.na(lv[,vars]))<length(vars),] #select non-empty rows
                fnlv = sprintf('%s/lv_%s.RData', dnlv, suid)
                save(lv, file=fnlv)
            }else {
                cat(sprintf('time adm assoc abnorm for %s\n', suid))
                lv = NA
            }
        }else {
            lv = NA
        }
    }else {
        lv = NA
    }
    return (lv)
}
