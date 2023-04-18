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

class1 <- exam %>% filter(class==1)
class2 <- exam %>% filter(class==2)

mean