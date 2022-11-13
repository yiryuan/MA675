
# code of slice(age and mariage)
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

t1 <- age %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)

mariage <- brazil_pop_2018[,c("ST","MAR")]
mariage$group <- "Married"
mariage[(mariage$MAR == 2), "group"] <- "Widowed"
mariage[(mariage$MAR == 3), "group"] <- "Divorced"
mariage[(mariage$MAR == 4), "group"] <- "Separated"
mariage[(mariage$MAR == 5), "group"] <- "Never married or under 15"

t2 <- mariage %>% group_by(ST) %>% count(group) %>% pivot_wider(names_from = ST, values_from = n)
