exam <- read.csv("data/csv_exam.csv")
exam

# 데이터 앞부분 확인
head(exam)
head(exam, 10) # 10행까지

# 데이터 뒷부분 확인
tail(exam)
tail(exam, 10)

# 뷰어 창에서 데이터 확인하기
View(exam)   # 맨 앞의 V 대문자 주의

# 데이터프레임 행 열 출력
dim(exam)

# 데이터 속성 확인
str(exam)

# 요약 통계량 출력
summary(exam)
# Min : 최솟값
# 1st Qu : 1사분위수
# Median : 중앙값
# Mean : 평균
# 3rd Qu : 3사분위수
# Max : 최댓값



# mpg 데이터 파악하기
# ggplot2의 mpg 데이터를 데이터 프레임 형태로 불러오기
mpg <- as.data.frame(ggplot2::mpg)

head(mpg)  # Raw 데이터 앞부분 확인
tail(mpg)  # Raw 데이터 뒷부분 확인
View(mpg)  # Raw 데이터 뷰어 창에서 확인
dim(mpg)   # 행, 열 출력
str(mpg)   # 데이터 속성 확인

# mpg 설명 글 출력 Help
?mpg

# 요약 통계량 출력
summary(mpg)


# 05-2 변수명 바꾸기
# dplyr 패키지의 rename()을 이용해 변수명 바꾸기
df_raw <- data.frame(var1 = c(1,2,1),
                     var2 = c(2,3,2))
df_raw

# dplyr 패키지 로드
library(dplyr)

# 데이터프레임 복사본 만들기
df_new <- df_raw
df_new

# 변수명 바꾸기
df_new <- rename(df_new, v2 = var2) # var2를 v2로 수정
df_new
# 원본과 비교
df_raw
df_new

# 혼자서 해보기
mpg <- as.data.frame(ggplot2::mpg)
mpg
mpg_new <- mpg
mpg_new
mpg_new <- rename(mpg_new, city=cty, highway=hwy)
head(mpg_new)


# 파생변수 만들기 (평균)
df <- data.frame(var1 = c(4,3,8),
                 var2 = c(2,6,1))
df

# var_sum 파생변수 생성
df$var_sum <- df$var1 + df$var2  
df

# var_mean 파생변수 생성
df$var_mean <- (df$var1 + df$var2)/2  
df

# 통합 연비 변수 생성
mpg$total <- (mpg$cty + mpg$hwy)/2
head(mpg)

# 통합 연비 변수 평균
mean(mpg$total)

# 조건문 활용 파생변수
# 요약 통계량 산출
summary(mpg$total) 

# 히스토그램 생성
hist(mpg$total)

# 조건문 함수
ifelse(mpg$total >= 20, "pass", "fail")
# (조건, 조건이 맞을때, 조건이 맞지 않을때)

# 20이상이면 pass, 그렇지 않으면 fail
mpg$test <- ifelse(mpg$total >=20, "pass", "fail")

head(mpg, 20)  # 데이터 확인

# 연비 합격 빈도표 생성
table(mpg$test)

# ggplot2 로드
library(ggplot2)

# 연비 합격 빈도 막대 그래프 생성
qplot(mpg$test)

# total을 기준으로 A, B, C 등급 부여
mpg$grade <- ifelse(mpg$total >= 30, "A",
                    ifelse(mpg$total >= 20, "B", "C"))
head(mpg,20)   # 데이터 확인

# 등급 빈도표 생성
table(mpg$grade)

# 등급 빈도 막대 그래프 생성
qplot(mpg$grade)


# 원하는 만큼 범주 만들기
# A, B, C, D 등급 부여
mpg$grade2 <- ifelse(mpg$total>=30, "A",
                     ifelse(mpg$total>=25, "B",
                            ifelse(mpg$total>20,"C","D")))
head(mpg,10)


# 정리하기 p.122
# 1.데이터 준비, 패키지 준비
mpg <- as.data.frame(ggplot2::mpg) # 데이터 불러오기
library(dplyr)                     # dplyr 로드
library(ggplot2)                   # ggplot2 로드
# 2.데이터 파악
head(mpg)      # Raw 데이터 앞부분
tail(mpg)      # Raw 데이터 뒷부분
View(mpg)      # Raw 데이터 뷰어 창에서 확인
dim(mpg)       # 차원
str(mpg)       # 속성
summary(mpg)   # 요약 통계량
# 3.변수명 수정
mpg <- rename(mpg, company=manufacturer)
# 4.파생변수 생성
mpg$total <- (mpg$cty + mpg$hwy)/2       # 변수 조합
mpg$test <- ifelse(mpg$total >= 20, "pass", "fail")  # 조건문 활용
# 5.빈도 확인
table(mpg$test)  # 빈도표 출력
qplot(mpg$test)   # 막대그래프 생성


# 분석 도전! p.123
midwest <- as.data.frame(ggplot2::midwest)
midwest
summary(midwest)
# library(dplyr)
midwest <- rename(midwest, total=poptotal, asian=popasian)
midwest
midwest$asian_ratio <- (midwest$asian/midwest$total)*100
hist(midwest$asian_ratio)
mean <- mean(midwest$asian_ratio)
midwest$mean_asian_ration <- ifelse(
  midwest$asian_ratio > mean,"large", "small")
midwest
table(midwest$mean_asian_ration)
# library(ggplot2)
qplot(midwest$mean_asian_ration)
