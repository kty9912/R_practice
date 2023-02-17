# OECD 패키지를 이용해서 OECD 자료 불러오기
# 공식버전에는 버그가 있는 것 같고, 대신 아래의 링크를 통해 프로그램 설치할 것
# if(!require(remotes)) install.packages("remotes")
#remotes::install_github("https://github.com/expersso/OECD")

# https://stats.oecd.org에 접속해서 먼저 이용하고자 하는 DB를 선택하는 것이 더 편할 수 있음 (웹사이트에서 찾는 방법 시연(Export->XDMS(XML)->SDMX DATA URL 참조)
# dplyr은 변수를  변환해주고, tidyr은 자료의 구조를 변환(www.tidyverse.org 참조). tidyverse 패키지에 다 들어 있음
rm(list=ls())
library(OECD); library(tidyverse); library(lubridate); library(anytime)

# get_datasets()를 이용하여 OECD내에 있는 모든 DB의 이름만 가져오기
all <- get_datasets()

#검색하고자 하는 변수를 입력하여 저장하기
psearch <- search_dataset("productivity")

#psearch에 있는 PDBI_I4 (Productivity and ULC by main economic activity 
# (ISIC Rev.4)) 자료 이용
prod <- "PDBI_I4"

dstruc <- get_data_structure(prod)
# 변수가 무엇이 있는지 파악
subj <- dstruc$SUBJECT
countries <- dstruc$LOCATION
industry <- dstruc$ACTIVITY


# 이중에서 총부가가치(I4_ANA_GVA), 총고용(I4_ANA_EMPTO), 
# 총노동시간(I4_ANA_HRSTO), 단위노동비용(시간기준)(I4_ANA_ULCH), 
# 단위노동비용(고용기준)(I4_ANA_ULCE) 자료를 가져오기 (get_dataset()명령어)
# 2015년 기준 index (2015Y), 산업은 전산업(A_U), 제조업(C),
# 서비스업(GNEXCL)만 이용
# 필터적용은 자료구조의 순서(dstruc에 저장)대로 적용하며, 만약 두번째부터
# 필터를 적용할 경우 첫번째에는 NULL을 넣어야 함 (안그러면 Error 발생!!)

# dstruc을 보면, 첫번째에는 국가(location)가 들어오고, 두번째는 변수명(subject), 3번째는 측정방법(measure: 특정년도 기준, 변화율 등), 4번째는 산업명(activity: 제조업 등), 6번째는 시간(time) 등이 들어옴.
# 다른 건 몰라도 처음에 모든 국가를 지정하고자 할 경우에는 특별히 지정하지 않아도 되는데, 대신에 첫번재에는 국가검색을 생략할 경우 NULL이라고 쳐 줘야지 에러가 나지 않음.


filter_list=list(NULL,c("I4_ANA_GVA", "I4_ANA_EMPTO", "I4_ANA_HRSTO", "I4_ANA_ULCH",
          "I4_ANA_ULCE"), "2015Y", c("A_U","C", "GNEXCL"))

proddata <- get_dataset(dataset=prod, filter = filter_list)

# 이제 어느 국가가 있는지 살펴보기
unique(proddata$LOCATION)
unique(proddata$ACTIVITY)


# 개별국가가 아닌 샘플은 제외 (EU28, EA19, EU27_2020, NMEC)
proddata <- proddata %>% filter(LOCATION!="EU28" & LOCATION!="EA19" &
                                LOCATION!="EU27_2020" & LOCATION!="NMEC")
# 또는 아래와 같이 해도 됨
#proddata <- proddata[!(proddata$LOCATION=="EU28" | 
                       #proddata$LOCATION=="EA19" |
#                       proddata$LOCATION=="EU27_2020" |
                      #proddata$LOCATION=="NMEC"), ]
unique(proddata$LOCATION)

# 이제 필요한 자료만 선택해서 새로운 자료를 생성
proddata2 <- proddata %>% select(c("ACTIVITY", "LOCATION", "ObsValue",
                                   "SUBJECT", "Time"))
# 이제 SUBJECT내 세로로 나열된 변수들을  tidyr 패키지내 
# pivot_wider()함수를 이용해서 가로로 배치 

datafinal <- pivot_wider(proddata2, names_from=SUBJECT, values_from=ObsValue) %>% arrange(LOCATION, Time)

# 또는 spread를 이용해서도 wide-form으로 변환할 수 있음
#datafinal <- spread(proddata2, SUBJECT, ObsValue) %>% arrange(LOCATION, Time)

# 이제 변수이름을 바꾸기
names(datafinal)=c("industry", "country", "year", "emp","va", "hours",
                   "coste", "costh")

# str을 이용해서 살펴보면 year, emp, hours, costh, coste가 문자로 되어 있는데, 이를 숫자로 변환할 필요가 있음
str(datafinal)

# 4열부터 끝까지 문자로 된 것을 숫자로 변환
datafinal[,4:ncol(datafinal)] <- apply(datafinal[,4:ncol(datafinal)], 2, 
                                       function(x) as.numeric(x))

# 아래는 연도(year)가 문자로 되어 있는데, 이를 날짜로 변경시키는 방법임 (anytime 패키지의 anydate 함수를 이용)
# 패널자료를 구성하고자 할 경우에는 날짜로 변환시키 않고 숫자로 변환시켜도 됨

#datafinal <-  datafinal %>% mutate(year = anydate(year))

str(datafinal)

# 이제 자료가 하나라도 없는 행들은 삭제 (complete.cases이용)
# 또는 na.omit() 명령어를 써도 됨
datafinal <- datafinal[complete.cases(datafinal),]

# 노동생산성 자료 만들기 (부가가치/총고용 또는 부가가치/총시간)
datafinal <- datafinal %>% mutate(prodh=va/hours, prode=va/emp)                       


#마지막으로 산업별(전체, 제조업, 서비스업)로 새로운 DB 만들기

ind_all <- datafinal %>% filter(industry=="A_U")
ind_manu <- datafinal %>% filter(industry=="C")
ind_svc <- datafinal %>% filter(industry=="GNEXCL")
