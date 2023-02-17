#=================================================================#
# R을 이용하여 주가자료 가져오기 
# quantmod 패키지의 getSymbols() 함수를 이용하여
# 개별주가 및 전세계 주가지수 불러오기
# 또한 getSymbols()함수를 이용하여 FRED의 거시자료(금리, 유가 등)
# 불러올 수도 있음
# 주가코드(ticker)는 야후, 구글검색 등을 통해 구할 수 있음
#=================================================================#
library(quantmod); library(xts); library(ggplot2)
library(dplyr); library(lubridate); library(tidyr)
library(patchwork); library(ggfortify); library(zoo)
library(stargazer)


rm(list=ls())

# Data Range (자료의 범위를 지정하고 싶으면 아래와 같이 하면 됨)
# sdate <- as.Date("2018-07-01")
# edate <- as.Date("2022-03-01")


# 야후에서 제공하는 글로벌 주가지수 (개별기업 주가도 검색해서 불러올 수 있음)
# https://finance.yahoo.com/world-indices/

# 중국의 증권거래소는 상해와 선전이 있는데, 상해는 전통산업위주
# 선전은 기술주, 중소형주 위주
# ticker는 중국은 000001.SS (상해), 399001.SZ (선전), ^HSI (홍콩 항셍)
# 한국은 ^KS11 (KOSPI), ^KQ11 (KOSDAQ)
# 일본은 ^N225 (Nikkei)
# 미국은 ^GSPC (S&P 500), ^DJI (Dow 30), ^IXIC (Nasdaq)
# 유럽은 ^STOXX (STXE 600 PR.EUR)
# 변동성은 ^VIX (CBOE Volatility Index)
# 유가선물은 CL=F (Crude Oil Futures: NY Mercantile)


# 주가 자료 불러오기: 한국 KOSPI, 일본 NiKKEI225, 중국 상해,
# 미국 S&P500, 유럽 STOXX 불러오기 (검색엔진을 지정하지 않으면 야후에서
# 검색함)

s_kr=getSymbols('^KS11',auto.assign = F)

# 만약 특정한 날짜범위로 다운로드 하고 싶으면 아래와 같이 from, to를 쓰면 됨
# s_kr=getSymbols('^KS11',from=sdate,to=edate,auto.assign = F)
# 월별 자료를 받고 싶으면 아래와 같이 주기를 입력하면 됨
# 월말(마지막날)의 값을 return 함
# s_kr_monthly=getSymbols('^KS11',periodicity="monthly",auto.assign = F)

# 출력된 값을 보면 4번째 변수가 종가(closing)를 포함하고 있어서 
# 4번째만 선택
s_kr <- s_kr[,4]
names(s_kr) <- "KOSPI"


s_jp=getSymbols('^N225',auto.assign = F)
s_jp <- s_jp[,4]
names(s_jp) <- "NIKKEI"

s_cn=getSymbols('000001.SS',auto.assign = F)
s_cn <- s_cn[,4]
names(s_cn) <- "SHANGHAI"

s_us=getSymbols('^GSPC',auto.assign = F)
s_us <- s_us[,4]
names(s_us) <- "SP500"

s_eu=getSymbols('^STOXX',auto.assign = F)

s_eu <- s_eu[,4]
names(s_eu) <- "STOXX_EU"

s_daily <- merge(s_kr,s_jp) %>% merge(s_cn) %>% merge(s_us) %>% merge(s_eu)

# 이제 merge된 자료를 보면 NA가 들어가 있는 부분이 존재: NA가 들어간 부분은 이전날의 값을 넣기로 하기 위해 아래와 같이 zoo 패키지의 na.locf()함수를 이용
# (na.locf()는 처음 값들에 대해서는 변환을 안함: 이는 제일 처음 NA 관측치들은 이전값들이 없기 때문)

s_daily2 <- na.locf(s_daily)

# 이제 맨 앞의 NA관측치들은 삭제하기 위해 행별로 관측치가 있는것만을 선택

s_daily <- s_daily2[complete.cases(s_daily2),]

