#1. 서울보육포털: 인코딩 이슈가 있어서 Windows 환경과 RStudio Cloud 환경에서 동작하는 코드를 구분해서 수록했습니다.

## Clear memory
rm(list=ls())

library(XML)
library(rvest)
library(dplyr)
library(readxl)
library(writexl)

url <- "https://iseoul.seoul.go.kr/portal/info/preSchoolList.do?pageIndex=3"

## Windows 환경: 에서는 인코딩 이슈가 있어서 local 설정에 관한 부분을 추가해야 합니다.


## Method 1. XML library
txt <- readLines(url, encoding="UTF-8")
txt_p <- htmlParse(txt, encoding="UTF-8")
Sys.setlocale("LC_ALL", "C")
tab <- readHTMLTable(txt_p)
Sys.setlocale("LC_ALL", "Korean_Korea.949")
df<-tab[[1]]
head(df)
write_xlsx(df, "seoul_childcare_center_p3.xlsx") 


## Method 2. rvest library
Sys.setlocale("LC_ALL", "C")
df <- read_html(url) %>% 
  html_table() %>% 
  as.data.frame()
Sys.setlocale("LC_ALL", "Korean_Korea.949")
head(df)

write_xlsx(df, "seoul_childcare_center_p3.xlsx") 



## RStudio Cloud 환경(Unix 서버)

### Method 1. XML library
txt <- readLines(url)
txt_p <- htmlParse(txt)
tab <- readHTMLTable(txt_p)
df<-tab[[1]]
head(df)

write_xlsx(df, "seoul_childcare_center_p3.xlsx") 


### Method 2. rvest library
df <- read_html(url) %>% 
  html_table() %>% 
  as.data.frame()
head(df)

write_xlsx(df, "seoul_childcare_center_p3.xlsx") 
