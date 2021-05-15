# covid-19_emergency_statement_japan

## Table of contents
* [Overview of this repository](#overview-of-this-repository)
* [Overview of State of Emergency in response to the Novel Coronavirus Disease in Japan](#overview-of-state-of-emergency-in-response-to-the-novel-coronavirus-disease-in-japan)
* [Description of files](#description-of-files)
* [Description of columns in `covid-19_emergency_statement_japan.csv`](#description-of-columns-in-covid-19_emergency_statement_japancsv)
* [Description of columns in `covid-19_emergency_statement_japan_prefectural.csv`](#description-of-columns-in-covid-19_emergency_statement_japan_prefecturalcsv)
* [Example of long-format data generated by `make_long_covid-19_emergency_statement_japan.R`](#example-of-long-format-data-generated-by-make_long_covid-19_emergency_statement_japanr)
  * [Example of code filtering the long-format data for Tokyo from January 1, 2021 (on January 26, 2021)](#example-of-code-filtering-the-long-format-data-for-tokyo-from-january-1-2021-on-january-26-2021)
  * [Example of code depicting the emergency declaration date-coverage for Hokkaido, Tokyo, Kyoto, and Fukuoka around 1st emergency declaration in 2020](#example-of-code-depicting-the-emergency-declaration-date-coverage-for-hokkaido-tokyo-kyoto-and-fukuoka-around-1st-emergency-declaration-in-2020)
* [Data source of `covid-19_emergency_statement_japan.csv`](#data-source-of-covid-19_emergency_statement_japancsv)
* [Citation](#citation)
* [Reference](#reference)
* [Acknowledgement](#acknowledgement)


## Overview of this repository
Date-range data of the COVID-19 emergency declaration (緊急事態宣言; _Kinkyujitaisengen_, in Japanese) for the prefectures in Japan. The emergency declarations in this dataset are those issued by the government of Japan and prefectural governments of Japan.
[![DOI](https://zenodo.org/badge/275304711.svg)](https://zenodo.org/badge/latestdoi/275304711)

## Overview of State of Emergency in response to the Novel Coronavirus Disease in Japan
The declaration of a state of emergency (緊急事態宣言; _Kinkyujitaisengen_, in Japanese) regarding a new coronavirus infection in Japan issued by the government of Japan is a declaration to invoke special authority for an emergency situation or to alert the public, as defined in Chapter 4 of the "Act on Special Measures for Pandemic Influenza and New Infectious Diseases Preparedness and Response", a law in Japan (e-Gov, Japan, 2020; Cabinet Secretariat, Japan, 2020a). The purpose of this law is to protect the lives and health of the people and to minimize the impact on the lives of the people and the national economy (Cabinet Secretariat, Japan, 2020b).
The state of emergency in Japan is not accompanied by a mandatory lockdown with penalties as in other countries, but is basically based on a request to the public. Specifically, it asks for the following measures (Ministry of Health, Labour, and Welfare, Japan, 2020; Cabinet Secretariat, Japan, 2021):
* Request to refrain from going out or traveling unnecessarily
* Request to refrain from holding events where an unspecified number of people gather
* Request to refrain from opening restaurants, amusement facilities, and large-scale stores, and to shorten their opening hours
* Request for work-from-home with the aim of reducing the number of employees at work by 70%
* Expansion of the medical care provision system and inspection system
* Permission to use urgent and temporary medical facilities

The declaration of a state of emergency based on this law is issued by the government, which can restrict the areas covered by this declaration, and therefore, the implementation of the declaration varies from region to region, especially at the prefectural level to date. This repository consists of data constructed for the purpose of capturing the heterogeneity of such emergency declarations at the prefectural level and conducting data-based analysis, as well as R codes to assist in the analysis using the data.

In addition, this repository also covers emergency declarations by prefectural governments of Japan, which include the purpose of the emergency declaration and the uniqueness of each prefecture in terms of measures and requests.

## Description of files
* `covid-19_emergency_statement_japan.csv`: data file of the state of emergency issued by the government of Japan.
* `covid-19_emergency_statement_japan_prefectural.csv`: data file of the state of emergency issued by prefectural governments of Japan.
* `make_long_covid-19_emergency_statement_japan.R`: An R script that converts the above file into a long format data frame represented by a binary variable that indicates under which emergency declaration was issued. This also supports multiple declarations of emergency.
* `bib_covid-19_emergency_statement_japan.bib`: .bib file for citing this repository in BibTeX.


## Description of columns in `covid-19_emergency_statement_japan.csv`
* `id`: ID assigned to prefectures in Japan in accordance with the JIS code (JIS X 0401).
* `prefecture_en`: Names of prefectures in Japan, in English.
* `emergency_start`: The date on which the Government of Japan declared a state of emergency for COVID-19 infection.
* `emergency_end`: The date on which the Government of Japan declared that the state of emergency is over because it has recognized that it is no longer necessary to implement emergency measures.
* `times`: Integer data indicating the number of times the declaration was issued in the region.

## Description of columns in `covid-19_emergency_statement_japan_prefectural.csv`
* `id`: ID assigned to prefectures in Japan in accordance with the JIS code (JIS X 0401).
* `prefecture_en`: Names of prefectures in Japan, in English.
* `emergency_start`: The date on which the Government of Japan declared a state of emergency for COVID-19 infection.
* `emergency_end`: The date on which the Government of Japan declared that the state of emergency is over because it has recognized that it is no longer necessary to implement emergency measures.
* `times`: Integer data indicating the number of times the declaration was issued in the region.
* `source`: URL of the website of the prefectural government that provided the source of the data

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


## Data source of `covid-19_emergency_statement_japan.csv`
* 1st Declaration (2020): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Report on the Implementation of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2020/06/04. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku0604.pdf. (Accessed on February 9, 2021).
* 2nd Declaration (2021): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/01/07. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210107.pdf. (Accessed on February 9, 2021).
  * 1st Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/01/13. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210113.pdf. (Accessed on February 9, 2021).
  * 2nd Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas and Extention of the Period of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/02/02. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210202.pdf. (Accessed on February 9, 2021).
  * 3rd Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/02/26. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210226.pdf. (Accessed on February 28, 2020).
  * 4th Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. End of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/03/18. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_shuryo_20210319.pdf. (Accessed on March 19, 2020).
* 3rd Declaration (2021): Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/04/23. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_20210423.pdf. (Accessed on April 23, 2021).
  * 1st Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas and Extention of the Period of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/05/07. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210507.pdf. (Accessed on May 7, 2021).
  * 2nd Amendment: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan. Change in Areas of Declaration of a State of Emergency in response to the Novel Coronavirus Disease. in Japanese. 2021/05/14. URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210514.pdf. (Accessed on May 15, 2021).



## Citation
Katafuchi, Y. (2020). covid-19_emergency_statement_japan. URL: https://github.com/yuya-katafuchi/covid-19_emergency_statement_japan. DOI: https://doi.org/10.5281/zenodo.4552924.

[.bib file for BibTeX](https://raw.githubusercontent.com/yuya-katafuchi/covid-19_emergency_statement_japan/master/bib_covid_19_emergency_statement_japan.bib)

## Reference
* e-Gov, Japan. (2020). Act on Special Measures for Pandemic Influenza and New Infectious Diseases Preparedness and Response. in Japanese. URL: https://elaws.e-gov.go.jp/document?lawid=424AC0000000031. (Accessed on February 9, 2021).
* Cabinet Secretariat, Japan. (2020a). State of Emergency in response to the Novel Coronavirus Disease. in Japanese. URL: https://corona.go.jp/emergency/. (Accessed on February 9, 2021)
* Cabinet Secretariat, Japan. (2020b). Act on Special Measures for Pandemic Influenza and New Infectious Diseases Preparedness and Response. in Japanese. URL: https://corona.go.jp/emergency/#influenza. (Accessed on February 9, 2021)
* Ministry of Health, Labour, and Welfare, Japan. (2020). Overview of the Act on Special Measures for Pandemic Influenza and New Infectious Diseases Preparedness and Response. URL: https://www.mhlw.go.jp/content/10900000/000606693.pdf. (Accessed on February 9, 2021)
* Cabinet Secretariat, Japan. (2021). Revision of the Basic Policy on Countermeasures against Novel Coronavirus Disease (Summary). in Japanese. URL: https://corona.go.jp/emergency/pdf/kihonhoushin_kaitei_20210202.pdf. (Accessed on February 9, 2021)

## Acknowledgement
Development of this repository is supported in part by JSPS KAKENHI Grant Number 20K22142.