library(dplyr)
library(stringr)
library(rvest)
library(RSelenium)
library(knitr)
library(kableExtra)

## Google scholar
rD <- rsDriver(port=4723L, chromever="83.0.4103.39") 
# rD <- rsDriver(port=4721L, chromever="84.0.4147.30")

remDr <- rD$client

URL <- "https://www.youtube.com/c/ArirangCoKrArirangNEWS/videos"
remDr$navigate(URL)

txt <- remDr$getPageSource()[[1]]
res <- read_html(txt)

title <- res %>%
  html_nodes("#video-title") %>%
  html_text() %>% 
  str_remove("\n") %>% 
  str_trim()

link <- res %>%
  html_nodes("#video-title") %>%
  html_attr("href") %>%
  str_c("https://www.youtube.com", .)

date <- res %>%
  html_nodes("#metadata-line > span:nth-child(2)") %>%
  html_text()

length <- res %>%
  html_nodes("#overlays > ytd-thumbnail-overlay-time-status-renderer > span") %>%
  html_text() 

tbl <- cbind(date, title, length, link) %>%
  as.data.frame(stringsAsFactors=FALSE)

df <- tbl %>%
  mutate(title.link = cell_spec(title, "html", link = link, color="#062872")) %>%
  select(date, title.link, length)

names(df) <- c("Date", "Title", "Length")

df %>% head(15) %>%
  kable(format="html", escape=FALSE) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>%
  column_spec(1, width = "6em") %>%
  column_spec(2, width = "35em") %>%
  column_spec(3, width = "6em")



remDr$close()
rD$server$stop()
