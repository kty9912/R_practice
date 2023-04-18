#if (!require(devtools)) install.packages("devtools"); require(devtools)
#devtools::install_github("seokhoonj/ecos", force = TRUE)

# if(!require(patchwork)) install.packages("patchwork")
# if(!require(ggfortify)) install.packages("ggfortify")

rm(list=ls())
library(ecos); library(xts); library(tidyverse); library(patchwork); library(lubridate); library(stargazer); library(ggfortify); library(ggrepel); library(xlsx)

# 한국은행 자료 코드는 아래에서 확인할 수 있음
# https://ecos.bok.or.kr/api/#/DevGuide/StatisticalCodeSearch

# 한국은행 OPEN API를 이용하기 위해서는 Key를 부여받아야 하는데, 아래의 링크에서 신청해서 받을 것
# https://ecos.bok.or.kr/api/#/AuthKeyApply
my_key <- c('VWCAV34ZSP4X0WENHQVG')

# 우선 통계표[코드][주기]에 있는 코드가 stat_code가 되고
# 통계항목[코드][단위]에 있는 코드가 item_code1 임.
# 그리고 원계열, 계절조정 자료 선택은 item_code2에서 정하면 되며, 필요시 item_code3, item_code4까지 확장 가능
# 주기는 cycle로 해서 "D", "M", "Q", "Y" 단위로 추출 가능
# 날짜변수를 text로 불러오기 때문에 이후에 날짜함수로 변경해줄 필요가 있음 (lubridate패키지 이용): year의 경우는 year()함수를, 분기의 경우 yq(), 월의 경우 ym(), 일별자료의 경우 ymd() 함수 사용

# GDP 구성요소 불러오기(연간)
# Y=C+I+G+NX=C+I+G+(EX-IM)
# 2.1.2.2.4 국내총생산에대한 지출(원계열, 실질): 200Y010 (단위: 십억원)
# 민간소비(C); 1010110
# 정부지출(G): 1010120
# 총고정자본형성(I): 10201
# 재화와 서비스의 수출(EX): 10301
# 재화와 서비스의 수입(IM): 10401
# 국내총생산에 대한 지출(Y): 10601

C <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "1010110", cycle="A")
C <- C %>% select(time,data_value)
names(C) <- c("date","C")

G <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "1010120", cycle="A")
G <- G %>% select(time,data_value)
names(G) <- c("date","G")

I <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "10201", cycle="A")
I <- I %>% select(time,data_value)
names(I) <- c("date","I")

EX <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "10301", cycle="A")
EX <- EX %>% select(time,data_value)
names(EX) <- c("date","EX")

IM <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "10401", cycle="A")
IM <- IM %>% select(time,data_value)
names(IM) <- c("date","IM")

# 통계상불일치
ER <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "10501", cycle="A")
ER <- ER %>% select(time,data_value)
names(ER) <- c("date","ER")

Y <- statSearch(api_key = my_key, stat_code = "200Y010", item_code1 = "10601", cycle="A")
Y <- Y %>% select(time,data_value)
names(Y) <- c("date","Y")

GDP_comp <- merge(C,I) %>% merge(G) %>% merge(EX) %>% merge(IM) %>% merge(Y)

GDP_comp <- GDP_comp %>% mutate(
  C_share=round(100*C/Y,1), 
  I_share=round(100*I/Y,1), 
  G_share=round(100*G/Y,1), 
  EX_share=round(100*EX/Y,1), 
  IM_share=round(100*IM/Y,1),
  C_growth=round(100*(C/lag(C)-1),1),
  I_growth=round(100*(I/lag(I)-1),1),
  G_growth=round(100*(G/lag(G)-1),1),
  EX_growth=round(100*(EX/lag(EX)-1),1),
  IM_growth=round(100*(IM/lag(IM)-1),1),
  Y_growth=round(100*(Y/lag(Y)-1),1),
  C_contribution=round(C_share*C_growth/100,1),
  I_contribution=round(I_share*I_growth/100,1),
  G_contribution=round(G_share*G_growth/100,1),
  EX_contribution=round(EX_share*EX_growth/100,1),
  IM_contribution=-round(IM_share*IM_growth/100,1)
  )
#write.xlsx(GDP_comp,"GDP_coponents.xlsx",row.names = FALSE)


# GDP 추이 및 GDP 성장률

GDP_comp2 <- GDP_comp %>% select(date, Y) %>% mutate(date=as.Date(date, format="%Y"), growth=round(100*(Y/lag(Y)-1),1)) 

d_min <- GDP_comp2 %>% select(date,growth) %>% filter(growth<0)

bgnd <- theme_get()$panel.background$fill
GDP_comp2 %>% ggplot(mapping=aes(x=date, y=growth))+geom_hline(yintercept = 0, color="orange")+geom_line(size=2)+geom_smooth(size=2)+geom_point(fill="black", shape=21, size=4, stroke=2, color=bgnd)+xlab("")+ylab("")+ggtitle("GDP Growth Rate of Korea (%)")+theme(text=element_text(size=15), plot.caption = element_text(vjust = 4, size = 15, face = "bold"))+scale_x_date(date_breaks = "10 years", date_labels = "%y")+geom_text_repel(aes(label = growth), data = d_min, fontface ="plain", color = "black", size = 6)+labs(caption = "(1980: Political Instability, 1998: Currency Crisis, 2020: COVID19)")

ggsave("GDP growth rate of Korea.png", dpi=300, width=10, height=8, units="in")

# 소비자 물가지수

CPI <- statSearch(api_key = my_key, stat_code = "901Y009", item_code1 = "0", cycle="M")
CPI <- CPI %>% select(time,data_value)
names(CPI) <- c("date","CPI")

CPI <- CPI %>% mutate(infl=round(100*(CPI/lag(CPI,12)-1),1))
CPI <- CPI %>% mutate(date=ym(date))

infl_cap <- CPI %>% select(date,infl) %>% filter(date>="2022-01-01")

CPI2 <- CPI %>% filter(date>="2017-01-01")

CPI2 %>% ggplot(mapping=aes(x=date, y=infl))+geom_rect(xmin=as.Date("2016-12-01"), xmax=as.Date("2023-03-01"), ymin=1.5, ymax=2.5, fill="gold", alpha=0.1, col="gold")+geom_line(size=2) + geom_point(fill="black", shape=21, size=4, stroke=2, color=bgnd)+xlab("")+ylab("")+ggtitle("Inflation of Korea (2017~)(%)")+theme(text=element_text(size=15), plot.caption = element_text(vjust = 4, size = 15, face = "bold"))+scale_x_date(date_breaks = "6 months", date_labels = "%y.%m")+geom_text_repel(aes(label = infl), data = infl_cap, fontface ="plain", color = "black", size = 8, max.overlaps = 20, nudge_x= 20, nudge_y=-1)

ggsave("Inflation rate of Korea.png", dpi=300, width=10, height=8, units="in")
