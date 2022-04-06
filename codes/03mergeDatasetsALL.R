#' Project: PR and ADRD medicare admission
#' Code: merge all datasets together for analyses
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
library(NSAPHutils)

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
beta <- read.csv(paste0(dir_data, "zipbeta_2001_2017.csv"))

head(ADRD_count)
ADRD_count[,zipcode_R:=int_to_string_zip(zipcode_R)]
head(covariates)
head(beta,20)
setDT(beta)
beta[,`:=`(X=NULL, zip=int_to_string_zip(zip))]

## 2. merge all datasets together ------
dt <- merge(ADRD_count, beta, by.x = c("year", "zipcode_R"), by.y = c("year", "zip"))
dt <- merge(dt, covariates, by.x = c("year", "zipcode_R"), by.y = c("year", "zip"))

write_fst(dt, paste0(dir_data, "final_dt.fst"))