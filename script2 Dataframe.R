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
