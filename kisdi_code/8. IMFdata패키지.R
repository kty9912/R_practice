#reference: https://github.com/mingjerli/IMFData

#devtools::install_github('mingjerli/IMFData')
library(IMFData); library(tidyverse); library(lubridate); library(anytime);library(plm); library(stargazer)


availableDB <- DataflowMethod()

# Get dimension code of IFS dataset
IFS.available.codes <- DataStructureMethod("IFS")

# Available dimension code
names(IFS.available.codes)

# Possible code in the first dimension
IFS_freq <- IFS.available.codes[[1]]

# Possible code in the second dimension
IFS_area <- IFS.available.codes[[2]]

# Possible code in the third dimension
IFS_indicator <- IFS.available.codes[[3]]

# FYI: DOT (Direction of Trade) is also important source for Trade data. Get dimension code of DOT dataset
DOT.available.codes <- DataStructureMethod("DOT")
# Possible code in the third dimension
DOT_indicator <- DOT.available.codes[[3]]


# Search code contains GDP in IFS
GDP_code <- CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "GDP")

# Seasonally-adjusted Real GDP in national currency is shown to be NGDP_R_XDC in IFS

# Search code contains interest rate; First letter should be CAPITAL letter!!
int_code <- CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Interest")

# Financial, Interest Rates, Government Securities, Government Bonds, Short-term, Percent per annum code is "FIGB_S_PA" in IFS

# Search code contains interest rate; First letter should be CAPITAL letter!!
ex_code <- CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Exchange")
# Exchange rate (period average) code is "ENDA_XDC_USD_RATE" in IFS


# Make API call to get data
databaseID <- "IFS"
startdate = "2000-01-01"
enddate = "2020-12-31"
checkquery = FALSE

## All country, 1) Quarterly (Q), Real GDP in National currency, NGDP_R_XDC; and short-term government interest rate FIGB_S_PA; and exchange rate (/USD) 
queryfilter <- list(CL_FREQ = "A", CL_AREA_IFS = "", CL_INDICATOR_IFS = c("NGDP_R_XDC", "FIGB_S_PA", "ENDA_XDC_USD_RATE"))

# Now get the data from IMF using CompactDataMethod
data1 <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery, tidy=TRUE)

data2 <- data1 %>% select(c("@TIME_PERIOD", "@OBS_VALUE", "@REF_AREA", "@INDICATOR"))
names(data2) <- c("date", "value", "area", "indicator")

# Rearrange: date, area, variable, values

data2 <- data2 %>% relocate(area,date, indicator, value) %>%  arrange(area,date)

str(data2)

data2 <- data2 %>% mutate(date=as.integer(date), value=as.numeric(value))

str(data2)

# Now convert into wide form using spread function (or pivot_wider)

data3 <- data2 %>% spread(indicator,value)

names(data3) <- c("iso2c", "date", "exrate", "gdp")
# iso2c is to be consistent with the codes from countrycode

nrow(data3)

# In the IMF code, countries are express in two characters: for example, korea is KR
# We use contrycode to identify full country names together with continents.

if(!require(countrycode)) install.packages("countrycode")
library(countrycode)
data(codelist)
country_set <- codelist
country_set <- country_set %>% 
  select(country.name.en, iso2c, iso3c, imf, continent, region) %>% filter(!is.na(imf) & !is.na(iso2c))
View(country_set)

data4 <- merge(data3,country_set)

# Now, remove data with any missing observations

data4 <- data4[complete.cases(data4),]
data4 <- data4 %>% filter(gdp!=0)

data5 <- pdata.frame(data4, index=c("iso2c","date"))

model1 <- plm(log(gdp)~log(exrate),data5, model="random")

# Let's see how those effects are different for different continents

data5 <- data5 %>% mutate(cont=as.factor(continent))

model2 <- plm(log(gdp)~log(exrate)+I(cont),data5, model="random")
# In the example above, missing dummy (continent) is Africa

stargazer(model1, model2,omit = "cont", type="html", out = "IMF.html")
