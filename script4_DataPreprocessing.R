# dplyr 함수

library(dplyr)

exam <- read.csv("data/csv_exam.csv")
exam

exam %>% filter(class == 1)
