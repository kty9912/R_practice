df <- read_excel("data/상장기업 관련 자료 조사.xlsm")
df

library(dplyr)
count(df)
df %>%
  group_by(연도) %>%
  tally()

names(df)

library(data.table)
dt <- data.table(df)
dt
str(dt)

df %>%
  filter(연도=2000) %>%
  group_by((소분류)...9) %>%
  summarise(cnt=n())
