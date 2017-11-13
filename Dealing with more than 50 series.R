

# A list of some BLS Series
some_series <- c("SMS02112600000000001", "SMS02218200000000001", "SMS04223800000000001", 
                 "SMS04294200000000001", "SMS04380600000000001", "SMS04391400000000001", 
                 "SMS04460600000000001", "SMS04497400000000001", "SMU02112600000000001", 
                 "SMU02218200000000001", "SMU04223800000000001", "SMU04294200000000001", 
                 "SMU04380600000000001", "SMU04391400000000001", "SMU04434200000000001", 
                 "SMU04460600000000001", "SMU04497400000000001")


some_series <- rep(some_series, 10)

some_series <- rep("a", 100)

my_length <- length(some_series)

# How many groups of 50 can we make evenly?
my_length %/% 50

# How many elements will remain left over?
my_length %% 50

# Total number of groups we need
my_groups <- (my_length %/% 50 ) + ifelse(my_length %% 50 > 0 , 1, 0)



