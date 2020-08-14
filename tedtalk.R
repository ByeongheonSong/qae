#2. Ted Talks

library(rvest)
library(stringr)
library(dplyr)
library(XML)


## Case 1. Extract speaker names from the first page.

## XML Method
baseURL <- "http://www.ted.com/talks?page=1"
txt <- readLines(baseURL,warn=FALSE)
txt_p <- htmlParse(txt)
pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
xpathSApply(txt_p,pattern,xmlValue)

## rvest method
res <- read_html(baseURL)
pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
res %>% html_nodes(xpath=pattern) %>% 
  html_text()



## Case 2. We will scrap first two pages from the website.
n.page<-2

## Step 1. Download Source files for each page
for (i in 1:n.page) {
  
  if (i%%10==1) print(paste("Downloading page",i,"is starting"))
  baseURL <- paste0("http://www.ted.com/talks?page=",i)
  txt <- readLines(baseURL,warn=FALSE)
  outfile <- paste0("tedtalk",i,".html")
  writeLines(txt,outfile)
  
  Sys.sleep(1)
  
}



## Step 2. Extracting information from each page
Stack<-NULL
for (i in 1:n.page) {
  
  if (i%%10==1) print(paste("Scraping page",i,"is starting"))
  
  infile <- paste0("tedtalk",i,".html")
  txt <- readLines(infile)
  txt_p <- htmlParse(txt)
  
  pattern <- "//div[@class='container results']//h4[@class='h12 talk-link__speaker']"
  e1 <- xpathSApply(txt_p, pattern, xmlValue)
  
  pattern <- "//div[@class='container results']//h4//a"
  e2 <- xpathSApply(txt_p, pattern, xmlValue) %>% 
    str_replace_all("\n","") %>% 
    str_replace_all("<U+2014>"," ")
  
  pattern<-"//div[@class='meta']//span[@class='meta__item']//span[@class='meta__val']"
  e3<-xpathSApply(txt_p, pattern, xmlValue) %>% 
    str_replace_all("\n","")
  
  pattern<-"//div[@class='container results']//h4/a[@class=' ga-link']"
  e4<-xpathSApply(txt_p, pattern, xmlGetAttr, 'href')
  e4<-paste0("http://www.ted.com", e4)
  
  tab<-data.frame(cbind(e1, e2, e3, e4))
  
  Stack<-rbind(Stack, tab)
  
}

colnames(Stack) <- c("speaker", "title", "posted", "link")
head(Stack)

outfile <- "tedtalk_list.xlsx"
write.xlsx(Stack, outfile, row.names = F)
