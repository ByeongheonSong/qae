## https://beta.rstudioconnect.com/content/3132/Job_Scheduling_R_Markdown_Reports_via_R.html
## https://github.com/bnosac/taskscheduleR


library(taskscheduleR)

## Schedule 
report_auto = file.path("D:/OneDrive/1 Lecture Note/Morning_Letter.R")

## Daily
taskscheduler_create(taskname = "Letter_daily", rscript = report_auto,
                     schedule = "DAILY", 
                     starttime = "19:40", 
                     startdate = format(Sys.Date(), "%Y/%m/%d"))


## Hourly
taskscheduler_create(taskname = "Letter_hourly", rscript = report_auto,
                     schedule = "HOURLY",
                     starttime = format("14:00"),
                     startdate = format(Sys.Date(), "%Y/%m/%d"),
                     modifier = 1)

## By minute
taskscheduler_create(taskname = "Letter_minute", rscript = report_auto,
                     schedule = "MINUTE",
                     starttime = format(Sys.time() + 62, "%H:%M"),
                     startdate = format(Sys.time(), ""),
                     modifier = 3)



taskscheduler_delete("Daily_report")

taskscheduler_delete("Daily_report_hourly")

taskscheduler_delete("Daily_report_minute")


alltasks <- taskscheduler_ls()
check.task <- subset(alltasks, TaskName %in% c("Daily_report"))
