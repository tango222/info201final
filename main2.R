library("dplyr")
library("httr")
library("jsonlite")
source("APIKeys.R")
library(Quandl)

codes <- c("2254","1842", "235", "466", "1434", "113", "2556","362","706", "2414", "441","1152",
           "406","465","437", "793","11","176","687","1862", "453","2533","523","685","908"
           ,"1033","52","984","331","1056","62", "100", "654", "175", "1143", "537", "209", "1571", "179")

binge.drinking <- read.csv("data/binge_drinking.csv")
binge.WA <- filter(binge.drinking, state == "Washington")
binge.WA <- filter(binge.WA, location != "Washington")

binge.WA$code <- codes
##indicator code : Price to Rent Ratio (PRRAH)


##retrieves data for the first area code and puts into result
Quandl.api_key(quandl.key)
x <- Quandl("ZILLOW/CO100_PRRAH")
result <- Quandl("ZILLOW/CO2254_PRRAH")
name <- filter(binge.WA, code == "2254")[1,2]
name <- droplevels(name)
name <- as.character(name)
print(name)
colnames(result)[which(names(result) == "Value")] <- name

##attempt to loop through codes vector and left_join each result2 to result
for(i in 2:6)
{
  result2 <- Quandl(paste0("ZILLOW/CO",codes[i],"_PRRAH"))
  name <- filter(binge.WA, code == codes[i])[1,2]
  name <- as.character(droplevels(name))
  colnames(result2)[2] <- name
  result <- left_join(result, result2, by = "Date")
  Sys.sleep(0.05)
}

result2 <- Quandl(paste0("ZILLOW/CO",codes[8],"_PRRAH"))
name <- filter(binge.WA, code == codes[8])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

