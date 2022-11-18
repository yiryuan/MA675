# running example
# To save time for downloading data in same year,
# get_households() will add variables into the global environment,
# you may consider run all countries for same year in one time,
# then remove corresponding data in environment

# example1
data1 <- get_households_data("Brazil",2018)
data2 <- get_households_data("Colorado",2018) # Don't need download twice

# example2
data1 <- get_households_data("Brazil",2016) # Not same year, download twice
data2 <- get_households_data("Brazil",2017) # Not same year, download twice