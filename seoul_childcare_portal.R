#1. 서울보육포털

## Clear memory
rm(list=ls())

library(XML)
library(rvest)
library(dplyr)
library(readxl)
library(writexl)

url <- "https://iseoul.seoul.go.kr/portal/info/preSchoolList.do?pageIndex=3"


## Method 1. XML library
txt <- readLines(url)
txt_p <- htmlParse(txt)
tab <- readHTMLTable(txt_p)
df<-tab[[1]]

write_xlsx(df, "seoul_childcare_center_p3.xlsx") 


## Method 2. rvest library
df <- read_html(url) %>% 
  html_table() %>% 
  as.data.frame()

write_xlsx(df, "seoul_childcare_center_p3.xlsx") 
