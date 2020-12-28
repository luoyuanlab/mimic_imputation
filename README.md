# mimic_imputation
Generating the imputation dataset for the DACMI 2019 challenge

## Generate per subject per admission lab data
Assume the following root data directory
```
dn = /home/shared_data/mimic3
```
First, split lab events in Python (create subdirectories if they don't exist)
```
import mimic3 as m3
m3.split_mimic3(fn='/home/shared_data/mimic3/LABEVENTS.csv', dnout='/home/shared_data/mimic3/perSubj/LabEvents', pref='le')
```
Then run the following R code:
```
source('labDataGen.R')
source('labViewGenSeq.R')
source('labViewCase.R')
```

## Run single task Gaussian Process to impute
Assume the inverse signal to noise ratio is ```isnr=0.01```, which is used in ```gpTensorImpValidation.m```
create the following directories
```
$dn/gpml/log
$dn/gpml/validation/gpml_raw_sample_$isnr
```
Run the following code in Python
```
import pscript as ps
ps.gpmlScript(fnscript='./gpmlMIMICScript.sh', fn=f'{dn}/lvcase.csv', fncf='mimicConfig', bsize=2000)
```
Run the following in shell
```
./gpmlMIMICScript.sh
```
After completion, run the following in shell
```
cd $dn/gpml/validation/gpml_raw_sample_$isnr
grep 'not enough training' *.err > ../../stgp_warning_ptads2.csv
grep 'non-varying' *.err > ../../stgp_warning_ptads1.csv
cd ../../
```
Run the following code in R
```
pt2 = read.csv('stgp_warning_ptads2.csv', header=F)
pt1 = read.csv('stgp_warning_ptads1.csv', header=F)
pt = union(gsub('^.*:', '', pt1$V1), gsub('^.*:', '', pt2$V1))
write.table(pt, file='stgp_warning_ptads.csv', row.names=F, col.names=F, quote=F)
```

## Generate the data and split train and test sets
Run the following code in R
```
source('mimicConfig.R')
source('trainTestSplit.R')
trainTestSplit(fnpt=fnptads.val, fntr=sprintf(fntr.tmp, rtrte), fnte=sprintf(fnte.tmp, rtrte), ptr=rtrte)
source('mimic_csv_gen.R')
```