g1 <- autoplot(s_daily$KOSPI, ylab="KOSPI", colour = "red")
g2 <- autoplot(s_daily$NIKKEI, ylab="Nikkei225", colour = "blue")
g3 <- autoplot(s_daily$SHANGHAI, ylab="Shanghai", colour = "purple")
g4 <- autoplot(s_daily$SP500, ylab="S&P500", colour = "black")
g5 <- autoplot(s_daily$STOXX_EU, ylab="EUROPE", colour = "yellow")

(g1 | g2 | g3) / (g4 | g5)

ggsave("stock1.png", dpi=300,
       width=10, height=8, units="in")

# 미국 주가 2개 (Tesla와 Apple), 한국 주가 2개 (현대, 삼성)
# 
# Tesla (TSLA), APPLE (AAPL), 
# Samsung Electronics (005930.KS), Hyundai (005380.KS)

# 날짜는 2020년 1월부터 시작
sdate <- as.Date("2020-01-01")
#edate <- as.Date("2022-08-02")

s_tesla=getSymbols('TSLA',from=sdate,auto.assign = F)
s_tesla <- s_tesla[,4]
names(s_tesla) <- "TESLA"

s_apple=getSymbols('AAPL',from=sdate,auto.assign = F)
s_apple <- s_apple[,4]
names(s_apple) <- "APPLE"

s_samsung=getSymbols('005930.KS',from=sdate,auto.assign = F)
s_samsung <- s_samsung[,4]
names(s_samsung) <- "SAMSUNG"

s_hyundai=getSymbols('005380.KS',from=sdate,auto.assign = F)
s_hyundai <- s_hyundai[,4]
names(s_hyundai) <- "HYUNDAI"

s_co <- merge(s_tesla,s_apple) %>% merge(s_samsung) %>% merge(s_hyundai)

# 이제 merge된 자료를 보면 NA가 들어가 있는 부분이 존재: NA가 들어간 부분은 이전날의 값을 넣기로 하기 위해 아래와 같이 zoo 패키지의 na.locf()함수를 이용

s_co2 <- na.locf(s_co)

# 이제 맨 앞의 NA관측치들은 삭제하기 위해 행별로 관측치가 있는것만을 선택

s_co <- s_co2[complete.cases(s_co2),]

c1 <- autoplot(s_co$TESLA, ylab="TESLA", colour = "red")
c2 <- autoplot(s_co$APPLE, ylab="APPLE", colour = "blue")
c3 <- autoplot(s_co$SAMSUNG, ylab="SAMSUNG ELEC.", colour = "purple")
c4 <- autoplot(s_co$HYUNDAI, ylab="HYUNDAI MOTORS", colour = "black")


(c1 | c4 ) / (c2 | c3)

ggsave("stock2.png", dpi=300,
       width=10, height=8, units="in")

# 이제 초기시점대비 주가가 얼마나 변화했는지를 살펴보기 위해서 apply() 함수를 이용하여 지수화. 1은 행단위로, 2는 열단위로 계산하라는 의미이며, 2020년 1월 2일을 100으로 하기 위해서 xts에서 날짜가 들어가 있는 index에서 날짜에 해당되는 값을 사용

s_co3 <- apply(s_co, 2, function(y) 100 * y / y[index(s_co)=="2020-01-02"])
s_co3 <- as.xts(s_co3)
# 처음이 2020년 1월 2일이면 first() 함수 혹은 첫번째 변수인 y[1]을 사용해도 됨

s_co31 <- apply(s_co, 2, function(y) 100 * y / first(y))
s_co31 <- as.xts(s_co31)

s_co32 <- apply(s_co, 2, function(y) 100 * y / y[1])
s_co32 <- as.xts(s_co32)


# 2022년 1월 3일을 기준으로 할 수도 있음
s_co4 <- apply(s_co, 2, function(y) 100 * y / y[index(s_co)=="2022-01-03"])
s_co4 <- as.xts(s_co4)

d1 <- autoplot(s_co3$TESLA, ylab="TESLA", colour = "red")
d2 <- autoplot(s_co3$APPLE, ylab="APPLE", colour = "blue")
d3 <- autoplot(s_co3$SAMSUNG, ylab="SAMSUNG ELEC.", colour = "purple")
d4 <- autoplot(s_co3$HYUNDAI, ylab="HYUNDAI MOTORS", colour = "black")

# patchwork 패키지를 이용하면 그림을 행렬형태로 그릴 수 있음
(d1 | d4) / (d2 | d3)


