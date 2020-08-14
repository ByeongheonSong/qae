# 3. 중앙일보 - 인권 관련 기사
# https://news.joins.com/search/?keyword=%EC%9D%B8%EA%B6%8C
# https://news.joins.com/Search/JoongangNews?page=2&Keyword=%EC%9D%B8%EA%B6%8C&SortType=New&SearchCategoryType=JoongangNews

## Last Updated 2020. 8. 14 for QAE Workshop

rm(list = ls())

library(XML)
library(httr)
library(rvest)
library(stringr)
library(dplyr)
library(xlsx)

today <- format(Sys.Date(), "%m%d")


##########################################################
## Step 1: download source files for daily news item list
##########################################################

start <- 1
end <- 2

for (i in start:end) {
  
  baseURL<-str_c("http://search.joins.com/TotalNews?page=",i,"&Keyword=%EC%9D%B8%EA%B6%8C&SortType=New&SearchCategoryType=JoongangNews")
  
  txt<-readLines(baseURL,warn=FALSE,encoding="UTF-8")
  t_p<-htmlTreeParse(txt,useInternalNodes = TRUE,encoding="UTF-8")
  outfile<-paste0("중앙일보_인권_list_page",i,".html")
  writeLines(txt,outfile)
  
  Sys.sleep(1)
  
}


##########################################################
## STEP 2. Parsing Part
##########################################################
Stack<-NULL
for (i in start:end) {
  
  infile <- paste0("중앙일보_인권_list_page", i, ".html")
  
  txt <- readLines(infile, warn=FALSE)
  # txt<-readLines(infile,warn=FALSE,encoding="EUC-KR")
  txt <- enc2utf8(txt)
  
  t_p <- htmlTreeParse(txt, useInternalNodes = TRUE, encoding="UTF-8")
  
  pattern <- "//div[@class='section_news']/div[@class='bd']//li//h2[@class='headline mg']//a"
  e1 <- xpathSApply(t_p, pattern, xmlValue) %>% 
    str_trim %>% 
    str_replace_all("\n|\t","") 
  
  pattern <- "//div[@class='section_news']/div[@class='bd']//li//h2[@class='headline mg']//a"
  e2 <- xpathSApply(t_p, pattern, xmlGetAttr, 'href')
  
  table <- data.frame(cbind(e1, e2, i, length(e1), length(e2)), stringsAsFactors = FALSE) 
  Stack <- rbind(Stack, table)
  
}


Stack$id<-seq_len(nrow(Stack)) # 기사 일련번호 부여
Stack<-Stack[c(6, 1, 2, 3, 4, 5)]
colnames(Stack)<-c("id", "title", "link", "source.page", "n.e1", "n.e2") 

outfile<-paste0("중앙일보_인권_기사목록_", today, "_2020.csv")
write.csv(Stack, outfile, row.names=FALSE)






#####################################################################
## Step 3: Download article sources
#####################################################################

infile <- paste0("중앙일보_인권_기사목록_", today, "_2020.csv")
Data <- read.csv(infile, stringsAsFactors = FALSE)
news.link <- Data$link
news.id <- str_replace(news.link, "^http.*article/", "") ## 파일명을 일련번호 대신 기사 ID로 설정
n.item <- length(news.link)
n.item

start <- 1
end <- length(news.link)

for (i in start:end) {

  if (i%%100==1) print(paste("item", i, "is in process of scraping!"))
  baseURL <- news.link[i]
  
  outfile<-paste0("중앙일보_item_", news.id[i], ".html")
  if (file.exists(outfile)==TRUE) next() ## Skip if previous downloading was successful
  
  x <- try(readLines(baseURL,warn=FALSE))
  if (class(x)!="try-error") writeLines(x, outfile) ## try에서 error가 나지 않았다면 파일을 기록하기
  
  if (i%%2==1) Sys.sleep(1)
  
}




#####################################################################
### Step 4: 기사 콘텐츠 추출 후 Full Text 자료 생성하기
#####################################################################

infile <- paste0("중앙일보_인권_기사목록_", today,"_2020.csv")
Data <- read.csv(infile, stringsAsFactors = FALSE)
news.link <- Data$link
news.id <- str_replace(news.link, "^http.*article/","") ## 파일명을 일련번호 대신 기사 ID로 설정
n.item <- length(news.link);n.item


Stack <- NULL
error.count <- 0

start <- 1
end <- length(news.link)
end

for (i in start:end) {
  
  if (i%%200==1) print(paste("item", i, "is done"))
  
  infile <- paste0("중앙일보_item_", news.id[i], ".html")
  
  if (file.exists(infile)==TRUE) {
    
    txt <- readLines(infile, encoding="UTF-8", warn=FALSE)
    t_p <- htmlTreeParse(txt, useInternalNodes = TRUE, encoding="UTF-8")
    
    pattern <- "//div[@id='article_body']"
    e1 <- xpathSApply(t_p,pattern,xmlValue) %>% 
      str_replace_all("\n|\t","") %>% 
      str_trim() %>% 
      str_replace_all("  "," ") 
    
    pattern <- "//div[@class='article_head']//div[@class='byline']//em[2]"
    e2 <- xpathSApply(t_p,pattern,xmlValue) %>% 
      str_replace_all("\n|\t","") %>% 
      str_replace_all("입력 ","") %>% 
      str_trim() 
    e2 <- str_extract(e2,"^[0-9]{4}.[0-9]{2}.[0-9]{2}") 
    e2 <- as.Date(e2,format("%Y.%m.%d")) %>% format("%Y.%m.%d")
    
  } else {
    cat("File for item", i, "is not avilable!", "\n")
    error.count <- error.count+1
    e1 <- "Not Available"
    e2 <- "Not Available"
  }
  
  tab <- data.frame(cbind(e1, e2))
  Stack <- rbind(Stack, tab)
  
}


cat("Total number of times without source fils is", error.count)
rownames(Stack)<-NULL
Stack <- data.frame(Stack, stringsAsFactors=FALSE) ## 데이터프레임으로 변경 후에 저장.
names(Stack) <- c("content","pub.date")
Stack$id <- seq_len(nrow(Stack)) # 기사 일련번호 부여
Stack <- Stack[c("id","content","pub.date")]

outfile<-paste0("중앙일보_인권_content_", today, "_2020.csv")
write.csv(Stack, outfile, row.names = FALSE)




############################################################
### Step 5: list와 content data 합쳐 최종 데이터 생성하기
############################################################

infile <- paste0("중앙일보_인권_기사목록_", today, "_2020.csv")
D1 <- read.csv(infile, stringsAsFactors = FALSE)

infile<-paste0("중앙일보_인권_content_",today,"_2020.csv")
D2 <- read.csv(infile, stringsAsFactors = FALSE)

D <- merge(D1, D2, by="id")
outfile <- paste0("중앙일보_인권_DB_", today, "_2020.csv")
write.csv(D, outfile, row.names=FALSE)

outfile <- paste0("중앙일보_인권_DB_", today, "_2020.xlsx")
write.xlsx(D, outfile, row.names=FALSE)


