# -------------------------------------------------------------------------
# Author: Yuya Katafuchi
# Last updated: 2021-05-16
#
# Description:
# make_long_covid19_emergency_statement_japan()
# converts the wide-format file of state of emergency into a long format
# data frame represented by a binary variable that indicates under which
# emergency declaration was issued.
#
# Usage:
# make_long_covid19_emergency_statement_japan(
#   wide_df_emergency_statement = readr::read_csv("https://raw.githubusercontent.com/yuya-katafuchi/covid-19_emergency_statement_japan/master/covid-19_emergency_statement_japan.csv"),
#   start_date_whole = lubridate::ymd("2020-01-01"),
#   end_date_whole = Sys.Date()
# )
# Arguments:
# wide_df_emergency_statement: DataFrame, data file of the state of emergency issued by the government
# of Japan in wide-format
# start_date_whole: Date, start date of binary long-format dataframe
# end_date_whole: Date, end date of binary long-format dataframe
#
# Return:
# long_df_emergency_statement: DataFrame, converted long-format dataframe represented
# by a binary variable that indicates under which emergency declaration was issued,
# and times of declation.
# -------------------------------------------------------------------------

library(tidyverse)
library(lubridate)

make_long_covid19_emergency_statement_japan <-  function(
  wide_df_emergency_statement = readr::read_csv("https://raw.githubusercontent.com/yuya-katafuchi/covid-19_emergency_statement_japan/master/covid-19_emergency_statement_japan.csv"),
  start_date_whole = lubridate::ymd("2020-01-01"),
  end_date_whole = Sys.Date()
){


  # create sequence of days -------------------------------------------------
  date_sequence <- seq(start_date_whole, end_date_whole, "day")

  # take unique of ids ------------------------------------------------------
  unique_id <- unique(wide_df_emergency_statement$id)
  unique_prefecture_en <- unique(wide_df_emergency_statement$prefecture_en)

  # create long dataframe ---------------------------------------------------
  # initialize long-format dataframe for emergency statement
  long_df_emergency_statement <- tibble::tibble()
  # for ith prefecture
  for (i in seq_along(unique_id)) {
    # get wide-format dataframe for ith prefecture
    wide_df_emergency_statement_i <- wide_df_emergency_statement %>%
      dplyr::filter(id == unique_id[i])
    # initialize sequence of binary long-format array
    date_sequence_condition <- rep(FALSE, length(date_sequence))
    # initialize sequence of times
    times_sequence <- rep(NA, length(date_sequence))
    # for jth declaration in ith prefecture
    for (j in 1:dim(wide_df_emergency_statement_i)[1]){
      # get start date of jth declaration in ith prefecture
      start_date <- wide_df_emergency_statement_i$emergency_start[j]
      # get end date of jth declaration in ith prefecture
      end_date <- wide_df_emergency_statement_i$emergency_end[j]
      # get 0/1 binary array ranging according to date_sequence
      date_sequence_condition_temp <-
        (start_date <= date_sequence) &
        (date_sequence <= end_date)
      # stack above array for ith prefecture using Boolean operation
      date_sequence_condition <-
        date_sequence_condition | date_sequence_condition_temp
      # substitute times
      times_sequence[date_sequence_condition_temp] = j
    }
    # make long-format dataframe for ith prefecture
    long_df_emergency_statement_temp <- tibble::tibble(
      id = unique_id[i],
      prefecture_en = unique_prefecture_en[i],
      date = date_sequence,
      times = times_sequence,
      emergency =
        as.integer(
          ifelse(
            is.na(date_sequence_condition),
            1,
            date_sequence_condition
          )
        )
      )
    # stack long_format dataframe
    long_df_emergency_statement <- bind_rows(long_df_emergency_statement, long_df_emergency_statement_temp)
  }

  return(long_df_emergency_statement)
}
