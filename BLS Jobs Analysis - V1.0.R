

library(tidyverse)
library(stringr)

# Parent Directory
# https://download.bls.gov/pub/time.series/sm/



# This link is for the series data
url <- "https://download.bls.gov/pub/time.series/sm/sm.series"

# Read in series data
series <- read_delim(url, delim = "\t")


# Link with descriptions of data types:
url <- "https://download.bls.gov/pub/time.series/sm/sm.data_type"

data_types <- read_delim(url, delim = "\t")

series <- left_join(series, data_types)

rm(data_types)


# Industry
url <- "https://download.bls.gov/pub/time.series/sm/sm.industry"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)



# State
url <- "https://download.bls.gov/pub/time.series/sm/sm.state"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)





# Supersector
url <- "https://download.bls.gov/pub/time.series/sm/sm.supersector"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)


# Area
url <- "https://download.bls.gov/pub/time.series/sm/sm.area"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp, url)




# Data --------------------------------------------------------------------

url <- "https://download.bls.gov/pub/time.series/sm/sm.data.0.Current"

big_data <- read_delim(url, delim = "\t")

big_data <- big_data %>%
            mutate(series = str_replace_all(string = series_id, 
                                            pattern = " ", 
                                            replacement = ""))




# Example to get Dallas ---------------------------------------------------



# This is the ID for the 
# All EMployees, In Thousands
# Total Nonfarm
# Dallas-Plano-Irving, TX Metroplitan Division
# series
my_series <- "SMU48191240000000001"

my_data <- big_data %>%
            filter(series == my_series)















