library(hash)
source('mimicConfig.R')
source('labView.R')
subjs = read.csv(sprintf('%s/PATIENTS.csv', dn))
suids = unique(subjs$SUBJECT_ID)
dups = hash()
for (suid in suids) {
    cv = labView(suid, dups)
}
cat(paste(keys(dups), collapse="\n"), file='lvgen_duplicate.txt')
