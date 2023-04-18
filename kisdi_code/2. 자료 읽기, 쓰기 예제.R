rm(list=ls())

# 아래와 같이 하면 에러가 나는데, 이는 R이 4.2가 되면서 기존의 CP949 포맷에서 UTF-8 포맷으로 변경되었기 때문임 (한글이 아닌 영문은 아래와 같이 해도 괜찮음)

#df.txt <- read.table("laborforce.csv",header=TRUE, sep=",")

df.txt <- read.table("laborforce.csv",header=TRUE, sep=",",fileEncoding = "CP949", encoding="UTF-8")

# 아래도 에러가 남.
#df.csv <- read.csv("laborforce.csv",header = TRUE, sep=",")

# 아래와 같이 해야 잘 읽혀짐
df.csv <- read.csv("laborforce.csv",header = TRUE, sep=",",
                   fileEncoding = "CP949", encoding = "UTF-8")


# tidyverse 안에 있는 readr 패키지를 이용해서 csv 불러오기기
library(tidyverse)

# 아래와 같이 하면 자료는 읽혀지는데, 글짜가 깨짐
df.csv2 <- read_csv("laborforce.csv")

# 아래와 같이 하면 자료가 잘 읽혀짐짐
df.csv3 <- read_csv("laborforce.csv", col_names = TRUE, locale=locale("ko",encoding="cp949"))

str(df.csv3)

# 엑셀 불러들이는 것은 readxl패키지의 read_excel() 함수를 이용하는 것이 좋음
# readxl 패키지를 설치하고, 라이브러리에 탑재
library(readxl); library(tidyr); library(dplyr)
df.xlsx <- read_excel("urbanpop.xlsx", sheet = 1)
str(df.xlsx)
df.xlsx <- gather(df.xlsx,"year","pop",2:ncol(df.xlsx)) %>% arrange(country,year) %>% na.omit()

# STATA 파일 불러오기

library(haven)
df.stata <- read_dta("auto.dta")
str(df.stata)


# 아래와 같이 다시 data.frame으로 지정하지 않으면 엑셀로 내보낼때 예쁘게 내보내지지 않음.
df.stata <- data.frame(df.stata)

# 엑셀파일로 내보내기
library(xlsx)

write.xlsx2(df.stata, "sdata.xlsx", sheetName = "Sheet1", col.names = T, row.names = F, append = FALSE)

# 같은 이름으로 같은 파일에 자료를 추가하고 싶으면, sheetName을 설정해 주고, append=TRUE로 하면 됨.

df.csv3 <- data.frame(df.csv3)
write.xlsx2(df.csv3, "sdata.xlsx", sheetName = "Sheet2", col.names = T, row.names = F, append = TRUE)


