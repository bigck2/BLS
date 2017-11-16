

# Load function to pull single series from API
source('Function - bls_get_single_series v1.0.R', echo=FALSE)

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
  geom_bar(stat = "identity") +
  labs(x = NULL, y = "Month over Month Change",
       title = "Employment Situation - Total Nonfarm Payroll Employment",
       subtitle = "Source: Buruea of Labor Statistics") +
  scale_y_continuous(labels = scales::comma) +
  guides(fill = FALSE)





