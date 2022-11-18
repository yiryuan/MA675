library(tidycensus)
library(tidyverse)

# This function is created to get data from API of ACS and organize them
# created by BU MSSP BPDA group

# Before using the R function,log into the tidycensus, and run the following code and view the table of country
country_code <- pums_variables %>% filter(var_code == "POBP")
country_code <- unique(country_code[,c("val_label","val_min")])
colnames(country_code) <- c("country", "code")

# function to get the data for certain year
get_year_households_data <- function(year_need){
  st_list <-c('AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY')
  
  #households variables needed, after 2008
  variable_list_h <- c("RT","SERIALNO","ST","SPORDER","WGTP","POBP","CIT","TEN","HHT","POVPIP","OCPIP","GRPIP","BDSP","NP","HINCP","FINCP")
  
  #households variables needed, in 2005-2007 number of bedroom variables: BDS
  variable_list_h_05_07 <- c("RT","SERIALNO","ST","SPORDER","PWGTP","WGTP","POBP","CIT","TEN","HHT","POVPIP","OCPIP","GRPIP","BDS","NP","HINCP","FINCP")
  
  # select variables needed for the year
  if(year_need < 2008){
    variable_list <- variable_list_h_05_07
  }else if(year_need >= 2008){
    variable_list <- variable_list_h
  }
  
  # get the data for states we need and combine them
  households_df <- data.frame()
  for (state_index in st_list) {
    temp_file <- get_pums(variables = variable_list,
                                variables_filter = list(SPORDER = 1),
                                survey = 'acs1', state = state_index, year = year_need, show_call = T)
    households_df <- rbind(households_df,temp_file)
  }
  assign(paste("households_year",year_need,sep = ""), households_df, envir = globalenv())
}

