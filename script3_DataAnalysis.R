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
