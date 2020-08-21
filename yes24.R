library(httr)
library(rvest)
library(XML)
library(stringr)

rm(list=ls())

## 베스트셀러 - 주별 베스트
# http://www.yes24.com/24/category/bestseller?CategoryNumber=001&sumgb=08

y <- 2020
m <- 8
w <- 3

URL <- str_c("http://www.yes24.com/24/category/bestsellerExcel?CategoryNumber=001&sumgb=08&year=", y, "&month=", m, "&week=", w, "&day=1&FetchSize=50")

outfile <- str_c("yes24_종합_", y, "_", m, "_", w, ".xls")

download.file(URL, outfile)
