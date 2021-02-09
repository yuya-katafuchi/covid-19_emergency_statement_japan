# covid-19_emergency_statement_japan

## Table of Contents
* [Overview](#overview)
* [Description of Files](#description-of-files)
* [Description of columns in `covid-19_emergency_statement_japan.csv`](#description-of-columns-in-covid-19_emergency_statement_japancsv)
* [Data source](#data-source)
* [Example of long-format data generated by `make_long_covid-19_emergency_statement_japan.R`](#example-of-long-format-data-generated-by-make_long_covid-19_emergency_statement_japanr)
  * [Example of code filtering the long-format data for Tokyo from January 1, 2021 (on January 26, 2021)](#example-of-code-filtering-the-long-format-data-for-tokyo-from-january-1-2021-on-january-26-2021)
  * [Example of code depicting the emergency declaration date-coverage for Hokkaido, Tokyo, Kyoto, and Fukuoka around 1st emergency declaration in 2020](#example-of-code-depicting-the-emergency-declaration-date-coverage-for-hokkaido-tokyo-kyoto-and-fukuoka-around-1st-emergency-declaration-in-2020)
* [Citation](#citation)


## Overview of this repository
Date-range data of the COVID-19 emergency declaration for the prefectures in Japan. The emergency declarations in this dataset are those issued by the Japanese government.

## Overview of State of Emergency in response to the Novel Coronavirus Disease in Japan
The declaration of a state of emergency regarding a new coronavirus infection in Japan is a declaration to invoke special authority for an emergency situation or to alert the public, as defined in Chapter 4 of the "Act on Special Measures for Pandemic Influenza and New Infectious Diseases Preparedness and Response", a law in Japan (e-Gov, Japan, 2020; Cabinet Secretariat, Japan, 2020a). The purpose of this law is to protect the lives and health of the people and to minimize the impact on the lives of the people and the national economy (Cabinet Secretariat, Japan, 2020b).
The state of emergency in Japan is not accompanied by a mandatory lockdown with penalties as in other countries, but is basically based on a request to the public. Specifically, it asks for the following measures (Ministry of Health, Labour, and Welfare, Japan, 2020; Cabinet Secretariat, Japan, 2021):
* Request to refrain from going out or traveling unnecessarily
* Request to refrain from holding events where an unspecified number of people gather
* Request to refrain from opening restaurants, amusement facilities, and large-scale stores, and to shorten their opening hours
* Request for work-from-home with the aim of reducing the number of employees at work by 70%
* Expansion of the medical care provision system and inspection system
* Permission to use urgent and temporary medical facilities

The declaration of a state of emergency based on this law is issued by the government, which can restrict the areas covered by this declaration, and therefore, the implementation of the declaration varies from region to region, especially at the prefectural level to date. This repository consists of data constructed for the purpose of capturing the heterogeneity of such emergency declarations at the prefectural level and conducting data-based analysis, as well as R codes to assist in the analysis using the data.

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
* 1st declaration (2020): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Report on the Implementation of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2020/06/04. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku0604.pdf. (Accessed on February 9, 2020).
* 2nd declaration (2021): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/01/07. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210107.pdf. (Accessed on February 9, 2020).
  * 1st Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/01/13. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210113.pdf. (Accessed on February 9, 2020).
  * 2nd Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas and Extention of the Period of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/02/02. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210202.pdf. (Accessed on February 9, 2020).


## Example of long-format data generated by `make_long_covid-19_emergency_statement_japan.R`
The R script `make_long_covid-19_emergency_statement_japan.R` converts the date range data for prefecture-level emergency declarations provided by `covid-19_emergency_statement_japan.csv` into long-format data where the prefecture and date pair is a single record. As an example, the following shows the long-format data for Tokyo from January 1, 2021. Note that `df_date_range_long` is a long-format dataframe generated by this R script.

### Example of code filtering the long-format data for Tokyo from January 1, 2021 (on January 26, 2021)
Code:
```R
library(tidyverse)
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
library(tidyverse)
library(lubridate)

df_date_range_long_subset <- df_date_range_long %>%
  filter(prefecture_en %in% c("Hokkaido", "Tokyo", "Kyoto", "Fukuoka")) %>%
  filter((date >= ymd("2020-04-01")) & (date <= ymd("2020-06-01"))) %>%
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

