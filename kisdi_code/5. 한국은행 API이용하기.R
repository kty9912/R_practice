#if (!require(devtools)) install.packages("devtools"); require(devtools)
#devtools::install_github("seokhoonj/ecos", force = TRUE)

#if(!require(patchwork)) install.packages("patchwork")
#if(!require(ggfortify)) install.packages("ggfortify")

rm(list=ls())

library(ecos); library(xts); library(tidyverse); library(patchwork); library(lubridate); library(stargazer); library(ggfortify)


# 한국은행 자료 코드는 아래에서 확인할 수 있음
# https://ecos.bok.or.kr/api/#/DevGuide/StatisticalCodeSearch

# 한국은행 OPEN API를 이용하기 위해서는 Key를 부여받아야 하는데, 아래의 링크에서 신청해서 받을 것
# https://ecos.bok.or.kr/api/#/AuthKeyApply
my_key <- c('MOSOME29TC3PEN7A7QF8')

# 우선 통계표[코드][주기]에 있는 코드가 stat_code가 되고
# 통계항목[코드][단위]에 있는 코드가 item_code1 임.
# 그리고 원계열, 계절조정 자료 선택은 item_code2에서 정하면 되며, 필요시 item_code3, item_code4까지 확장 가능
# 주기는 cycle로 해서 "D", "M", "Q", "Y" 단위로 추출 가능
# 날짜변수를 text로 불러오기 때문에 이후에 날짜함수로 변경해줄 필요가 있음 (lubridate패키지 이용): year의 경우는 year()함수를, 분기의 경우 yq(), 월의 경우 ym(), 일별자료의 경우 ymd() 함수 사용


# 월별 및 분기자료 불러오기: 콜금리(1.3.2.2 시장금리(월,분기,년)->무담보콜금리 전체)
# (일별자료의 시작날짜(start_time)를 지정하지 않으면 자료가 많기 때문에 에러가 날 수도 있음)
call_m <- statSearch(api_key = my_key, stat_code = "721Y001", item_code1 = "1020000", cycle="M")

str(call_m)
# 위에서 불러온 call_m을 보면 우리가 필요한 자료는 time과 data_value임. 그리고 time은 문자로 되어 있어서 lubridate 패키지의 ym()함수를 이용해서 날짜로 변환

call_m <- call_m %>% select(time,data_value) %>% mutate(time=ym(time))
names(call_m) <- c("date","call_m")
str(call_m)

# 시계열자료는 xts함수를 이용해서 만들 수 있음

tscall_m <- xts(call_m$call_m, order.by=call_m$date)
#names(tscall_m) <- "월별 콜금리 추이"
autoplot(tscall_m)+ggtitle("월별콜금리")+xlab("년도")+ylab("%")

# 이제 동일한 콜금리에 대해서 분기별 자료 가져오기
call_q <- statSearch(api_key = my_key, stat_code = "721Y001", item_code1 = "1020000", cycle="Q")

str(call_q)

# 분기자료의 경우는 날짜가 2000Q1식으로 되어 있는데, lubridate 패키지의 yq()함수를 이용하면 날짜로 인식됨

call_q <- call_q %>% select(time,data_value) %>% mutate(time=yq(time))
names(call_q) <- c("date","call_q")
str(call_q)

# 시계열자료는 xts함수를 이용해서 만들 수 있음
tscall_q <- xts(call_q$call_q, order.by=call_q$date)
autoplot(tscall_q)+ggtitle("분기 콜금리")

# 월별 소비자물가 자료 불러오기: 4.2.1 소비자물가지수(901Y009) -> 총지수(0)
cpi_m <- statSearch(api_key = my_key, stat_code = "901Y009", item_code1 = "0", cycle="M")
cpi_m <- cpi_m %>% select(time,data_value) %>% mutate(time=ym(time))
names(cpi_m) <- c("date","cpi_m")
str(call_q)

# 시계열자료는 xts함수를 이용해서 만들 수 있음
tscpi_m <- xts(cpi_m$cpi_m, order.by=cpi_m$date)
aa <- autoplot(tscpi_m)+ggtitle("CPI")

# 인플레이션 계산하기: 전년 동기대비
# stats패키지의 기본함수인 lag함수가 잘못되어 있기 때문에, xts패키지의 lag.xts를 쓴다고 명시를 할 필요가 있음
inf_m <- 100*(tscpi_m/lag.xts(tscpi_m,12)-1)
bb <- autoplot(inf_m)+ggtitle("Inflation")+ylab("%")

aa | bb

aa / bb

