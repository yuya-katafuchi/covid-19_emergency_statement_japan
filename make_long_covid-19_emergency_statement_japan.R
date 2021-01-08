# preamble ----------------------------------------------------------------
library(tidyverse)

# set whole date-range ----------------------------------------------------
start_date_whole <- as.Date("2020-01-01")
end_date_whole <-Sys.Date()

# load data ---------------------------------------------------------------
df_date_range <- read_csv("covid-19_emergency_statement_japan.csv")

# create sequence of days -------------------------------------------------
date_sequence <- seq(start_date_whole, end_date_whole, "day")

# take unique of ids ------------------------------------------------------
unique_id <- unique(df_date_range$id)
unique_prefecture_en <- unique(df_date_range$prefecture_en)

# create long dataframe ---------------------------------------------------
df_date_range_long <- tibble()
for (i in seq_along(unique_id)) {
  df_date_range_i <- df_date_range %>% 
    filter(id == unique_id[i])
  date_sequence_condition <- rep(FALSE, length(date_sequence))
  for (j in 1:dim(df_date_range_i)[1]){
    start_date <- df_date_range_i$emergency_start[j]
    end_date <- df_date_range_i$emergency_end[j]
    date_sequence_condition_temp <- 
      (start_date <= date_sequence) & (date_sequence <= end_date)
    date_sequence_condition <-
      date_sequence_condition | date_sequence_condition_temp
  }
  df_date_range_long_temp <- tibble(id = unique_id[i],
                                    prefecture_en = unique_prefecture_en[i],
                                    date = date_sequence,
                                    emergency = 
                                      as.integer(
                                      ifelse(is.na(date_sequence_condition), 1, date_sequence_condition)))
  df_date_range_long <- bind_rows(df_date_range_long, df_date_range_long_temp)
}
