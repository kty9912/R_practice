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

exam %>% filter(math > 50)  # 수학 점수 50점 초과
exam %>% filter(math < 50)  # 수학 점수 50점 미만
exam %>% filter(english >= 80) # 영어 점수 80점 이상
exam %>% filter(english <= 80) # 영어 점수 80점 이하

