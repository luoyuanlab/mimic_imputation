R Code Dependencies:
Need the following libraries:
MICE
GPfit
hash
doParallel
foreach

Before running the code, configuration (e.g., setting up the data directory dnroot to where you unzip imputation_data.zip) needs to be done by adapting the code in mimicConfig_release.R Please remember to create a subdirectory named "micegp_log" under dnroot.

To train, run the following code directly:
source('mimicMICEGPParamEvalTr_release.R')
or better run as R markdown:
library(rmarkdown)
render('mimicMICEGPParamEvalTr_release.R')

This is a wrapper code calling various subroutines that generate the training data, mask missing values, and performs 3D-MICE imputation, each step is wrapped in its own R source file and should be self-explanatory.

In this wrapper code, nimp specifies how many MICE imputation to perform, ncores specifies how many cores to parallel the multiple imputations. nimp should be a multiply of ncores. You can set ncores to higher or lower values depending on the machine capacity. On a 20 core machine, this code should run in less than a day.