get_households_data <- function(country_need,year_need){
  # get corresponding code for the country
  code_need <- country_code[grep(country_need,country_code$country,ignore.case = TRUE),"code"]
  code_need <- code_need$code
  
  if(length(code_need)!=1){
    stop("Country name is incorrect! Please check the country name")
  }
  
  # determine if the data for certain year has existed in environment
  if(!exists(paste("households_year",year_need,sep = ""))){
    get_year_households_data(year_need)
  }
  
  # get certain data
  households_df <- get(paste("households_year",year_need,sep = "")) %>% filter(POBP == code_need & (CIT == "4" | CIT == "5"))
  
  # organize the data
  # organize the data
  # put all variable names into lower case
  colnames(households_df) <- tolower(colnames(households_df))
  
  # convert columns into numeric
  households_df[,5:17] <- sapply(households_df[,5:17],as.numeric)
  
  # create an empty dataframe to save the result of slice and count
  summary_df <- data.frame()
  
  # deal with variable 15
  households_df <- households_df %>% mutate(type = "15_Householder")
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 16
  households_df <- households_df %>% mutate(type = case_when(ten==1 | ten==2 ~ '16.1_Ownership: Owner Occupied Unit',
                                                             ten==3 | ten==4 ~ '16.2_Ownership: Renter Occupied Unit'
  ))
  
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 17
  households_df$hht <- as.integer(households_df$hht)
  households_df <- households_df %>%  mutate(type = case_when(hht==1|hht==2|hht==3 ~ '17_Family Household: Total Family Households'))
  
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 18
  households_df$povip <- households_df$povpip
  households_df <- households_df %>% mutate(type = case_when((povpip>=0 & povpip<=100&(hht==1|hht==2|hht==3)) ~ '18.1_Family Poverty: Families Below Poverty',
                                                             (povpip>100 &(hht==1|hht==2|hht==3)) ~ '18.2_Family Poverty: Family Above Poverty'))
  
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 19
  households_df <- households_df %>% mutate(type = case_when(ocpip<20 & (ten==1 | ten==2)~ '19.1_Monthly Owner Costs: Under 20% of HH Income',
                                                             ocpip>=20 & ocpip<25 & (ten==1 | ten==2) ~ '19.2_Monthly Owner Costs: 20 to 25% of HH Income',
                                                             ocpip>=25 & ocpip<30 & (ten==1 | ten==2) ~ '19.3_Monthly Owner Costs: 25 to 30% of HH Income',
                                                             ocpip>=30 & ocpip<35 & (ten==1 | ten==2) ~ '19.4_Monthly Owner Costs: 30 to 35% of HH Income',
                                                             ocpip>=35 & (ten==1 | ten==2) ~ '19.5_Monthly Owner Costs: 35%+ of HH Income'))
  
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 20
  households_df <- households_df %>% mutate(type = case_when(grpip<15 &(ten==3 | ten==4) ~ '20.1_Monthly Gross Rent: Under 15% of HH Income',
                                                             grpip>=15 & grpip<20&(ten==3 | ten==4) ~ '20.2_Monthly Gross Rent: 15% to 20% of HH Income',
                                                             grpip>=20 & grpip<25&(ten==3 | ten==4) ~ '20.3_Monthly Gross Rent: 20% to 25% of HH Income',
                                                             grpip>=25 & grpip<30&(ten==3 | ten==4) ~ '20.4_Monthly Gross Rent: 25% to 30% of HH Income',
                                                             grpip>=30 & grpip<35&(ten==3 | ten==4) ~ '20.5_Monthly Gross Rent: 30% to 35% of HH Income',
                                                             grpip>=35&(ten==3 | ten==4) ~ '20.6_Monthly Gross Rent: 35%+ of HH Income'))
  
  summary_df<- summary_df%>% bind_rows ( 	
    households_df%>% select(st, type, wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  
  # deal with variable 21
  if (year_need >= 2008){
    households_df <- households_df %>% mutate(type = case_when(np/bdsp>1 ~ '21.1_Overcrowding: Crowded Units', 
                                                               np/bdsp<=1 ~ '21.2_Overcrowding: Not Crowded Units'))
    summary_df<- summary_df %>% bind_rows (
      households_df%>% select(st, type ,wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  }else if (year_need < 2008){
    households_df <- households_df %>% mutate(type = case_when(np/bds > 1 ~ '21.1_Overcrowding: Crowded Units', 
                                                               np/bds <= 1 ~ '21.2_Overcrowding: Not Crowded Units'))
    summary_df<- summary_df %>% bind_rows (
      households_df %>% select(st, type ,wgtp)%>% group_by(st,type)%>%summarise(count = sum(wgtp)))
  }
  
  # deal with variable 22
  households_df <- households_df %>% 
    mutate(type = case_when( hht>=1 & hht<=7 ~ '22_Median Household Income: Median Household Income'))
  
  summary_df<- summary_df%>% bind_rows (
    households_df%>% select(st, type, hincp,wgtp)%>% group_by(st,type)%>%
      summarise(count = median(rep(hincp, wgtp)))%>% 
      select(st, type, count))
  
  # deal with variable 23
  households_df <- households_df %>% 
    mutate(type = case_when(hht==1|hht==2|hht==3 ~ '23_Median Family Income: Median Family Income'))
  
  summary_df<- summary_df%>% bind_rows (
    households_df%>% select(st, type, fincp,wgtp)%>% group_by(st,type) %>%
      summarise(count = median(rep(fincp, wgtp)))%>% 
      select(st, type, count))
  
  # organize the data
  summary_df$st <- as.integer(summary_df$st)
  summary_tidy <- summary_df %>% filter(!is.na(type)) %>% pivot_wider(
    names_from = st, values_from = count,names_sort = TRUE
  ) %>% arrange(type)
  
  # turn all NA into 0
  summary_tidy[is.na(summary_tidy)] <- 0
  
  # separate the type columns
  summary_tidy <- summary_tidy %>% separate(col=type,
                             into = c("index_1", "Type"),
                             sep = "_",
                             fill = "right")
  
  return(summary_tidy)
}