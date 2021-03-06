#' Project: particle radiation and ADRD admission in Medicare FFS
#' Code: get medicare enrollee count by year by zcta
#' Input: medicare denominator files
#' Output: "medicare_enrollee_count.rds" as combination of zipcode and year
#' Author: Shuxin Dong

## 0. setup ----
rm(list = ls())
gc()

library(fst)
library(data.table)
library(zipcodeR)

dir_denominator <- "/nfs/home/S/shd968/shared_space/ci3_health_data/medicare/mortality/1999_2016/wu/cache_data/merged_by_year_v2/"
dir_dataout <- file.path(getwd(),"data")

## load denominator files---
f <- list.files(dir_denominator, pattern = "\\.fst", full.names = TRUE)
# example <- read_fst(f[1])
# names(example)
# [1] "zip"                          "year"                         "qid"                         
# [4] "dodflag"                      "bene_dod"                     "sex"                         
# [7] "race"                         "age"                          "hmo_mo"                      
# [10] "hmoind"                       "statecode"                    "latitude"                    
# [13] "longitude"                    "dual"                         "death"                       
# [16] "dead"                         "entry_age"                    "entry_year"                  
# [19] "entry_age_break"              "followup_year"                "followup_year_plus_one"      
# [22] "pm25_ensemble"                "pm25_no_interp"               "pm25_nn"                     
# [25] "ozone"                        "ozone_no_interp"              "zcta"                        
# [28] "poverty"                      "popdensity"                   "medianhousevalue"            
# [31] "pct_blk"                      "medhouseholdincome"           "pct_owner_occ"               
# [34] "hispanic"                     "education"                    "population"                  
# [37] "zcta_no_interp"               "poverty_no_interp"            "popdensity_no_interp"        
# [40] "medianhousevalue_no_interp"   "pct_blk_no_interp"            "medhouseholdincome_no_interp"
# [43] "pct_owner_occ_no_interp"      "hispanic_no_interp"           "education_no_interp"         
# [46] "population_no_interp"         "smoke_rate"                   "mean_bmi"                    
# [49] "smoke_rate_no_interp"         "mean_bmi_no_interp"           "amb_visit_pct"               
# [52] "a1c_exm_pct"                  "amb_visit_pct_no_interp"      "a1c_exm_pct_no_interp"       
# [55] "tmmx"                         "rmax"                         "pr"                          
# [58] "cluster_cat"                  "fips_no_interp"               "fips"                        
# [61] "summer_tmmx"                  "summer_rmax"                  "winter_tmmx"                 
# [64] "winter_rmax" 

myvars <- c("qid", "year", "zip", "hmo_mo", "hmoind")
dt <- rbindlist(lapply(f[2:18],
                       read_fst,
                       columns = myvars,
                       as.data.table = TRUE))
gc()

## 2. subset and count ---
# dt_subset <- unique(dt[hmo_mo==0,.(qid, year, zip)])
dt_subset <- unique(dt[,.(qid, year, zip)])
final_dt <- dt_subset[,.N, by = c("year", "zip")]
final_dt[,zip:=normalize_zip(zip)]
gc()

head(final_dt)
summary(final_dt)
saveRDS(final_dt, paste0(dir_dataout, "medicare_enrollee_count.rds"))
