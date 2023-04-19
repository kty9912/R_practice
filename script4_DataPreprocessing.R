# dplyr 함수

library(dplyr)

exam <- read.csv("data/csv_exam.csv")
exam

# exam에서 class가 1인 경우만 추출해 출력
exam %>% filter(class == 1)
# 2인 경우
exam %>% filter(class == 2)

exam %>% filter(class != 1)  # 1반이 아닌 경우
exam %>% filter(class != 3)  # 3반이 아닌 경우
# 조건걸기
exam %>% filter(math > 50)  # 수학 점수 50점 초과
exam %>% filter(math < 50)  # 수학 점수 50점 미만
exam %>% filter(english >= 80) # 영어 점수 80점 이상
exam %>% filter(english <= 80) # 영어 점수 80점 이하

# 여러 조건
exam %>% filter(class == 1 & math >= 50) # 1반이면서 수학 50점 이상
exam %>% filter(class == 2 & english >=80) #2반이면서 영어 80점 이상

# 여러 조건 중 하나 이상 충족하는 행 추출
exam %>% filter(math >=90 | english >=90) #수학 점수 90점 이상 or 영어 점수 90점 이상
exam %>% filter(english < 90 | science < 50) #영어점수 90점 미만 or 과학점수 50점 미만인 경우

# 목록에 해당하는 열 추출
exam %>%  filter(class ==1 | class==3 | class==5) # 1,3,5반 


# 매치 연산자 사용 %in%
exam %>% filter(class %in% c(1,3,5)) # 1,3,5반


class1 <- exam %>% filter(class==1) # class가 1인 행 추출, class1에 할당
class2 <- exam %>% filter(class==2) # class가 2인 행 추출, class2에 할당
# 1반 수학 점수 평균
mean(class1$math)
# 2반 수학 점수 평균
mean(class2$math)


# 혼자서 해보기 p.133
mpg <- as.data.frame(ggplot2::mpg) # mpg 데이터 불러오기
mpg_4 <- mpg %>% filter(displ <= 4) # displ(배기량) 4이하 추출
mpg_4
mpg_5 <- mpg %>% filter(displ >= 5) # displ(배기량) 5이상 추출
mpg_5
mean(mpg_5$hwy) # hwy(고속도로 연비)
mean(mpg_4$hwy) # hwy평균