ggsave("stock3(지수화).png", dpi=300,
       width=10, height=8, units="in")


# 주가자료를 일반적으로 로그를 취하고, 
# 자료의 안정성을 위해 로그 차분을 함
# 전세계 주가자료인 s_daily를 이용하여 로그를 취하고
# 로그차분

slog <- log(s_daily)
sldif <- diff(slog,1)

# 여기에 FRED에서 거시변수를 불러와서 최종적으로 
# 전세계 주가지수 자료에 붙이기 (아래에서 검색)
# https://fred.stlouisfed.org/
# 일별 연방기금 금리(Federal Funds Effective Rate (DFF)), 
# 서부중질유 현물가격(Spot Crude Oil Price: 
# West Texas Intermediate (WTI) (DCOILWTICO))


ffr=getSymbols('DFF',src="FRED",auto.assign = F)
names(ffr) <- "FFR"
wti_s=getSymbols('DCOILWTICO', src="FRED",auto.assign = F)
names(wti_s) <- "WTI_SPOT"

macro <- merge(ffr,wti_s)

# 이제 전세계 주가자료와 거시자료를 통합

all <- merge(s_daily,macro)

# 이제 merge된 자료를 보면 NA가 들어가 있는 부분이
# 존재: NA가 들어간 부분은 이전날의 값을 넣기로 하기
# 위해 아래와 같이 zoo 패키지의 na.locf()함수를 이용

all <- na.locf(all)

# 이제 맨 앞의 NA관측치들은 삭제하기 위해
# 행별로 관측치가 있는것만을 선택

all <- all[complete.cases(all),]

# 자료들에 로그취하고 로그차분하여, 변수들간의 관계
# (correlation) 살펴보기 (이자율은 로그를 취하지 않음)
# 먼저, 모든 변수들에 대해 로그 취하고, 이자율은
# 다시 exp()함수를 이용하여 원변수로 변환하는게 편리
lall <- log(all)
lall$FFR <- exp(lall$FFR)

ldall <- diff(lall,1)

# 마지막으로 변수들의 로그값과 로그차분과의 
# 상관관계 살펴보기 (Hmisc 패키지 이용)

library(Hmisc)
cor_level <- rcorr(as.matrix(lall))
corr1 <- cor_level
corr2 <- round(corr1[["r"]],3)
# 상관관계 계수값과 P값은 아래와 같이 뽑을 수 있음
# 소수점 3째자리로 제한하기 위해 round()함수 이용
round(cor_level$r, 3)
round(cor_level$P, 3)


# 일별자료를 월별자료로 변환
# XTS 패키지내 apply.monthly(), apply.quarterly(), apply.year()를 
# 이용하면 매우 편리, R에서 사용하는 함수 다 됨 (평균, 표준편차 등..)

all_monthly <- apply.monthly(all,mean)

# 이제 모든 변수에 로그를 취하고, 금리는 이후에 다시 exp를 이용해서 
# 원상태로 변환
all_monthly <- log(all_monthly)
all_monthly$FFR <- exp(all_monthly$FFR)


# 마지막으로 간단한 회귀식 구해 보기 (KOSPI에 다른 변수들이 미치는 영향)

model1 <- lm(KOSPI~FFR+WTI_SPOT+SP500, data=all_monthly)
model2 <- lm(KOSPI~FFR+WTI_SPOT+SP500+STOXX_EU, data=all_monthly)
model3 <- lm(KOSPI~FFR+WTI_SPOT+SP500+STOXX_EU+NIKKEI+SHANGHAI, data=all_monthly)

# 추정결과를 Stargazer 패키지를 이용해서 테이블로 정리
# Stargazer 옵션에서 html을 지정해야 테이블이 깔끔하게 워드파일로 정리됨

stargazer(model1, model2, model3, type="html", out="결과물.doc",
          keep.stat=c("n","adj.rsq"))

# 한편, 일반적으로 요약통계량은 차분한 자료를 이용(로그차분=변화율)
# 요약통계량을 stargazer를 통해서 워드파일로 저장하려면 
# data.frame으로 변환시켜야 함

all_monlthly_diff <- diff(all_monthly,1)
all_monlthly_diff <- as.data.frame(all_monlthly_diff)

stargazer(all_monlthly_diff, type="html", out="통계.doc")
