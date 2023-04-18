rm(list=ls())
wav68 <- read.csv("wave68.out", header=T, sep="\t")
wav69 <- read.csv("wave69.out", header=T, sep="\t")
temp  <- merge(wav68, wav69)
# 또는 아래와 같이 명시적으로 merge의 조건을 지정해도 됨
#temp <- merge(x=wav68, y=wav69, by = c("idcode"))
str(temp)
library(dplyr)
head(temp %>% select("idcode", "age68", "age69", "ln_wage68", "ln_wage69"),10)

# 이름을 보면 변수명과 년도명이 섞여 있음
# 이름에서 변수명과 년도명을 중간에 점(.)을 찍어 분리
# 앞은 영문명, 뒤는 숫자를 의미

names(temp) <- gsub("([a-z])([0-9])", "\\1\\.\\2", names(temp))

# 첫번째 열은 id를 나타내니, 첫번째만 제외하고 나머지를 wide에서 long으로 변환시키고, 뒤에서 분리되는 숫자는 연도변수에 넣으라는 명령어는 아래와 같음. ncol(temp)는 temp의 마지막 열까지 적용시키라는 의미임.
long <- reshape(temp, direction = "long", varying = 2:ncol(temp),
                idvar="idcode", timevar="year")
                
long <- long %>% arrange(idcode,year)
long <- na.omit(long)


#만약 각 년도별 자료에서 변수명이 위와 같이 되어 있지 않고, 변수명이 문자로만 되어 있을 경우에는 각 년도별 데이터에 아래와 같이 year변수를 추가한 후 rbind 함수를 이용하여 아래로 분여 넣으면 됨 (merge는 옆으로 자료를 붙이고, rbind는 아래로 자료를 붙임)

# 먼저 wav68와 wav69 변수에 붙여 있는 숫자를 삭제하는 방법: stringr 패키지 이용

library(stringr)

wav68_2 <- wav68

my.data.cha68 <- str_extract(names(wav68_2), "[aA-zZ]+")
names(wav68_2) <- my.data.cha68
wav68_2 <- wav68_2 %>% mutate(year ="68")

wav69_2 <- wav69
my.data.cha69 <- str_extract(names(wav69_2), "[aA-zZ]+")
names(wav69_2) <- my.data.cha69
wav69_2 <- wav69_2 %>% mutate(year ="69")

data2 <- rbind(wav68_2, wav69_2)

data2 <- data2 %>% relocate(idcode,year) %>% arrange(idcode,year)

data2 <- na.omit(data2)

# 참고로 숫자만 뽑아내고 싶다면 아래와 같이 하면 됨
# my.data.num <- as.numeric(str_extract(my.data, "[0-9]+"))