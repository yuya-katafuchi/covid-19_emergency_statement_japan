# covid-19_emergency_statement_japan
## Overview
Date-range data of the COVID-19 emergency declaration for the prefectures in Japan


## Description of files
* `covid-19_emergency_statement_japan.csv`: data file
* `make_long_covid-19_emergency_statement_japan.R`: An R script that converts the above file into a long format data frame represented by a binary variable that indicates under which emergency declaration was issued. This also supports multiple declarations of emergency.


## Description of columns in `covid-19_emergency_statement_japan.csv`
* `id`: ID assigned to prefectures in Japan in accordance with the JIS code (JIS X 0401).
* `prefecture_en`: Names of prefectures in Japan, in English.
* `emergency_start`: The date on which the Government of Japan declared a state of emergency for COVID-19 infection.
* `emergency_end`: The date on which the Government of Japan declared that the state of emergency is over because it has recognized that it is no longer necessary to implement emergency measures.
* `times`: Integer data indicating the number of times the declaration was issued in the region.


## Data source
* 1st declaration (2020): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan, "Report on the Implementation of Declaration of a State of Emergency in response to the Novel Coronavirus Disease," (in Japanese), 2020/06/04, URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku0604.pdf
* 2nd declaration (2021):
  * 1st Part: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan, "Declaration of a State of Emergency in response to the Novel Coronavirus Disease", (in Japanese), 2021/01/07, URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210107.pdf
  * 2nd Part: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan, "Change in Areas of Declaration of a State of Emergency in response to the Novel Coronavirus Disease", (in Japanese), 2021/01/13, URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210113.pdf


## Example of long-format data generated by `make_long_covid-19_emergency_statement_japan.R`
The R script `make_long_covid-19_emergency_statement_japan.R` converts the date range data for prefecture-level emergency declarations provided by `covid-19_emergency_statement_japan.csv` into long-format data where the prefecture and date pair is a single record. As an example, the following shows the long-format data for Tokyo from January 1, 2021. Note that `df_date_range_long` is a long-format dataframe generated by this R script.

### Example of code filtering the long-format data for Tokyo from January 1, 2021 (on January 26, 2021):
Code:
```R
library(lubridate)

df_date_range_long %>%
  filter(prefecture_en == "Tokyo") %>%
  filter(date >= ymd("2021-01-01"))
```

Output:

![emergency_long_format_tokyo_example_2021-01-26](https://user-images.githubusercontent.com/44940112/105788203-5c7eb000-5fc3-11eb-8ddd-17af4718e1f7.png)


### Example of code depicting the emergency declaration date-coverage for Hokkaido, Tokyo, Kyoto, and Fukuoka around 1st emergency declaration in 2020
Code:
```R
library(lubridate)

df_date_range_long_subset <- df_date_range_long %>%
  filter(prefecture_en %in% c("Hokkaido", "Tokyo", "Kyoto", "Fukuoka")) %>%
  filter((date >= ymd("2020-04-01")) & date <= ymd("2020-06-01")) %>%
  mutate(prefecture_en = fct_reorder(factor(prefecture_en), id))

df_date_range_long_subset %>%
  ggplot() +
  geom_line(aes(x = date, y = emergency), alpha = 0) +
  geom_rect(aes(xmin = min_date, xmax = max_date,
                ymin = -Inf, ymax = Inf),
            data = df_date_range_long_subset %>%
              filter(emergency == 1) %>%
              group_by(prefecture_en) %>%
              summarize(min_date = min(date), max_date = max(date)),
            alpha = 0.4) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  scale_x_date(date_labels = "%x") +
  facet_wrap(~ prefecture_en, ncol = 1)
```

Output:

![Rplot_emergency_coverage_example](https://user-images.githubusercontent.com/44940112/105791475-85a23f00-5fc9-11eb-935b-3950fb38d23e.png)


## Citation
Katafuchi, Y. (2020). covid-19_emergency_statement_japan. URL: https://github.com/yuya-katafuchi/covid-19_emergency_statement_japan.
