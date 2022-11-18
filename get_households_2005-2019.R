# R script to download all data and save them as xlsx

# To save time for downloading data in same year,
# get_households() will add variables into the global environment,
# you may consider run all countries for same year in one time,
# then remove corresponding data in environment

library(tidycensus)
library(tidyverse)
library(xlsx)

list_year <- 2005:2008 # year you need
list_country <- c("Paraguay",
                  "Peru") # country you need

for(i in 1:length(list_year)){
  for(j in 1:length(list_country)){
    data <- get_households_data(list_country[j],list_year[i])
    file_name <- paste("households",list_country[j],list_year[i],"xlsx",sep = ".")
    write.xlsx(data, file_name)
    }
  rm(list=paste("households_year",list_year[i],sep = ""))
}

