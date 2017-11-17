
library(tidyverse)



# Read in the Function to call in more than 50 series
source('Function - bls_get_many_series v1.0.R', echo=FALSE)


# Statewide - Non Seasonally Adjusted - Employment series
my_series_id <- c("SMU01000000000000001", "SMU02000000000000001", "SMU04000000000000001", 
                "SMU05000000000000001", "SMU06000000000000001", "SMU08000000000000001", 
                "SMU09000000000000001", "SMU10000000000000001", "SMU11000000000000001", 
                "SMU12000000000000001", "SMU13000000000000001", "SMU15000000000000001", 
                "SMU16000000000000001", "SMU17000000000000001", "SMU18000000000000001", 
                "SMU19000000000000001", "SMU20000000000000001", "SMU21000000000000001", 
                "SMU22000000000000001", "SMU23000000000000001", "SMU24000000000000001", 
                "SMU25000000000000001", "SMU26000000000000001", "SMU27000000000000001", 
                "SMU28000000000000001", "SMU29000000000000001", "SMU30000000000000001", 
                "SMU31000000000000001", "SMU32000000000000001", "SMU33000000000000001", 
                "SMU34000000000000001", "SMU35000000000000001", "SMU36000000000000001", 
                "SMU37000000000000001", "SMU38000000000000001", "SMU39000000000000001", 
                "SMU40000000000000001", "SMU41000000000000001", "SMU42000000000000001", 
                "SMU44000000000000001", "SMU45000000000000001", "SMU46000000000000001", 
                "SMU47000000000000001", "SMU48000000000000001", "SMU49000000000000001", 
                "SMU50000000000000001", "SMU51000000000000001", "SMU53000000000000001", 
                "SMU54000000000000001", "SMU55000000000000001", "SMU56000000000000001", 
                "SMU72000000000000001", "SMU78000000000000001")

# Pull in time series df for these state wide series
the_data <- bls_get_many_series(my_series_id)




# YOY Changes -------------------------------------------------------------




# Add a Column with a date 1 year prior to max date
the_data$match_date <- max(the_data$date) - years(1)

# Perform self Join to have a value column showing prior year value
the_data <- left_join(the_data, the_data, 
                      by = c("series_id" = "series_id", "match_date" = "date"))

# Make the tbl simpler and add YOY Var columns
the_data <- the_data %>%
            filter(date == max(the_data$date) ) %>%
            select(-match_date, -match_date.y) %>%
            rename(current_year = value.x,
                   prior_year = value.y) %>%
            mutate(yoy_var = current_year - prior_year,
                   yoy_var_percent = yoy_var / prior_year)




# Add Meta Data -----------------------------------------------------------


series <- read_csv("series.csv")

series <- series %>% 
  select(series_id, data_type_text, industry_name, 
         state_name, supersector_name, area_name)

the_data <- left_join(the_data, series)

rm(series)



# Prep Data for Charts ----------------------------------------------------

the_data %>% 
  arrange(desc(yoy_var_percent)) %>%
  View()

plot_data <- the_data %>%
              arrange(desc(yoy_var_percent)) %>%
              top_n(15, yoy_var_percent)



test <- plot_data %>%
        mutate(state_name = factor(state_name),
               state_name = reorder(state_name, yoy_var_percent))

levels(test$state_name)



# Make a plot
ggplot(test, aes(x = state_name, y = yoy_var_percent)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(x = NULL, y = "YOY Percent Change")
















