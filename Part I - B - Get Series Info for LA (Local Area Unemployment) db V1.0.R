
# Load Packages -----------------------------------------------------------
library(tidyverse)
library(stringr)




# This link is for the series data
url <- "https://download.bls.gov/pub/time.series/la/la.series"

# Read in series data
series <- read_delim(url, delim = "\t")


# area
url <- "https://download.bls.gov/pub/time.series/la/la.area"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)



# area_type
url <- "https://download.bls.gov/pub/time.series/la/la.area_type"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)



# These area_maps table seems to be exactly the same as the area table
# # area_maps
# url <- "https://download.bls.gov/pub/time.series/la/la.areamaps"
# 
# temp <- read_delim(url, delim = "\t")
# 
# series <- left_join(series, temp)
# 
# rm(temp)



# JOIN DOESN'T MAKE SENSE
# # map_info
# url <- "https://download.bls.gov/pub/time.series/la/la.map_info"
# 
# temp <- read_delim(url, delim = "\t")
# 
# series <- left_join(series, temp) # This doesn't Work
# 
# rm(temp)




# measure
url <- "https://download.bls.gov/pub/time.series/la/la.measure"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)


# IF anything this should be joined to the actual data (not the series)
# period
# url <- "https://download.bls.gov/pub/time.series/la/la.period"
# 
# temp <- read_delim(url, delim = "\t")
# 
# series <- left_join(series, temp)
# 
# rm(temp)




<<<<<<< HEAD
# state_region_division
url <- "https://download.bls.gov/pub/time.series/la/la.state_region_division"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)
=======

>>>>>>> 3c11c15f4d46aa83c240ae98a91bc6556a971e1a





















