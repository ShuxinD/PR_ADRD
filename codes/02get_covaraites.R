#' get all the covaraites from the denominator files

library(fst)
library(data.table)
dir_all <- "/nfs/home/S/shd968/shared_space/ci3_shd968/medicareADRD/data/"

dt <- read_fst(paste0(dir_all, "ADRDcohort_clean.fst"), as.data.table = T)
names(dt)

dt[,`:=`(qid=NULL, sex=NULL, race=NULL, age=NULL, dual=NULL, statecode=NULL, dead=NULL, no2=NULL, ozone=NULL, ozone_summer=NULL, ox=NULL, entry_age=NULL, entry_age_break=NULL, race_collapsed=NULL, region=NULL, firstADRDyr=NULL)]

dt <- unique(dt)
dir_dataout <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/data/"
write_fst(dt, paste0(dir_dataout, "all_covaraites.fst"))

