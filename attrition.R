################################################################################
# Experimenting with machine learning for employee retention using sample data
# data from: https://www.kaggle.com/HRAnalyticRepository/employee-attrition-data
#
# Initial idea: Use Random Forest Regression to predict employee turnover
#
################################################################################

# Load the tidyverse libraries
library(tidyverse)

#import the data
data <- read_csv("MFG10YearTerminationData.csv", na = c("1/1/1900"))

# the data has multiple entries for each employee, we only need the last one
data <- data %>%
  group_by(EmployeeID) %>%
  slice(which.max(STATUS_YEAR))

# drop reduntant or unused fields
data <- data %>% 
  select(-recorddate_key, -age, -length_of_service, -gender_full, -STATUS_YEAR)

# rename fields
data <- data %>% 
  rename(dob = birthdate_key, hireDate = orighiredate_key, termDate = terminationdate_key,
         gender = gender_short)

# convert strings to dates in date fields
data$dob <- as.Date(data$dob, format = "%m/%d/%Y")
data$hireDate <- as.Date(data$hireDate, format = "%m/%d/%Y")
data$termDate <- as.Date(data$termDate, format = "%m/%d/%Y")

#calculate age when hired
data$hireAge <- (data$hireDate - data$dob)/365.25
