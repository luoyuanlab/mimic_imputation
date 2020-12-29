"""
This code converts raw MIMIC3 .csv files into ready-to-process data
Yuan - 01/22/2016 creation
"""

__author__= """Yuan Luo (yuan.hypnos.luo@gmail.com)"""
__revision__="0.5"
import csv

#! /usr/bin/python;
def split_mimic3(fn='/share/fsmresfiles/mimic3/CHARTEVENTS.csv', dnout='/share/fsmresfiles/mimic3/perSubj/LabEvents', pref='le'):
    f = open(fn, 'rb')
    dr = csv.reader(f)
    ln = 0; sid_old = ''
    sids = {}
    for row in dr:
        ln += 1
        if ln == 1:
            header = row
        else:
            sid = row[1]
            if sid != sid_old:
                if sid_old != '':
                    fout.close()
                fnout = '%s/%s_%s.csv' % (dnout, pref, sid)
                if sids.has_key(sid):
                    ## print('%s multi occurrence %s after %s at line %d' % (sid, row[0], sid_old, ln))
                    fout = open(fnout, 'ab')
                else:
                    if len(sids) % 1000 == 0:
                        print('processed %d subjects' % (len(sids)))
                    fout = open(fnout, 'wb')
                fcsv = csv.writer(fout, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                if not sids.has_key(sid):
                    fcsv.writerow(header)
                sids[sid] = 1
            fcsv.writerow(row)
            sid_old = sid
    fout.close()
    return;
