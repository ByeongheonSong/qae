# 9.3 미세먼지 농도의 시간대별 변화: 막대 그래프

# 미세먼지 XML 문서 출력

library(XML)
library(stringr)

api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
api_key <- "S9OJmSyHyTlBPpm%2FpNgQYIRTgeDUOP1vGEVFBbioropGAKd%2FOOlHzQnW7645uLwwvOL%2BSrDN5Fbk1Z8vvA7SjA%3D%3D"

numOfRows <- 10
pageNo <- 2
itemCode <- "PM10"
dataGubun <- "HOUR"
searchCondition <- "MONTH"
url <- str_c(api,
             "?serviceKey=", api_key,
             "&numOfRows=", numOfRows,
             "&pageNo=", pageNo,
             "&itemCode=", itemCode,
             "&dataGubun=", dataGubun,
             "&searchCondition=", searchCondition,
             sep="")

url

# XML 파일 살펴보기
xmlFile <- xmlParse(url)
xmlRoot(xmlFile)
selected.nodes <- getNodeSet(xmlFile, "//items/item")

# XML 문서를 데이터 프레임으로 변환
df <- xmlToDataFrame(selected.nodes)
df
