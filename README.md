# DACMI 2019 challenge on missing clinical data imputation
Generating the imputation dataset for the DACMI 2019 challenge <https://ewh.ieee.org/conf/ichi/2019/challenge.html>

If you don't want to run the code to regenerate the data, you can find the challenge data in the folder "dacmi_challenge_code_and_data".

The challenge participants' outputs can be found [here](https://www.dropbox.com/s/fx6r80lumo8cu2s/DACMI_results_submissions.zip?dl=0).

## R Code Dependencies
Need the following libraries:
```
mice
GPfit
hash
doParallel
foreach
```

## Generate per subject per admission lab data
Assume the following root data directory
```
dn = /home/shared_data/mimic3
```

Create the following directories
```
mkdir $dn/perSubj/LabEvents
mkdir $dn/perSubj/LabData
mkdir $dn/perSubj/LabView
mkdir $dn/perSubj/LabViewCase
mkdir $dn/imp_data
mkdir $dn/train_groundtruth
mkdir $dn/train_with_missing
mkdir $dn/test_groundtruth
mkdir $dn/test_with_missing
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

Create the following directories
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
source('mimic_csv_gen.R')
```

The convention for generated csv is that row correspondes to time, column correspondes to variable.

## Run 3D-MICE
Before running the code, configuration needs to be done by adapting and running the code in mimicConfig.R Please remember to create a subdirectory named "micegp_log" under ```$dn```.

To train, run the following code directly:
```
source('mimicMICEGPParamEvalTr.R')
```
or better run as R markdown:
```
library(rmarkdown)
render('mimicMICEGPParamEvalTr.R')
```

This is a wrapper code calling various subroutines that generate the training data, mask missing values, and performs 3D-MICE imputation, each step is wrapped in its own R source file and should be self-explanatory.

In this wrapper code, ```nimp``` specifies how many MICE imputation to perform, ```ncores``` specifies how many cores to parallel the multiple imputations. ```nimp``` should be a multiply of ```ncores```. You can set ```ncores``` to higher or lower values depending on the machine capacity. On a 20 core machine, this code should run in less than a day.

For your convenience, we also included the GP package ```gpml-matlab-v3.5-2014-12-08```, but we do not claim any rights or responsibility for that code.

### Citation
```
@article{10.1093/bib/bbab489,
    author = {Luo, Yuan},
    title = "{Evaluating the state of the art in missing data imputation for clinical data}",
    journal = {Briefings in Bioinformatics},
    year = {2021},
    month = {12},
    issn = {1477-4054},
    doi = {10.1093/bib/bbab489},
    url = {https://doi.org/10.1093/bib/bbab489},
}
```