# 산업생산자료 가져오기: 산업생산자료의 경우 원계열과 계졸조정을 선택하는데 있어서 item_code2를 사용 (8.1.4. 전산업생산지수(농림어업제외)(901Y033)->전산업생산지수(A00))->계절조정(2)
ind_m <- statSearch(api_key = my_key, stat_code = "901Y033", item_code1 = "A00", item_code2 = "2", cycle="M")
ind_m <- ind_m %>% select(time,data_value) %>% mutate(time=ym(time))
names(ind_m) <- c("date","ind_m")
str(ind_m)

# 시계열자료는 xts함수를 이용해서 만들 수 있음
tsind_m <- xts(ind_m$ind_m, order.by=ind_m$date)
autoplot(tsind_m)


# GDP자료 가져오기 (2.1.2.2.2 국내총생산에 대한 지출(계절조정, 실질, 분기))(200Y008)-> 국내총생산에 대한 지출(10601)
gdp <- statSearch(api_key = my_key, stat_code = "200Y008",item_code1 = "10601", cycle="Q")

gdp <- gdp %>% select(time,data_value) %>% mutate(time=yq(time))
names(gdp) <- c("date","gdp")
str(gdp)

# 시계열자료는 xts함수를 이용해서 만들 수 있음
tsgdp <- xts(gdp$gdp, order.by=gdp$date)
autoplot(tsgdp)

# 월별 xts자료들 merge하기
mergem <- merge(tscall_m,inf_m) %>% merge(tsind_m)

# na.omit()을 이용해서 NA가 있는자료는 모두 삭제
mergem <- na.omit(mergem)
autoplot(mergem)

ols1 <- lm(log(tsind_m)~tscall_m +inf_m, mergem)

stargazer(ols1,type="html", keep.stat = c("n","adj.rsq"), out="OLS결과.doc")

# 금리 계수가 -0.117로 나오는데 해석은 다음과 같음
# ln(Y)=beta*X -> dlny/dX=beta -> (dy/y)*100 / 100*dX=beta
# -> %y/dx=100*beta
# 금리는 %로 기록이 되어 있기 때문에, 금리가 1단위(1%p) 증가하면 생산은 -11.7% 감소한다고 해석.

head(mergem,3)
autoplot(mergem)

p1 <- ggplot(mergem) + geom_line(mapping = aes(x=Index,y=tscall_m), color = "red") +
  ggtitle("콜금리") + 
  xlab("time") + 
  ylab("")


p2 <- ggplot(mergem) + geom_line(mapping = aes(x=Index,y=inf_m), color = "blue") + ggtitle("인플레이션(%)") + 
  xlab("time") + ylab("")

p3 <- ggplot(mergem) + geom_line(mapping = aes(x=Index,y=tsind_m,), color = "purple") + ggtitle("산업생산지수") + 
  xlab("time") + ylab("")

# patchwork 패키지를 설치하면, 아래와 같이 간단한 명령으로 
# 그림을 구성할 수 있음

p1 / p2 / p3

p1 | p2 | p3

(p1 / p2) | p3

(p1 | p2) / p3

# 데이터프레임으로 된 자료들 merge하기

mframe <- merge(cpi_m,ind_m) %>% merge(call_m)
str(mframe)

# 데이터프레임에서는 autoplot을 이용해서 그림을 그릴 수 없고 ggplot을 이용

mframe %>% ggplot(mapping=aes(x=date,y=cpi_m))+geom_line()+geom_point()+ylab("소비자물가지수")

# 데이터프레임을 시계열(xts) 자료로 변환하기 위해서는 1열에 있는 날짜를 order.by에 지정해 주고, 그 외의 변수들을 시계열자료로 변환하면 됨
mxts <- as.xts(mframe[,-1], order.by = mframe[,1])
str(mxts)

#xts에서는 autoplot을 이용해서 그림을 그릴 수 있음
autoplot(mxts)
autoplot(mxts$cpi_m)+ggtitle("CPI")

# ts로 변환하기 위해서는 시작날짜와 주기를 지정하면 됨
mts <- ts(mxts, start=c(2000,1), frequency = 12)
str(mts)

#ts에서는 autoplot을 이용해서 그림을 그릴 수 없으나, ggfortify패키지를 이용하면 autoplot을 이용할 수 있음
# ts로 변환이 되면 변수들은은 변수별로 인식이 되는 것이 아니라 행렬로 인식이 됨

autoplot(mts)
autoplot(mts[,"call_m"])+ggtitle("연도별 콜금리 변화추이")+xlab("년도")+ylab("콜금리(%)")

autoplot(mts[,3])+ggtitle("연도별 콜금리 변화추이")+xlab("년도")+ylab("콜금리(%)")
