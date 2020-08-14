library(XML)

# 1. 드러난 URL을 그대로 복사해서 사용하는 경우 – 본문은 들어있지 않음

url <- "http://blog.naver.com/aeg004/220593307384"
txt <- readLines(url, encoding="UTF-8", warn=F)
length(txt)
txt


# 2. 본문이 있는 링크 찾아서 사용하는 경우

url2 <-"https://blog.naver.com/PostView.nhn?blogId=aeg004&logNo=220593307384&redirect=Dlog&widgetTypeCall=true&directAccess=false"
txt <- readLines(url2, warn=F)
length(txt)
head(txt, 50)
txt_p <- htmlParse(txt)
xpathSApply(txt_p, "//div[@id='postViewArea']", xmlValue)
