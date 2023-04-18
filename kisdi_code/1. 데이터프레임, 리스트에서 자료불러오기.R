# 기존에 했던 작업은 다 지우라는 명령어
rm(list=ls())

# 아래는 해당패키지가 설치되어 있으면 설치하라는 뜻임 (만약 설치되어 있으면 설치안해도 된다는 의미이기도 함)
if(!require(AER)) install.packages("AER")
if(!require(tidyverse)) install.packages("tidyverse")

# 아래는 패키지를 설치했으면 라이브러리로 탑재하라는 뜻임
library(AER); library(tidyverse)

# 아래는 AER 패키지에 무슨 데이터가 있는지를 보여달라는 의미임
data(package = "AER")
# AER 패키지에 있는 자료 불러오기
data(CPS1988)
a <- CPS1988
#자료의 형태 파악하기
str(a)

# a는 데이터프레임의 형태로 되어 있어서, a내의 자료를 부르기 위해서는 $표시를 하거나, a[,2]형태로 부를 수 있음
# 첫번째의 경우는 데이터프레임내 변수명만 알면되는데, 두번째의 경우는 해당변수가 몇번째 열에 해당되는지를 알아야 함
# head는 변수의 첫번째 몇개 숫자만을 return하도록 함
head(a$wage)
head(a[,1])

# first, last는 첫번째값과 마지막 값을 return: tidyverse내 dplyr 패키지를 이용할 경우 사용가능
first(a$wage)
last(a$wage)

b <- lm(wage~education+experience+ethnicity, data=a)

# b에 저장된 결과는 List의 형태를 보이고 있음
str(b)

# b에 저장된 첫번째 리스트는 coefficient로 4개의 값이 들어가 있음 (이름과 값)
# 이중에서 intercept(절편값)을 불러 오기 위해서는 다음과 같이 하면 됨
b[[1]][1]
b[["coefficients"]][1]
#(Intercept) 
#-362.2411 

#위와 같이 하면 이름과 값이 같이 나오는데, 값만 뽑으려면 [[]]를 사용하면 됨.
b[["coefficients"]][[1]]
b[["coefficients"]][["(Intercept)"]]

# 즉, lists내 하위는 [[]]로 불러들이고, 그 이후에 불러들이는 방법은 행렬, 데이터프레임처럼 취급하면 됨.