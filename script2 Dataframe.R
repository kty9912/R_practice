# 데이터프레임

# 변수 만들기
english <- c(90,80,60,70)
english
math <- c(50,60,100,20)
math

# english, math로 데이터프레임 생성해서 df_midterm에 할당
df_midterm <- data.frame(english, math)
df_midterm

# 학생 반 정보 추가
class <- c(1,1,2,2)
class

df_midterm <- data.frame(english, math, class)
df_midterm

# 분석하기
mean(df_midterm$english)   # df_midterm의 english로 평균 산출
# $로 변수지정

mean(df_midterm$math)      # df_midterm의 math로 평균 산출


# 데이터프레임 한번에 만들기
df_midterm <- data.frame(english=c(90,80,60,70),
                         math=c(50,60,100,20),
                         class=c(1,1,2,2))
df_midterm


# 혼자서 해보기
df <- data.frame(제품 = c("사과", "딸기","수박"),
                 가격 = c(1800, 1500, 3000),
                 판매량 = c(24, 38, 13))
df
mean(df$가격)
mean(df$판매량)


# readxl 패키지 설치,로드
install.packages("readxl")
library(readxl)

# df_exam <- read_excel("excel_exam.xlsx")
# df_exam

# 경로 지정
df_exam <- read_excel("D:/easy_r/R_practice/data/excel_exam.xlsx")
df_exam

mean(df_exam$english)
mean(df_exam$science)

# 첫 행이 변수명이 아니라 데이터로 시작하면?
df_exam_novar <- read_excel("data/excel_exam_novar.xlsx")
df_exam_novar
# 첫 행을 데이터로 인식 /  F(False)를 대문자로 입력해야
df_exam_novar <- read_excel("data/excel_exam_novar.xlsx",
                            col_names=F)
df_exam_novar


# 엑셀 파일의 세번째 시트에 있는 데이터 불러오기(sheet 파라미터)
df_exam_sheet <- read_excel("data/excel_exam_sheet.xlsx", sheet=3)

# csv 파일 불러오기   R 자체 내장 패키지 read.csv()
df_csv_exam <- read.csv("data/csv_exam.csv")
df_csv_exam
# 첫 행 데이터로 넣을려면 파라미터 header=F 



# 데이터프레임을 csv파일로 저장하기

# 데이터프레임 만들기
df_midterm <- data.frame(english = c(90,80,60,70),
                         math = c(50,60,100,20),
                         class = c(1,1,2,2))
df_midterm

# R 내장 함수인 write.csv() 사용, file 파라미터로 파일명 지정
write.csv(df_midterm, file = "data/df_midterm.csv")

# R 전용 데이터 파일인 RDS 파일 활용
saveRDS(df_midterm, file = "data/df_midterm.rds")

# df_midterm 변수데이터 삭제
rm(df_midterm)

df_midterm

# RDS파일 불러오기
df_midterm <- readRDS("data/df_midterm.rds")
df_midterm
