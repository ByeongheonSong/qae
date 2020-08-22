# 10.4 뉴스 검색: “인공지능” 키워드

# 뉴스 내용 다운로드

install.packages("RmecabKo")

library(XML)
library(wordcloud)
library(RmecabKo)
library(httr)

# C:/Rlibs/mecab 폴더가 없는 상태에서 실행 
install_mecab("C:/Rlibs/mecab")
library(RmecabKo)


# 1. XML로 받기

searchUrl <- "https://openapi.naver.com/v1/search/news.xml"
client_id <- "J6IqO88Vn4fR0yjfDAiR"
client_secret <- "eMSWL_Ta5L"

query <- URLencode(iconv("인공지능","euc-kr","UTF-8"))
url <- paste(searchUrl, "?query=", query, "&display=20", sep="")

res <- GET(url, 
           add_headers("X-Naver-Client-Id"=client_id, 
                       "X-Naver-Client-Secret"=client_secret))
doc <- toString(res)

# 뉴스 추출 및 단어 간 빈도 비교
xmlFile <- xmlParse(doc)
xmlRoot(xmlFile)
df <- xmlToDataFrame(getNodeSet(xmlFile, "//item"), stringsAsFactors = FALSE)
str(df)

description <- df[,4]
description

description2 <- description %>% 
  str_replace_all("<b>|</b>|&quot;", "")
description2




# 2. JSON으로 받기

searchUrl <- "https://openapi.naver.com/v1/search/news.json"
client_id <- "J6IqO88Vn4fR0yjfDAiR"
client_secret <- "eMSWL_Ta5L"

query <- URLencode(iconv("인공지능","euc-kr","UTF-8"))
url <- paste(searchUrl, "?query=", query, "&display=20", sep="")

res <- GET(url, 
           add_headers("X-Naver-Client-Id"=client_id, 
                       "X-Naver-Client-Secret"=client_secret))
doc <- toString(res)

return <- fromJSON(doc) 
df.json <- return$items




# 3. Word Cloud

nouns <- nouns(iconv(description2, "utf-8"))
nouns
nouns[[1]]

nouns.all <- unlist(nouns, use.names = F)
nouns.all

nouns.all1 <- nouns.all[nchar(nouns.all) <= 1]
nouns.all1

nouns.all2 <- nouns.all[nchar(nouns.all) >= 2]
nouns.all2  

nouns.freq <- table(nouns.all2)
nouns.freq

nouns.df <- data.frame(nouns.freq, stringsAsFactors = F)
nouns.df

nouns.df.sort <- nouns.df[order(-nouns.df$Freq), ] 
nouns.df.sort

wordcloud(nouns.df.sort[,1], 
          freq=nouns.df.sort[,2], 
          min.freq=3, 
          scale=c(3,0.7), 
          rot.per=0.25, 
          random.order=F,  
          random.color=T,
          colors=rainbow(10))
