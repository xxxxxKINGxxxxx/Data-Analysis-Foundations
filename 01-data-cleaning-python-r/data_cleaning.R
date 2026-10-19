# Data Cleaning and Exploration - Adult Income Dataset
# Adult Income Dataset from UCI ML Repository

library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Step 1 - Environment Setup

cat("R version:", R.version$major, ".", R.version$minor, "\n")
cat("dplyr:", as.character(packageVersion("dplyr")), "\n")
cat("ggplot2:", as.character(packageVersion("ggplot2")), "\n")
cat("readr:", as.character(packageVersion("readr")), "\n")


# Step 2 - Loading and Inspecting the Data

df <- read_csv("data/adult.csv", na = c("", "NA", "?"))

# basic info about the dataset
cat("rows:", nrow(df), "\n")
cat("columns:", ncol(df), "\n")

print(head(df, 5))
print(colnames(df))

# check data types
print(sapply(df, class))

# missing values
print(colSums(is.na(df)))

# duplicates
cat("duplicate rows:", sum(duplicated(df)), "\n")

# The Adult Income dataset has info on about 48000 people from a 1994 US census.
# Each row is one person and has columns like age, education, occupation and whether
# they earn above or below 50K a year. It has 15 columns total.
# Some columns like workclass and occupation have missing values marked as ?.
# The income column is what we would try to predict - its either <=50K or >50K.


# Step 3 - Cleaning

# fill missing values with the most common value (mode)
# using mode because these are categorical columns, cant take a mean of job types
get_mode <- function(x) {
  ux <- na.omit(unique(x))
  ux[which.max(tabulate(match(x, ux)))]
}

df$workclass[is.na(df$workclass)] <- get_mode(df$workclass)
df$occupation[is.na(df$occupation)] <- get_mode(df$occupation)
df$native_country[is.na(df$native_country)] <- get_mode(df$native_country)

cat("missing values remaining:", sum(is.na(df)), "\n")

# convert some columns to factors
df$income <- as.factor(df$income)
df$education <- as.factor(df$education)
df$sex <- as.factor(df$sex)

# add a new column for age group
df$age_group <- ifelse(df$age < 30, "Young",
                ifelse(df$age < 50, "Middle", "Senior"))

print(table(df$age_group))


# Step 4 - Exploration

# filter to just people working over 40 hours
overtime <- df %>% filter(hours_per_week > 40)
cat("people working over 40 hrs:", nrow(overtime), "\n")

# table 1 - average age and hours by income
# higher earners seem to be older and work longer hours
table1 <- df %>%
  group_by(income) %>%
  summarise(avg_age = round(mean(age), 2),
            avg_hours = round(mean(hours_per_week), 2))
print(table1)

# table 2 - how many people in each education level and income group
# more education generally means higher income
table2 <- df %>%
  group_by(education, income) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = income, values_from = count, values_fill = 0)
print(table2)

# table 3 - average hours per week by occupation
# shows which jobs have longest working hours
table3 <- df %>%
  group_by(occupation) %>%
  summarise(avg_hours = round(mean(hours_per_week), 2),
            count = n()) %>%
  arrange(desc(avg_hours))
print(table3)


# Step 5 - Custom Function

# this function takes a dataframe and a column name
# it returns basic stats: count, min, max, mean, median and range
column_summary <- function(df, col_name) {
  x <- df[[col_name]]
  x <- x[!is.na(x)]
  
  return(list(
    count = length(x),
    min = min(x),
    max = max(x),
    mean = round(mean(x), 2),
    median = median(x),
    range = max(x) - min(x)
  ))
}

# testing the function on 3 columns
cat("\nSummary for age:\n")
print(column_summary(df, "age"))

cat("\nSummary for hours_per_week:\n")
print(column_summary(df, "hours_per_week"))

cat("\nSummary for capital_gain:\n")
print(column_summary(df, "capital_gain"))
