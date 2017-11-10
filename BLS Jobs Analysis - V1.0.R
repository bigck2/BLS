

library(tidyverse)

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






















