


test <- series %>%
        filter(data_type_text == "All Employees, In Thousands",
               seasonal == "U",
               supersector_name == "Total Nonfarm",
               area_name != "Statewide")


test_state <- series %>%
              filter(data_type_text == "All Employees, In Thousands",
                     seasonal == "U",
                     supersector_name == "Total Nonfarm",
                     area_name == "Statewide")















