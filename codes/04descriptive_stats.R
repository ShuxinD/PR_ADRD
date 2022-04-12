#' Project: PR and ADRD medicare admission
#' Code: Output descriptive stats
#' Input: "final_dt.fst"
#' Output: "table1.doc" "corrTable.pdf"
#' Author: Shuxin Dong 

## 0. set up ----
rm(list = ls())
gc()

library(fst)
library(data.table)
library(ggplot2)
library(tableone)
library(rtf)
library(corrplot)

setwd("/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/")
dir_data <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/data/"
dir_results <- "/nfs/home/S/shd968/shared_space/ci3_shd968/PR_ADRD/github_repo/results/descriptive/"

dt <- read_fst(paste0(dir_data,"final_dt.fst"), as.data.table = T)

IQR(dt$beta)
# 1.478348

