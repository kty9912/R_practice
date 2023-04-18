library(tidyverse); library(lubridate)

rm(list=ls())

# 날짜가 섞여 있을때 일관되게 표시하는 방법을 논의하기 위해
# 아래의 자료를 불러들이기

islam <- read.csv('djislam.csv')
islam <- islam %>% arrange(Date)

# islam에서 date가 mm/dd/yy 와 yyyy-mm-dd의 두개로 되어 있음.
# 이를일관된 날짜로 사용하기 위해서 lubridate 패키지의
# parse_date_time 함수를 이용

islam$Date <- parse_date_time(islam$Date, c("%m/%d/%y", "%y-%m-%d"),
                    exact=TRUE, tz="UTC") 
islam <- islam %>% arrange(Date)