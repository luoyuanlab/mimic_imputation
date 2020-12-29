"""
Parallel scripts
yluo - 01/15/2019 creation

"""

#! /usr/bin/python;
import pandas as pd
import math
import re

def gpmlScript(fnscript='./gpmlMIMICScript.sh', fn='/home/shared_data/mimic3/lvcase.csv', fncf='mimicConfig', bsize=2000):
    ptads = pd.read_csv(fn, header=None)
    n = ptads.shape[0]
    dn = re.sub('/[^/]*$', '', fn)
    fscript = open(fnscript, 'w')
    for i in range(0,int(math.ceil((n+0.)/bsize))):
        fscript.write('matlab -nodisplay -r "gpTensorImpValidation(%d,%d,\'%s\')" 2>&1 > %s/gpml/log/imp%d.log&\n' % (i+1, bsize, fncf, dn, i+1))
    fscript.close()
    subprocess.call("chmod a+x %s" % (fnscript), shell=True)
    return;
    
