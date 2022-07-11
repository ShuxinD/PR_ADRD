#' Project: PR and ADRD medicare admission
#' Code: merge all datasets together for analyses, and deal with all missingness
#' Input: all datasets
#' Output: "final_dt.fst"
#' Author: Shuxin Dong 

## 0. setup ----
rm(list = ls())
gc()

setwd("/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/")
dir_data <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/data/"

library(data.table)
library(fst)
library(zipcodeR)

## 1. load covariates ----
dir_covariates <- "~/shared_space/ci3_analysis/whanhee_revisions/data/confounders/"
f <- list.files(dir_covariates, pattern = "\\.csv", full.names = TRUE)
# temp <- fread(f[1], drop = 1)
# colnames(temp)
myvars <- c("ZIP", "year", "zcta", "poverty", "popdensity", "medianhousevalue", "pct_blk", "medhouseholdincome", "pct_owner_occ", "hispanic", "education", "smoke_rate", "mean_bmi", "pm25.one_year_lag")
covariates <- rbindlist(lapply(f[2:17], 
                               fread,
                               select = myvars))
# summary(all_covariates)
unique(covariates)
covariates[,ZIP:=normalize_zip(ZIP)][]

## 2. load other datasets ----
ADRD_count <- readRDS(paste0(dir_data,"ADRD_zipcode_year.rds"))
pcount <- readRDS(paste0(dir_data,"medicare_enrollee_count.rds"))
load(paste0(dir_data,"zip_annual_SD.RData"))
beta <- zip_annual
rm(zip_annual)

gc()

## 3. prepare all datasets ----
## ADRD hospitalization
summary(ADRD_count)
ADRD_count[,zipcode_R:=normalize_zip(zipcode_R)] # just in case
names(ADRD_count)
names(ADRD_count) <- c("year", "zipcode", "ADRDhosp")

## all covariates
summary(covariates)
head(covariates)
names(covariates)[1:2] <- c("zipcode", "year")

head(beta,20)
setDT(beta)
beta[,`:=`(State=NULL, ZIPCODE=int_to_string_zip(ZIPCODE))]
names(beta) <- c("zipcode", "beta", "year")

head(pop_count)
names(pop_count) <- c("year", "zipcode", "p_count")

## 2. merge all datasets together ------
dt <- merge(pop_count, ADRD_count, by = c("year", "zipcode"), all.x = T)
dt[is.na(dt)] <- 0

dt <- merge(dt, covariates, by = c("year", "zipcode"), all.x = T)

dt[,year_prev:=year-1][]
dt <- merge(dt, beta, by.x = c("year_prev", "zipcode"), by.y = c("year","zipcode"), all.x = T)

dt <- dt[year>=2002 & year <=2016,]

dt # 613785

na.omit(dt) # 379531

write_fst(na.omit(dt), paste0(dirg_data, "final_dt.fst"))
