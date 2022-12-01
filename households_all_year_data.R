# This is a script to load data for certain country for all year
library(readxl)
library(gtools)
library(tidyverse)

# the place you save the data
dir_file <- "/Users/willowwu/Documents/households data/"
country <- "Paraguay"
outputdata = data.frame()

for (dirname in dir(dir_file)){ 
  
  # get the dir
  mydir <- paste0(dir_file,dirname)
  
  # find certain file
  filename_list <- strsplit(dirname, split = ".",fixed=T)
  
  if (filename_list[[1]][2] == country){
    data <- read_xlsx(mydir)
    data$year <- filename_list[[1]][3]
  outputdata <- bind_rows(outputdata,data)
    }
}

outputdata[is.na(outputdata)] <- 0
outputdata <- outputdata[,2:dim(outputdata)[2]]
col_digit <- grep("^[a-zA-Z]", colnames(outputdata),value = TRUE,invert = TRUE)
col_undigit <- grep("^[a-zA-Z]", colnames(outputdata),value = TRUE,invert = FALSE)
outputdata <- outputdata[,c(col_undigit,mixedsort(col_digit))]


