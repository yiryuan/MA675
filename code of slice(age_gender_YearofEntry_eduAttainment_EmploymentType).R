library(tidyverse)
library(magrittr)
library(readxl)

# Age

age <- brazil_pop_2018[,c("ST","AGEP")]
age$group <- "age_0_to_4"

age[(age$AGEP < 9 & age$AGEP >= 5),"group"] <- "age_5_to_9"
age[(age$AGEP < 19 & age$AGEP >= 10),"group"] <- "age_10_to_19"
age[(age$AGEP < 24 & age$AGEP >= 20), "group"] <- "age_20_to_24"
age[(age$AGEP < 29 & age$AGEP >= 25), "group"] <- "age_25_to_29"
age[(age$AGEP < 34 & age$AGEP >= 30), "group"] <- "age_30_to_34"
age[(age$AGEP < 39 & age$AGEP >= 35), "group"] <- "age_35_to_39"
age[(age$AGEP < 44 & age$AGEP >= 40), "group"] <- "age_40_to_44"
age[(age$AGEP < 49 & age$AGEP >= 45), "group"] <- "age_45_to_49"
age[(age$AGEP < 54 & age$AGEP >= 50), "group"] <- "age_50_to_54"
age[(age$AGEP < 59 & age$AGEP >= 55), "group"] <- "age_55_to_59"
age[(age$AGEP < 64 & age$AGEP >= 60), "group"] <- "age_60_to_64"
age[(age$AGEP < 69 & age$AGEP >= 65), "group"] <- "age_65_to_69"
age[(age$AGEP < 74 & age$AGEP >= 70), "group"] <- "age_70_to_74"
age[(age$AGEP < 79 & age$AGEP >= 75), "group"] <- "age_75_to_79"
age[(age$AGEP < 84 & age$AGEP >= 80), "group"] <- "age_80_to_84"
age[(age$AGEP >= 85), "group"] <- "age_85_over"

t <- age %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)


# Sex

sex <- brazil_pop_2018[,c("ST","SEX")]
sex$group <- "male"
sex[(sex$SEX=="2"),"group"] <- "female"

tsex <- sex %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)

for ( i in 1:dim(tsex)[1]){
  for (j in 2:dim(tsex)[2]){
    if (is.na(tsex[i,j])==TRUE){tsex[i,j] = 0}
  }
}


# year of entry

yoe <- brazil_pop_2018[,c("ST", "YOEP")]
yoe$group <- "Entered US in 2000 or later"
yoe[(yoe$YOEP < 2000 ),"group"] <- " Entered US before 2000"

tyoe <- yoe %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)

for ( i in 1:dim(tyoe)[1]){
  for (j in 2:dim(tyoe)[2]){
    if (is.na(tyoe[i,j])==TRUE){tyoe[i,j] = 0}
  }
}


# Educational Attainment

edu <- brazil_pop_2018[,c("ST", "SCHL")]
edu$group <- "Less than high school"
edu[(edu$SCHL == "16" | edu$SCHL == "17" ),"group"] <- "High School Graduate/GED or Alternative Credential"
edu[(edu$SCHL == "18" 
     | edu$SCHL == "19" 
     | edu$SCHL == "20" ),"group"] <- "Some College/Associate Degree"
edu[(edu$SCHL == "21" 
     | edu$SCHL == "22" 
     | edu$SCHL == "23" 
     | edu$SCHL == "24"),"group"] <- "Bachelors Degree or Higher"

tedu <- edu %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)

for ( i in 1:dim(tedu)[1]){
  for (j in 2:dim(tedu)[2]){
    if (is.na(tedu[i,j])==TRUE){tedu[i,j] = 0}
  }
}

# employment type

empl <- brazil_pop_2018[,c("ST","COW")]
empl$group <- NULL

empl[(empl$COW == '1' | empl$COW == '2'),"group"] <- "Private Wage and Salary Workers"
empl[(empl$COW == "6" | empl$COW == "7"),"group"] <- "Self employed Not incorporated"
empl[(empl$COW == "8"),"group"] <- "Self employed Incorporated"
empl[(empl$COW == "9"),"group"] <- "Unemployment"
empl[(empl$COW == '3' | empl$COW == '4' | empl$COW == '5'),"group"] <- "Government Workers"

templ <- empl %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)
templ %<>% filter(!row_number() %in% 2)
for ( i in 1:dim(templ)[1]){
  for (j in 2:dim(templ)[2]){
    if (is.na(templ[i,j])==TRUE){templ[i,j] = 0}
  }
}

