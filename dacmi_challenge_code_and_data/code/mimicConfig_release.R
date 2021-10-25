server = Sys.info()['nodename']
if (server == 'server1') {
    dnroot = 'folder1'
}else if (grepl('domain2', server)) {
    dnroot = 'folder2'
}else if (grepl('domain3', server)) {
    dnroot = 'folder3'
}else {
    # quit(sprintf('unrecognized server %s\n', server))
}
dnroot = '/share/fsmresfiles/mimic3/ichi_release'

tests = c('PCL', 'PK', 'PLCO2', 'PNA', 'HCT', 'HGB', 'MCV', 'PLT', 'WBC', 'RDW', 'PBUN', 'PCRE', 'PGLU')

fnlog.tmp = sprintf('%s/micegp_log/%%s_output_iter%%s.RData', dnroot)
fnres.tmp = sprintf('%s/micegp_log/%%s_res_iter%%s.RData', dnroot)
fnkm.tmp = sprintf('%s/micegp_log/%%s_km_iter%%s.RData', dnroot)

timeidx = 'CHARTTIME'


