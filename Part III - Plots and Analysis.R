

# Load function to pull single series from API
source('Function - bls_get_single_series v1.0.R', echo=FALSE)




# Jobs Number -------------------------------------------------------------

# This is the series ID for Total Employment
my_series_id <- "CES0000000001"

# Pull the data from the BLS api
the_data <- bls_get_single_series(my_series_id)

# Filter for only last 24 months
the_data <- the_data %>%
            filter(date >= floor_date(now(), unit = "months") - years(2)) %>%
            arrange(date)

# Calculate the Month over Month Changes
the_data$mom_change <- c(NA, diff(the_data$value))

# Create a factor column for negative and positive values
the_data <- the_data %>%
            mutate(positive = factor(ifelse(mom_change > 0, "Positive", "Negative"), 
                                     levels = c("Positive", "Negative")))



# Make Some plots ---------------------------------------------------------

ggplot(the_data, aes(x = date, y = mom_change, fill = positive)) +
  geom_hline(yintercept = mean(the_data$mom_change, na.rm = TRUE), 
             color = "white", size = 2) +
  geom_bar(stat = "identity") +
  labs(x = NULL, y = "Month over Month Change",
       title = "Employment Situation - Total Nonfarm Payroll Employment",
       subtitle = "Source: Buruea of Labor Statistics") +
  scale_y_continuous(labels = scales::comma) +
  guides(fill = FALSE) +
  geom_text(aes(label = the_data$mom_change / 1000), vjust = 1.5)





# Unemployment Number -----------------------------------------------------


# This is the series ID for seasonally adjusted unemployment rate
my_series_id <- "LNS14000000"

# Pull the data from the BLS api
the_data <- bls_get_single_series(my_series_id)

# Adjust the value column to be a percentage
the_data <- the_data %>%
            mutate(value = value / 1000 / 100) %>% 
            arrange(date)


# Filter for only last 24 months
the_data <- the_data %>%
            filter(date >= floor_date(now(), unit = "months") - years(2)) 

 
# Plot
ggplot(the_data, aes(x = date, y = value)) +
  geom_hline(yintercept = mean(the_data$value, na.rm = TRUE), 
             color = "white", size = 2) +
  geom_point(size = 3, color = "blue") +
  geom_line(color = "blue") +
  labs(x = NULL, y = NULL,
       title = "Employment Situation - Unemployment Rate",
       subtitle = "Source: Buruea of Labor Statistics") +
  scale_y_continuous(labels = scales::percent) 
  















