 

# Load Packages -----------------------------------------------------------
library(jsonlite)
library(httr)
library(stringr)
library(lubridate)
library(tidyverse)


# The BLS URL
url <- "https://api.bls.gov/publicAPI/v2/timeseries/data/"

my_start_year <- as.character("2010") # Just specifying to make these characters
my_end_year <- as.character("2017") # Just specifying to make these characters
my_registration_key <- "416fd9b4813e4a50a808441c4a16d5c9"





# Longer series -----------------------------------------------------------

# Read in a CSV file with a list of series
some_series <- read_csv("one hundred series.csv") %>%
               pull(series_id)    # this is to convert the tbl column into a character vector

# How many series do we have here?
my_length <- length(some_series)

# # How many groups of 50 can we make evenly?
# my_length %/% 50
# # How many elements will remain left over?
# my_length %% 50

# Total number of groups we need
my_groups <- (my_length %/% 50 ) + ifelse(my_length %% 50 > 0 , 1, 0)








# Create an empty list to store the_data df's
data_list <- vector("list", my_groups)


# This loop will create the character vectors in groups of 50 (or fewer)
for (i in 1:my_groups){
  
  my_series <- some_series[seq(from = (i * 50) - 49, to = i * 50)]
  
  my_series <- my_series[!is.na(my_series)]


# Create list object to hold series of interest and parameters (years, registrationkey)
  my_payload <- list(seriesid = my_series,
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


# We will use the content function to extract the actual data from the BLS Api
# This function call will still return a nested list which requires some manipulation
  my_list <- fromJSON(content(r, as = "text"))

# Create a character vector or series id's
  my_series_ids <- my_list[["Results"]][["series"]][["seriesID"]]

# Determine how many rows are in each data frame
  my_rows <- nrow(my_list[["Results"]][["series"]][["data"]][[1]])

# This bind_rows will combine a list of data frames into one data frame
  the_data <- dplyr::bind_rows(my_list[["Results"]][["series"]][["data"]])

# We need to add labels to the_data which specifies the series
  the_data$series_id <- rep(x = my_series_ids, each = my_rows)

# Add the_data to the data_list
  data_list[[i]] <- the_data
}


# Flatten the data_list into one big data frame named the_data
the_data <- dplyr::bind_rows(data_list)





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





