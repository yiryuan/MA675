# What is this?
The project is created by MSSP 2022 FALL BPDA group, and main goal for the project it to get the data from ACS API

# How to use it?
## Households
1.run get_households_data.R
2.run the example(run_example_households.R) and figure out how the function works.
3.change variables you need, run get_households_2005-2019.R and download all data in xlsx.

# Package Used
### tidyverse
### tidycensus
### dplyr
### tidyr

# Update Record

## Nov.18 2022
1. Finish the function to get households data for certain year and country -- Jing Wu
2. Upload run example(run_example_households.R) and the script of download households data(get_households_2005-2019.R) -- Jing Wu

## Nov.17 2022
1. Debugging the code from our clients 
2. Added the missing variable and started to rewirte the clean part -- Yirong Yuan
3. finished new pulled and clean codes for population's variables -- Yirong Yuan

## Nov.16 2022
1. Got the feedback from clients and figured out the problem of the data -- Yirong Yuan

## Nov.15 2022
1. Double-check the code and talked with supervisor -- Yirong Yuan

## Nov.14 2022
1. Finished data clean and tidy work -- Yirong Yuan
2. Exported the sample data and noticed the population is much smaller than that the client provided. -- Yirong Yuan

## Nov.13 2022
1.Started to clean the household data -- Yirong Yuan

## Nov.12 2022
1. Change the logic of the function. -- Jing Wu
2. Finish the code of getting the data. -- JIng Wu
3. Finish slicing the data of 2018 Brazil population. -- Jingyu Liang
4. Continued  cleaning  population data -- Yirong Yuan

## Nov.11 2022

1. Preliminary design the framework function -- Jing Wu
2. Tried to use the function I created to get data from API, while failed. -- Jing Wu
3. Started to wirte a standard data clean code -- Yirong Yuan
4. Started to clean the population data which was pulled from PUMS -- Yirong Yuan


## Nov.10 2022
1.Studied the variables of PUMS (tidycensus) in r and figured out which variables need to be selected-- Yirong Yuan

2.Wrote  r codes to pull data from PUMS (Census)--Yirong Yuan
