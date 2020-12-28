dn = '/home/shared_data/mimic3';

isnr = 0.01;
dnout = sprintf('%s/gpml/validation/gpml_raw_sample_%s', dn, num2str(isnr));
dnptad = sprintf('%s/perSubj/LabViewCase', dn);
fnptad = sprintf('%s/lvcase.csv', dn);
rderr = 0;

gpn_thr = 10; % 4 need at least 3 points to realibly estimate GP
rna_thr = 6; % needs at least some values for cross correlation
% under this setting, try to estimate the prob. of all missingness happen on the same variable, 1/len(ts)^4*len(ts) = 1/len(ts)^3 <= 1/1000
