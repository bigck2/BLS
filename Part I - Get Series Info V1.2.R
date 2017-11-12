


# Load Packages -----------------------------------------------------------
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




# Clean up ----------------------------------------------------------------

# Remove trailing spaces from series id
series$series_id <- str_trim(series$series_id)



# Get Relevant Series -----------------------------------------------------

my_series <- series %>%
             filter(data_type_code == "01",
                    area_code == "00000",
                    supersector_code == "00",
                    seasonal == "U")

some_series <- as.character(my_series$series_id)



# Join the states back
test <- left_join(the_data, series)

test <- filter(test, date == max(date))



ggplot(data = test, aes(x = date, y = value, color = state_name, fill = state_name)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(labels = scales::comma)















