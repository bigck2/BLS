



series <- read_csv("series.csv")

test <- series %>%
        filter(data_type_text == "All Employees, In Thousands",
               seasonal == "U",
               supersector_name == "Total Nonfarm",
               area_name != "Statewide")

some_series <- test$series_id


test_state <- series %>%
              filter(data_type_text == "All Employees, In Thousands",
                     seasonal == "U",
                     supersector_name == "Total Nonfarm",
                     area_name == "Statewide")

rm(list=setdiff(ls(), "the_data"))

write_rds(the_data, "the_data.rds")












