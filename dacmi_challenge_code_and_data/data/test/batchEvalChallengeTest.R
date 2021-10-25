source('evalChallengeTest.R')
dngt = '/share/fsmresfiles/mimic3/ichi_release'
pts.te = read.csv(sprintf('%s/pts.te.csv', dngt), header=F)[,1]

## load(sprintf('%s/tgt.RData', dngt))
tgt = list()
dn.tgt = sprintf('%s/test_groundtruth', dngt)
for (i in pts.te) {
    fn = sprintf('%s/%d.csv', dn.tgt, i)
    tgt[[i]] = t(read.csv(fn))
}
names(tgt) = as.character(1:length(tgt))

naidx = read.csv(sprintf('%s/naidx.te.csv', dngt), stringsAsFactors=F)


evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_181/test_imputed_interp+KNN_K3')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_182/test_filled')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_183/Method_A')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_183/Method_B')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_183/Method_C')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_184/test_with_imputing')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_185/test_data_pred')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_186/result/data')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_187/Results/test_imputed')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_188/all_imputed')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_189/output_final')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_190/results')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_191/test_with_missing_and_code/test_with_missing_knn/test_with_missing_knn')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_192/XGB_test_fill_result')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_194/result')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_195/Submission/test_with_imputation')

evalChallengeTest(tgt, naidx, '/share/fsmresfiles/ichi_dacmi/submissions/ichi2019_Resultsubmissions_196')
