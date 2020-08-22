library(XML)
library(stringr)

api_trade <- "http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTradeDev"
api_key <- "S9OJmSyHyTlBPpm%2FpNgQYIRTgeDUOP1vGEVFBbioropGAKd%2FOOlHzQnW7645uLwwvOL%2BSrDN5Fbk1Z8vvA7SjA%3D%3D"

numOfRows <- 40
pageNo <- 1
lawd_cd <- 11680  # 11680 : Gangnam-gu, check "https://www.code.go.kr/stdcode/regCodeL.do" for more codes
deal_ymd <- 202007
url <- str_c(api_trade,
             "?serviceKey=", api_key,
             "&numOfRows=", numOfRows,
             "&pageNo=", pageNo,
             "&LAWD_CD=", lawd_cd,
             "&DEAL_YMD=", deal_ymd
             )

url

# XML 파일 살펴보기
xmlFile <- xmlParse(url)
xmlRoot(xmlFile)
selected.nodes <- getNodeSet(xmlFile, "//items/item")

# XML 문서를 데이터 프레임으로 변환
df <- xmlToDataFrame(selected.nodes)
df
#View(df)
