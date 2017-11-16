
# Load Packages -----------------------------------------------------------
library(tidyverse)
library(stringr)




# Main Series Table -------------------------------------------------------


# This link is for the series data
url <- "https://download.bls.gov/pub/time.series/ce/ce.series"

# Read in series data
series <- read_delim(url, delim = "\t")


# data_types
url <- "https://download.bls.gov/pub/time.series/ce/ce.datatype"

temp <- read_delim(url, delim = "\t")

series <- left_join(series, temp)

rm(temp)




# Join in MetaData --------------------------------------------------------


# industry
url <- "https://download.bls.gov/pub/time.series/ce/ce.industry"

temp <- read_delim(url, delim = "\t")

# Which columns match so that we can do a join
names(temp)[names(temp) %in% names(series)]

# Join temp to series df
series <- left_join(series, temp)

# Delete temp df
rm(temp)


# Seasonal
url <- "https://download.bls.gov/pub/time.series/ce/ce.seasonal"

temp <- read_delim(url, delim = "\t")

# Which columns match so that we can do a join
names(temp)[names(temp) %in% names(series)]

# This seems like a data error that needs to be corrected
names(temp)[1] <- "seasonal"

# Join temp to series df
series <- left_join(series, temp)

# Delete temp df
rm(temp)


# Supersector
url <- "https://download.bls.gov/pub/time.series/ce/ce.supersector"

temp <- read_delim(url, delim = "\t")

# Which columns match so that we can do a join
names(temp)[names(temp) %in% names(series)]

# Join temp to series df
series <- left_join(series, temp)

# Delete temp df
rm(temp)

rm(url)




# Filter to relevant series -----------------------------------------------

# Show all the column names in series tbl
names(series)

# Display unique values of key columns
unique(series$data_type_text)
unique(series$supersector_name)
unique(series$seasonal_text)

# Filter down to the primary series
my_series <- series %>%
             filter(data_type_text == "ALL EMPLOYEES, THOUSANDS",
                    supersector_name == "Total nonfarm",
                    seasonal_text == "Not Seasonally Adjusted")

# Convert series_id to a character string
my_series <- str_trim(as.character(my_series[1,1]))
























