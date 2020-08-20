## NAVER 금융 원달러 환율 일별 시세

library(rvest)
library(stringr)
library(dplyr)


## 최근 10 영업일 환율 종가 수집
URL <- "https://finance.naver.com/marketindex/exchangeDailyQuote.nhn?marketindexCd=FX_USDKRW&page=1"
res <- read_html(URL, encoding="EUC-KR")

# Table
Sys.setlocale("LC_ALL", "C")
tab <- res %>% 
  html_table(fill=TRUE) %>% 
  .[[1]]
Sys.setlocale("LC_ALL", "Korean")

n.var <- dim(tab)[2]
names(tab) <- LETTERS[1:n.var]
df <- tab %>% slice(-1)



## 최근 100 영업일 환율 종가 수집

Stack <- NULL
for (i in 1:10) {
  
  if (i%%5==1) print(i)
  
  URL <- str_c("https://finance.naver.com/marketindex/exchangeDailyQuote.nhn?marketindexCd=FX_USDKRW&page=", i)
  
  res <- read_html(URL, encoding="EUC-KR")
  
  # Table
  Sys.setlocale("LC_ALL", "C")
  tab <- res %>% 
    html_table(fill=TRUE) %>% 
    .[[1]]
  Sys.setlocale("LC_ALL", "Korean")
  
  n.var <- dim(tab)[2]
  names(tab) <- LETTERS[1:n.var]
  df <- tab %>% slice(-1)

  Stack <- rbind(Stack, df)
  
  Sys.sleep(1)
  
}



## 참고자료 rvest template

URL <- ""
res <- read_html(URL)

# Table
Sys.setlocale("LC_ALL", "C")
res %>% 
  html_table()
Sys.setlocale("LC_ALL", "Korean")
# Element
pattern <- ""
res %>% 
  html_nodes() %>% 
  html_text()

# Attribute's value: link
pattern <- ""
res %>% 
  html_nodes() %>% 
  html_attr("href")

# 가지고 온 HTML 소스에 내가 원하는 정보가 포함되어 있는지 확인할 때 사용할 코드
doc <- toString(res)
writeLines(doc, "check.html")
getwd()



