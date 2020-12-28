dn = '/home/share_data/mimic3'

dnce = sprintf('%s/perSubj/ChartEvents', dn)
dncd = sprintf('%s/perSubj/ChartData', dn)
dnlv = sprintf('%s/perSubj/LabView', dn)
dnlvc = sprintf('%s/perSubj/LabViewCase', dn)
tests = c('PCL', 'PK', 'PLCO2', 'PNA', 'HCT', 'HGB', 'MCV', 'PLT', 'WBC', 'RDW', 'PBUN', 'PCRE', 'PGLU')

dnraw = sprintf('%s/perSubj/LabViewCase', dn)
dnval= sprintf('%s/gpml/validation/gpml_raw_sample_0.01', dn)
tests = c('PCL', 'PK', 'PLCO2', 'PNA', 'HCT', 'HGB', 'MCV', 'PLT', 'WBC', 'RDW', 'PBUN', 'PCRE', 'PGLU')
dndata = sprintf('%s/imp_data', dn)
fnptads = sprintf('%s/lvcase.csv', dn)
fnwptads = sprintf('%s/gpml/stgp_warning_ptads.csv', dn)
fnptads.val = sprintf('%s/lvcase_val.csv', dn)

fntr.tmp = sprintf('%s/lvcase_spl_val_tr_%%s.csv', dn)
fnte.tmp = sprintf('%s/lvcase_spl_val_te_%%s.csv', dn)

fnlog.tmp = sprintf('%s/micegp_log/%%s_output_iter%%s.RData', dn)
fnres.tmp = sprintf('%s/micegp_log/%%s_res_iter%%s.RData', dn)
fnkm.tmp = sprintf('%s/micegp_log/%%s_km_iter%%s.RData', dn)

fntensor = sprintf('%s/imp_data/ptt.RData', dn)

rtrte=0.5

timeidx = 'CHARTTIME'

gpn.thr = 10; # 4 need at least 3 points to realibly estimate GP
rna.thr = 6; # needs at least some values for cross correlation
## under this setting, try to estimate the prob. of all missingness happen on the same variable, 1/len(ts)^4*len(ts) = 1/len(ts)^3 <= 1/1000
