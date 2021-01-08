# covid-19_emergency_statement_japan
## Overview
Date-range data of the COVID-19 emergency statement for the prefectures in Japan

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
1st declaration: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan, "Report on the Implementation of Declaration of a State of Emergency in response to the Novel Coronavirus Disease," (in Japanese), 2020/06/04, URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku0604.pdf
2nd declaration: Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan, "Declaration of a State of Emergency in response to the Novel Coronavirus Disease", (in Japanese), 2021/01/07, URL: https://corona.go.jp/news/pdf/kinkyujitaisengen_houkoku_20210107.pdf

## Citation
Katafuchi, Y. (2020). covid-19_emergency_statement_japan. URL: https://github.com/yuya-katafuchi/covid-19_emergency_statement_japan.
