library(tidycensus)
library(tidyverse)

# This function is created to get data from API of ACS and organize them
# created by BU MSSP BPDA group

# Before use the R function,run the following code and view the table of country

country_code <- pums_variables %>% filter(var_code == "POBP")
country_code <- unique(country_code[,c("val_label","val_min")])
colnames(country_code) <- c("country", "code")

# function to get the data for certain year
get_data <- function(country_need,year_need){
  
  # get corresponding code for the country
  code_need <- country_code[grep(country_need,country_code$country,ignore.case = TRUE),"code"]
  code_need <- code_need$code
  
  # get certain data
  pop_data <- get_pums(
    variables = c("POBP","SEX", "AGEP","MAR","YOEP","CIT","ENG","SCHL","COW","INDP","OCCP","POVPIP","WAGP"),
    state = "all",
    survey = "acs1",
    year = year_need,
    variables_filter = list(POBP = as.integer(code_need))
    )
  
  # organize the data
  output_data <- pop_data
  return(output_data)
}

get_data("Brazil",2018) # API call has errors
