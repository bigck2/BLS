

# Load Packages -----------------------------------------------------------
library(jsonlite)
library(httr)
library(stringr)
library(lubridate)
library(tidyverse)


# Base Parameters ---------------------------------------------------------

# The BLS URL
url <- "https://api.bls.gov/publicAPI/v2/timeseries/data/"

my_start_year <- as.character("2010") # Just specifying to make these characters
my_end_year <- as.character("2017") # Just specifying to make these characters
my_registration_key <- "416fd9b4813e4a50a808441c4a16d5c9"



# Single Series -----------------------------------------------------------

my_series_id <- "SMU48191240000000001"

# Need to create a character string of JSON for a signle series
# NOTE this was the confusing part. The API wants the seriesid to be surrounded with []
# even for a single series, but the other parameters it does NOT want surrounded by []
my_payload <- paste0("{\"seriesid\":[\"", my_series_id, "\"],
                     \"startyear\":\"", my_start_year, "\",
                     \"endyear\":\"", my_end_year, "\",
                     \"registrationkey\":\"", my_registration_key, "\"}" )

# writeLines(my_payload)

# Send the request with httr::POST()
r <- POST(url,
          body = my_payload,
          add_headers("content-type" = "application/json"))

rm(url, my_payload, my_series_id, my_start_year, my_end_year, my_registration_key)




# Multiple Series --------------------------------------------------------------------

# A list of some BLS Series
some_series <- c("SMS02112600000000001", "SMS02218200000000001", "SMS04223800000000001", 
                 "SMS04294200000000001", "SMS04380600000000001", "SMS04391400000000001", 
                 "SMS04460600000000001", "SMS04497400000000001", "SMU02112600000000001", 
                 "SMU02218200000000001", "SMU04223800000000001", "SMU04294200000000001", 
                 "SMU04380600000000001", "SMU04391400000000001", "SMU04434200000000001", 
                 "SMU04460600000000001", "SMU04497400000000001")

# Create list object to hold series of interest and parameters (years, registrationkey)
my_payload <- list(seriesid = some_series,
                   startyear = my_start_year,
                   endyear = my_end_year, 
                   registrationkey = my_registration_key)

# Convert list into JSON with jsonlite::toJSON()
# We need to specify auto_unbox to TRUE
my_payload <- toJSON(my_payload, auto_unbox = TRUE, pretty = TRUE)

# Now we can access the BLS API
r <- POST(url,
          body = my_payload,
          add_headers("content-type" = "application/json"))

rm(url, my_payload, some_series, my_start_year, my_end_year, my_registration_key)





# Processing Request ------------------------------------------------------

# These two lines check to make sure the status is 200 and eveything went OK
http_status(r)

status_code(r) == 200

# We can examine the headers
# headers(r)



# Extracting Data ---------------------------------------------------------

# We will use the content function to extract the actual data from the BLS Api
# This function call will still return a nested list which requires some manipulation
my_list <- fromJSON(content(r, as = "text"))

# Create a character vector or series id's
my_series <- my_list[["Results"]][["series"]][["seriesID"]]

# Determine how many rows are in each data frame
my_rows <- nrow(my_list[["Results"]][["series"]][["data"]][[1]])

# This bind_rows will combine a list of data frames into one data frame
the_data <- dplyr::bind_rows(my_list[["Results"]][["series"]][["data"]])

# We need to add labels to the_data which specifies the series
the_data$series_id <- rep(x = my_series, each = my_rows)

rm(my_list, my_series, my_rows, r)




# Process data ------------------------------------------------------------

# Drop the "M" character from the period column
months <- str_replace(string = the_data$period, pattern = "M", replacement = "")

# Create a vector of date strings
date_strings <- paste(months, "01", the_data$year, sep = "/")

# convert to actual dates with lubridate::mdy()
the_data$date <- mdy(date_strings)

# Select only the relevant columns
the_data <- the_data %>%
  select(series_id, date, value) %>%
  mutate(value = as.numeric(value) * 1000) # Probably best to mutliply by 1,000 here

rm(months, date_strings)




# Basic Plotting ----------------------------------------------------------

ggplot(data = the_data, aes(x = date, y = value)) +
  geom_point(size = 3, color = "dodgerblue") +
  geom_line(color = "dodgerblue") +
  labs(y = "Employment", 
       x = NULL,
       title = "Some Series Desctiption and Name",
       caption = "Buruea of Labor Statistics") +
  scale_y_continuous(labels = scales::comma)












