

library(tidyverse)



the_data <- read_rds("the_data.rds")


the_data$match_date <- max(the_data$date) - years(1)


the_data <- left_join(the_data, the_data, 
                      by = c("series_id" = "series_id", "match_date" = "date"))

the_data <- the_data %>%
            filter(date == max(the_data$date) ) %>%
            select(-match_date, -match_date.y) %>%
            rename(current_year = value.x,
                   prior_year = value.y) %>%
            mutate(yoy_var = current_year - prior_year,
                   yoy_var_percent = yoy_var / prior_year)

series <- read_csv("series.csv")

series <- series %>% 
          select(series_id, data_type_text, industry_name, 
                 state_name, supersector_name, area_name)

the_data <- left_join(the_data, series)

rm(series)


top <- the_data %>% 
        arrange(desc(current_year)) %>%
        top_n(30, current_year)
        



# Visualizations ----------------------------------------------------------


ggplot(top,  aes(x = reorder(area_name, current_year), y = current_year)) +
  geom_bar(aes(fill = state_name), stat = "identity") + 
  guides(fill = FALSE) +
  coord_flip() + 
  scale_x_continuous(labels = s)
  
  






