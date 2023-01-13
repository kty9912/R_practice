a <- 1
a
b <- 2
b
c <- 3
c
d <- 3.5
d
a+b
a+b+c
4/b
5*b
var1 <- c(1,2,5,7,8) # 숫자 5개로 구성된 var1 생성
var1
var2 <- c(1:5) # 1~5까지 연속 값으로 var2 생성성
var2
var3 <- seq(1,5) # 1~5까지 연속 값으로 var3 생성
var3
var4 <- seq(1,10,by=2) # 1 ~ 10까지 2 간격 연속 값으로 var4 생성
var4
var5 <- seq(1,10,by=3) # 1~10까지 3 간격 연속 값으로 var5
var5
var1
var1+2
var1+var2
str1 <- "a"
str1
str2 <- "text"
str2
str3 <- "Hello World!"
str3
print(str3)
str4 <- c("a","b","c")
str4
str5 <- c("Hello!","World","is","good!")
str5
str1+2
# 변수 만들기
x <- c(1,2,3)
x
# 함수 적용하기
mean(x)
max(x)
min(x)
str5
paste(str5, collapse=",") # 쉼표를 구분자로 str5의 단어들 하나로 합치기
paste(str5,collapse=" ")
x_mean <- mean(x)
x_mean
str5_paste <- paste(str5,collapse=" ")
str5_paste


# ggplot2 패키지 설치
install.packages("ggplot2",dependencies=TRUE)

# ggplot2 패키지 로드
library(ggplot2)

plot(1:10)

# dplyr 패키지 로딩
library(dplyr)

# 여러 문자로 구성된 변수 생성
x <- c("a", "a", "b", "c")
x

# 빈도 막대 그래프 출력
qplot(x)

# data에 mpg, x축에 hwy 변수 지정해 그래프 생성
qplot(data=mpg, x=hwy)

# 파라미터 수정
# x축 cty
qplot(data=mpg, x = cty)

# x축 drv, y축 hwy
qplot(data=mpg, x=drv, y=hwy)

# x축 drv, y축 hwy, 선 그래프 형태
qplot(data=mpg, x=drv, y=hwy, geom = "line")

# x축 drv, y축 hwy, 상자 그림 형태
qplot(data=mpg, x=drv, y=hwy, geom = "boxplot")

# x축 drv, y축 hwy, 상자 그림 형태, drv별 색 표현
qplot(data=mpg, x=drv, y=hwy, geom = "boxplot", colour = drv)

# qplot 함수 메뉴얼 출력
# 함수가 들어있는 패키지를 로드한 상태에서만 메뉴얼 출력코드 실행함
?qplot


# 혼자서 해보기
score <- c(80,60,70,50,90)
score
mean(score)
mean <- mean(score)
mean
