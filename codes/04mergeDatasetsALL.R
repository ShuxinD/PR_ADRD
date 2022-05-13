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

int_to_string_zip <- function(zipcode_number){
  zip_raw <- as.character(zipcode_number)
  zip_raw <- ifelse(nchar(zip_raw)<5, paste0("0",zip_raw), zip_raw)
  zip_raw <- ifelse(nchar(zip_raw)<5, paste0("0",zip_raw), zip_raw)
  zip_raw <- ifelse(nchar(zip_raw)<5, paste0("0",zip_raw), zip_raw)
  zip_raw <- ifelse(nchar(zip_raw)<5, paste0("0",zip_raw), zip_raw)
  return(zip_raw)
}

## 1. load datasets -------------------------------------
ADRD_count <- readRDS(paste0(dir_data,"ADRD_zipcode_year.rds"))
covariates <- read_fst(paste0(dir_data, "all_covariates.fst"))
pop_count <- readRDS(paste0(dir_data,"medicare_enrollee_count.rds"))
load(paste0(dir_data,"zip_annual_SD.RData"))
beta <- zip_annual
rm(zip_annual)
gc()

head(ADRD_count)
ADRD_count[,zipcode_R:=int_to_string_zip(zipcode_R)]
names(ADRD_count)
names(ADRD_count) <- c("year", "zipcode", "ADRDhosp")

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
