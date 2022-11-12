library(tidycensus)
library(tidyverse)

# This function is created to get data from API of ACS and organize them
# created by BU MSSP BPDA group

# Before use the R function,run the following code and view the table of country
country_code <- pums_variables %>% filter(var_code == "POBP")
country_code <- unique(country_code[,c("val_label","val_min")])
colnames(country_code) <- c("country", "code")

# function to get the data for certain year
get_year_data <- function(year_need){
  year_data <- get_pums(
    variables = c("POBP","SEX", "AGEP","MAR","YOEP","CIT","ENG","SCHL","COW","INDP","OCCP","POVPIP","WAGP"),
    state = "all",
    survey = "acs1",
    year = year_need,
  )
  assign(paste("year",year_need,sep = ""),year_data,envir = globalenv())
}

# function to get the data for certain year and country
get_data <- function(country_need,year_need){
  # determine if the data for certain year has existed in environment
  if(!exists(paste("year",year_need,sep = ""))){
    get_year_data(year_need)
  }
  
  # get corresponding code for the country
  code_need <- country_code[grep(country_need,country_code$country,ignore.case = TRUE),"code"]
  code_need <- code_need$code
  
  if(length(code_need)!=1){
    stop("Country name is incorrect! Please check the country name")
  }
  
  # get certain data
  slice_row <- grep(code_need, get(paste("year",year_need,sep = ""))$POBP, ignore.case = T)
  pop_data <- get(paste("year",year_need,sep = "")) %>% slice(slice_row, preserve = FALSE)
  
  # organize the data
  output_data <- pop_data
  return(output_data)
}

# example
get_data("Brazil",2018)

