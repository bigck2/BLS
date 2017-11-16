


bls_get_single_series <- function(my_series_id){

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

# Need to create a character string of JSON for a signle series
# NOTE this was the confusing part. The API wants the seriesid to be surrounded with []
# even for a single series, but the other parameters it does NOT want surrounded by []
my_payload <- paste0("{\"seriesid\":[\"", my_series_id, "\"],
                     \"startyear\":\"", my_start_year, "\",
                     \"endyear\":\"", my_end_year, "\",
                     \"registrationkey\":\"", my_registration_key, "\"}" )

# Send the request with httr::POST()
r <- POST(url,
          body = my_payload,
          add_headers("content-type" = "application/json"))

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

}
















