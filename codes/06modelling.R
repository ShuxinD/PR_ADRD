## 0. set up ----
rm(list = ls())
gc()

setwd("/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/")
dir_data <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/data/"
dir_modresults <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/github_repo/results/model_details/"

library(mgcv)
library(data.table)
library(fst)

dt <- read_fst(paste0(dir_data,"final_dt.fst"), as.data.table = T)
dt <- na.omit(dt)

dt <- dt[1:50000, ]
gc()
dt_pcount <- dt[,p_count]

## 1. modelling ----
## 1.1 DID ----
cat("DID modelling... \n")

## beta+pm25 
mod <- gam(ADRDhosp ~ beta + pm25 + summer_tmmx + winter_tmmx + as.factor(year) + as.factor(zipcode) + offset(log(dt_pcount)),
           data = dt,
           family = quasipoisson(link = "log"))
tb <- summary(mod)$p.table
write.table(tb, file = paste0(dir_modresults, "DID_", "beta+pm25",".csv"))
cat(paste0("finish ", "beta+pm25", "\n"))

## only beta

## only pm25

## 1.2 GLMM ----
cat("GLMM modelling... \n")

## beta+pm25

## only beta

## only pm25
