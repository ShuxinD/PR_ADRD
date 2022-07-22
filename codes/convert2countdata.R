#' Project: particle radiation and ADRD admission in Medicare FFS
#' Code: convert ADRD admission record from one-row-per-admission to one-row-per-zipcode count data
#' Input: medicare FFS adrd admission record
#' Output: "ADRD_zipcode_year.rds" as combination of zipcode and year
#' Author: Shuxin Dong

## 0. set up ----
rm(list = ls())
gc()

setwd("/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/")
dir_ADRDadmission <- "/nfs/home/S/shd968/shared_space/ci3_analysis/data_ADRDhospitalization/ADRDhospitalization_CCWlist/"
dir_dataout <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/data/"

library(data.table)
library(fst)
library(zipcodeR)

## 1. load Medicare FFS admission record ----
ADRDhosp <- NULL
for (i in 2000:2016) {
  adm_ <- read_fst(paste0(dir_ADRDadmission, "ADRD_", i,".fst"), as.data.table = T)
  ADRDhosp <- rbind(ADRDhosp, adm_)
  print(paste0("finish loading file:", "ADRD_", i,".fst"))
}
rm(adm_)
gc()
ADRDhosp <- unique(ADRDhosp)
colnames(ADRDhosp)
# [1] "QID"            "ADATE"          "DDATE"          "zipcode_R"      "DIAG1"          "DIAG2"         
# [7] "DIAG3"          "DIAG4"          "DIAG5"          "DIAG6"          "DIAG7"          "DIAG8"         
# [13] "DIAG9"          "DIAG10"         "AGE"            "Sex_gp"         "Race_gp"        "SSA_STATE_CD"  
# [19] "SSA_CNTY_CD"    "PROV_NUM"       "ADM_SOURCE"     "ADM_TYPE"       "Dual"           "year"          
# [25] "AD_primary"     "AD_any"         "AD_secondary"   "ADRD_primary"   "ADRD_any"       "ADRD_secondary"
ADRDhosp[,year:=year(ADATE)]
ADRDhosp[,zipcode_R:=normalize_zip(zipcode_R)]

## 2. aggregate to count data and save ----
count_dt <- ADRDhosp[,.N,by=c("year","zipcode_R")]

saveRDS(count_dt, paste0(dir_dataout, "ADRD_zipcode_year.rds"))
