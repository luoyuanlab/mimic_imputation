function [] = gpTensorImpValidation(batch,bsize,fncf)
  %% isnr inverse signal to noise ratio, different tests -> different isnr
  addpath(genpath('../gpml-matlab-v3.5-2014-12-08'));
  startup;
  addpath('../');
  rng(0,'twister');

  if nargin < 3
    fncf = 'mghtsConfig';
  end
  eval(fncf);

  fnout = sprintf('%s/gpTensorImpValidation%d.tsv',dnout,batch);
  fnerr = sprintf('%s/gpTensorImpValidation%d.err',dnout,batch);

  fout = fopen(fnout, 'w');
  ferr = fopen(fnerr, 'w');
  fprintf(fout, 'pt\ttest\ti\ty\tymax\tymin\tpred\tdiff\tstdpr\tstdt\tcov1\tcov2\tmean1\tmean2\tlik\n');
  %% startup;
  tests = {'PCL' 'PK' 'PLCO2' 'PNA' 'HCT' 'HGB' 'MCV' 'PLT' 'WBC' 'RDW' 'PBUN' 'PCRE' 'PGLU'};
  nlab = length(tests); %% number of labs
  %% fptad = fopen('/data/mghcfl/mgh_time_series/pt_aligned_no_na.csv');
  fptad = fopen(fnptad);
  ptads = textscan(fptad, '%s');
  fclose(fptad);


  %% function setup
  meanfunc = {@meanSum, {@meanLinear, @meanConst}};
  covfunc = @covSEiso;
  likfunc = @likGauss;

  for i = (batch-1)*bsize+1:min(batch*bsize,length(ptads{1}))
    ptad = ptads{1}{i};
    fprintf('processing %s\n', ptad);
    fn = sprintf('%s/%s.csv', dnptad, ptad);
    ts = csvread(fn, 1);
    x = ts(:,1);
    if rderr
      herr = errhash(ptad);
    end
    nancnt = sum(isnan(ts),2);
    ts = ts(nancnt <= rna_thr, :);
    for li = 1:nlab
      test = tests{li};
      %% fprintf('test %s\n', test);
      y = ts(:,li+1); %% first one columns occupied

      if rderr
      for ti = 1:length(x)
        k = sprintf('%d_%s', x(ti), test);
	if isKey(herr, k)
	   y(ti) = NaN;
	   fprintf(ferr, 'cast %s to NaN in %s\n', k, ptad);
	end
      end
      end
      
      ytr = y(~isnan(y));
      xtr = x(~isnan(y));
      ymax = max(y); ymin = min(y);
      if length(xtr) >= gpn_thr % 4 need at least 3 points to realibly estimate GP
        stdt = std(ytr);
        ival = randi(length(xtr)); % need to unify with 3D MICE's choice
        xval = xtr(ival);
        yval = ytr(ival);
        xtr = xtr(1:end ~= ival);
        ytr = ytr(1:end ~= ival);
        if std(ytr) > 0.001 %% robust to approx. err.
	  %% impute
          hyp.cov = [log(mean(diff(xtr))); log(std(ytr))];
	  %% see http://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
          hyp.mean = [0; mean(ytr)]; 
          hyp.lik = log(isnr*std(ytr));
          hyp = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, xtr, ytr);
          [ypred s2pred] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, xtr, ytr, xval);
          fprintf(fout, '%s\t%s\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t', ptad, test, ival, yval, ymax, ymin, ypred, ypred-yval, sqrt(s2pred), stdt); 
          fprintf(fout, '%f\t%f\t%f\t%f\t%f\n', hyp.cov(1), hyp.cov(2), hyp.mean(1), hyp.mean(2), hyp.lik(1)); 
        else
          fprintf(ferr, '%s, non-varying %s\n', ptad, test);
        end
      else
        fprintf(ferr, '%s, not enough training data for %s\n', ptad, test);
      end
    end
  end

  fclose(fout);
