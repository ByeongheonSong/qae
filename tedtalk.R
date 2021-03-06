# Ted Talks

library(rvest)
library(XML)
library(dplyr)
library(stringr)
library(writexl)



## Case 1. Extract names of speakers from the first page.

## rvest method
res <- read_html(baseURL)
pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
res %>% html_nodes(xpath=pattern) %>% 
  html_text()

## XML Method
baseURL <- "http://www.ted.com/talks?page=1"
txt <- readLines(baseURL,warn=FALSE)
txt_p <- htmlParse(txt)
pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
xpathSApply(txt_p, pattern, xmlValue)



## Case 2. We will scrap first three pages from the website.

n.page <- 3

## Step 1. Download Source files for each page
for (i in 1:n.page) {
  
  if (i%%10==1) print(str_c("Downloading page ", i, " is starting"))
  baseURL <- str_c("http://www.ted.com/talks?page=", i)
  txt <- readLines(baseURL, warn=FALSE)
  outfile <- str_c("tedtalk", i, ".html")
  writeLines(txt, outfile)
  
  Sys.sleep(1)
  
}



## Step 2. Extracting information from each page
Stack<-NULL
for (i in 1:n.page) {
  
  if (i%%10==1) print(str_c("Scraping page ", i, " is starting"))
  
  infile <- str_c("tedtalk", i, ".html")
  txt <- readLines(infile)
  txt_p <- htmlParse(txt)
  
  pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
  e1 <- xpathSApply(txt_p, pattern, xmlValue)
  
  pattern <- "//div[@class='container results']//h4//a"
  e2 <- xpathSApply(txt_p, pattern, xmlValue) %>% 
    str_replace_all("\n", "") %>% 
    str_replace_all("<U+2014>", " ")
  
  pattern <- "//div[@class='meta']//span[@class='meta__item']//span[@class='meta__val']"
  e3 <- xpathSApply(txt_p, pattern, xmlValue) %>% 
    str_replace_all("\n", "")
  
  pattern <- "//div[@class='container results']//h4/a[@class=' ga-link']"
  e4 <- xpathSApply(txt_p, pattern, xmlGetAttr, 'href')
  e4 <- str_c("http://www.ted.com", e4)
  
  tab <- data.frame(cbind(e1, e2, e3, e4))
  
  Stack <- rbind(Stack, tab)
  
}

colnames(Stack) <- c("speaker", "title", "posted", "link")
head(Stack)

outfile <- "tedtalk_list.xlsx"
write_xlsx(Stack, outfile)
