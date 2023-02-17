# tidyr 패키지: 자료의 구조를 변경 (변수를 변경하는 것은 dplyr)
# 강의노트관련 자료는 아래의 링크에서 다운로드해서 폴더로 만들고,
# R코드도 해당 폴더에 넣어서 작업을 할 것
# http://home.konkuk.ac.kr/~wjkim72/R_lecture_data.zip

rm(list=ls())

if(!require(devtools)) install.packages("devtools")
devtools::install_github("rstudio/EDAWR")
data(package="EDAWR")
library(EDAWR)

# 자료가 무엇인지 확인하기 위해서는 ?를 붙여 검색하거나,
# 오른쪽 아래창에 있는 help 창에서 검색
?storms
# 결핵증(tuberculosis: TB) 환자수
?cases
?pollution

# storm은 자료분석이 용이하게 변수값이 날짜순으로 아래로 주어짐
# dkfo :: 표시는 EDAWR 패키지의 storms를 이용하라는 의미임
# (R 패키지에는 중복/충돌되는 명령어 및 자료가 있어서 출처를 명확화)
EDAWR::storms

# cases는 날짜가 오른쪽으로 배열되어 있어서 날짜와 깂을 아래로 
# 정리할 필요가 있음
cases


# 아래로 만들려면 tidyr의 gather()함수 이용
if(!require(tidyr)) install.packages("tidyr")
library(tidyr)

# gather(cases, "year", "n", 2:4)는 다음을 의미
# cases: 형태를 변환할 데이터프래임명
# ”year”: 이전의 열이름(예: 2011, 2012, 2013)을 담는 key 열의 이름
# ”n”: 이전의 열(예: 2011, 2012, 2013)이 포함하고 있었던 값들의 이름
# 2:4: 변환할 열들의 이름 또는 숫자로 된 index (위에서는 2:4로 2열에서 
# 4열가지로 지정했지만 ”2011”:”2013”으로 지정해도 됨)
cases

cases2 <- gather(cases, "year", "n", 2:4)
cases2

# 또는 pivot_longer()를 이용해도 됨: 열이 많을 경우
#  ncol(cases)를 지정하면 cases에 있는 열의수만큼 이용
# 아래 표현은 모두 동일

cases3 <- pivot_longer(cases, cols = 2:ncol(cases), 
                       names_to="year", values_to = "n")
cases3

cases4 <- pivot_longer(cases, 2:ncol(cases), "year", "n")
cases4

# 아래는 첫번째 열만 빼고 나머지 열들을 다 이용하라는 의미
cases5 <- pivot_longer(cases, -1, names_to = "year", values_to = "n")
cases5

# 이제 아래와 같이 밑으로 이어진 변수를 오른쪽으로 넓게 수정
# city 변수만 빼고 나머지를 오른쪽으로 붙이기
# spread 또는 pivot_wider 이용

pollution

pollution2 <- spread(pollution,size,amount)
pollution2

pollution3 <- pivot_wider(pollution,names_from=size,
                          values_from=amount)
pollution3


# 날짜분리하고 싶으면 separate 이용하면 됨
EDAWR::storms

storms11 <- separate(storms, date, c("year","month","day"), sep="-")
storms11

# 날짜 다시 합치기 (.으로 구분)
storms22 <-unite(storms11, "date", year, month, day, sep=".")
storms22


# dplyr 사용법
library(dplyr)
lfp <- read.csv("laborforce.csv",header = TRUE,  sep=",", fileEncoding = "CP949", encoding = "UTF-8")

# select는 원하는 변수(열)를 선택
lfp.sub <- lfp %>% select(region, year, male, female)
head(lfp.sub, n=4)

# -는 그 변수만 빼라는 의미
lfp.sub <- lfp %>% select(-total)
head(lfp.sub)


# filter는 조건에 부합하는 행을 선택
lfp.seoul <- lfp %>% filter(region == "서울특별시")
head(lfp.seoul)

# 조건에 and, or , not equal 등의 표현은 강의노트 참조
lfp.seoul.2010 <- lfp %>% 
  filter(region == "서울특별시" & year > 2009)
head(lfp.seoul.2010, n=4)

# group_by()는 그룹별로 묶는데 사용, 특히 패널자료에서
# 그룹별로 계산할때 많이 사용

lfp %>% select(region, year, total) %>% 
  group_by(year) %>% head()

# summarise는 요약통계량: 기존의 변수들은 없어짐
lfp_summary <- lfp %>% select(region, year, total) %>% 
  group_by(year) %>%
  summarise(N = n(), mean = mean(total),sum = sum(total))
lfp_summary


# mutate() 함수는 새로운 변수를 만들 때 사용
lfp_summary2 <- lfp %>% select(region, year, total) %>% 
  group_by(year) %>%
  mutate(N = n(), mean = mean(total),sum = sum(total))
lfp_summary2

# arrange()는 변수를 정렬할때 사용
lfp_summary3 <- lfp %>% select(region, year, total) %>% 
  group_by(region) %>%
  mutate(N = n(), mean = mean(total),sum = sum(total)) %>% 
  arrange(region,year)
lfp_summary3


t.2 <- lfp %>%
  select(region, year, total, female) %>%
  mutate(lfp.ratio.female = female/total*100) %>%
  group_by(year) %>%
  summarise(N = n(),
              ratio.female = mean(lfp.ratio.female),
              sd = sd(lfp.ratio.female)) %>%
  ungroup()
# ungroup()은 group_by로 그룹을 지정한 것을 해제한다는 명령어임.

head(t.2)


# ggplot2 패키지

library(ggplot2)

lfp %>% select(region, year, total, female) %>%
  mutate(lfp.ratio.female = female/total*100) %>%
  group_by(year) %>%
  summarise(N = n(), ratio.female = mean(lfp.ratio.female),
              sd = sd(lfp.ratio.female)) %>%
  ggplot(mapping = aes(x = year, y = ratio.female)) +
  geom_point(size = 3) +
  geom_line() +
  geom_ribbon(aes(ymin=ratio.female-sd, ymax=ratio.female+sd),
                 alpha=0.2) +
  xlim(min = 2000, max = 2017) +
  ylim(min = 37, max = 45) + ylab("Female Ratio")
