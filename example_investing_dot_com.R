## Investing.com

library(rvest)
library(stringr)
library(dplyr)


## Major indicies
URL <- "https://www.investing.com/indices/major-indices"
res <- read_html(URL)

# Table
tab <- res %>% 
  html_table() %>% 
  .[[1]]

names(tab)[1] <- "v1"
names(tab)[dim(tab)[2]] <- "v.last"

major.indices <- tab %>% 
  select(-v1, -v.last)

major.indices.core <- major.indices %>% 
  slice(1:5, 9:12, 29, 32, 36, 39, 42)


## Future indicies
URL <- "https://www.investing.com/indices/indices-futures"
res <- read_html(URL)

# Table
tab <- res %>% 
  html_table() %>% 
  .[[1]]

names(tab)[1] <- "v1"
names(tab)[dim(tab)[2]] <- "v.last"

future.indices <- tab %>% 
  select(-v1, -v.last)

future.indices.core <- future.indices %>% 
  slice(1:3, 6:9, 20, 22:24, 28, 30)




## 참고자료 rvest template

URL <- ""
res <- read_html(URL)

# Table
res %>% 
  html_table()

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

