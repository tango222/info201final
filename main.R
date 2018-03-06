##https://www.quandl.com/data/USMISERY-United-States-Misery-Index/usage/quickstart/r

##https://www.quandl.com/data/ZILLOW-Zillow-Real-Estate-Research


#####Olivia's work#######
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
Quandl(paste0("ZILLow/CO"))
x <- Quandl("ZILLOW/CO100_PRRAH")
result <- Quandl("ZILLOW/CO2254_PRRAH")
name <- filter(binge.WA, code == "2254")[1,2]
name <- droplevels(name)
name <- as.character(name)
print(name)
colnames(result)[which(names(result) == "Value")] <- name

i <- 2
while(i < 40){
  result2 <- Quandl(paste0("ZILLOW/CO",codes[i],"_PRRAH"))
  name <- filter(binge.WA, code == codes[i])[1,2]
  name <- as.character(droplevels(name))
  colnames(result2)[2] <- name
  result <- left_join(result, result2, by = "Date")
  Sys.sleep(0.05)
  i <- i+1
}

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

for(i in 10:13)
{
  result2 <- Quandl(paste0("ZILLOW/CO",codes[i],"_PRRAH"))
  name <- filter(binge.WA, code == codes[i])[1,2]
  name <- as.character(droplevels(name))
  colnames(result2)[2] <- name
  result <- left_join(result, result2, by = "Date")
  Sys.sleep(0.05)
}

########################
##misery index section##
########################

misery.data <- Quandl('USMISERY/INDEX', start_date='2002-01-01', end_date='2012-12-31')



Quandl.api_key(quandl.key)

x <- Quandl("ZILLOW/CO100_PRRAH")
result <- Quandl("ZILLOW/CO2254_PRRAH")
name <- filter(binge.WA,code== codes[39])[1,2]
name <- droplevels(name)
name <- as.character(name)
print(name)
colnames(result)[which(names(result) == "Value")] <- name
##here to test for loop
# for(j in 1:10)
# {
#   print(j)
# }

##County Codes
# Adams, WA|2254
# Asotin, WA|1842
# Benton, WA|235
# Chelan, WA|466
# Clallam, WA|1434
# Clark, WA|113
# Columbia, WA|2556
# Cowlitz, WA|362
# Douglas, WA|706
# Ferry, WA|2414
# Franklin, WA|441
# Garfield, WA|1152
# Grant, WA|406
# Grays Harbor, WA|465
# Island, WA|437
# Jefferson, WA|793
# King, WA|11
# Kitsap, WA|176
# Kittitas, WA|687
# Klickitat, WA|1862
# Lewis, WA|453
# Lincoln, WA|2533
# Mason, WA|523
# Okanogan, WA|685
# Pacific, WA|908
# Pend Oreille, WA|1033
# Pierce, WA|52
# San Juan, WA|984
# Skagit, WA|331
# Skamania, WA|1056
# Snohomish, WA|62
# Spokane, WA|100
# Stevens, WA|654
# Thurston, WA|175
# Wahkiakum, WA|1143
# Walla Walla, WA|537
# Whatcom, WA|209
# Whitman, WA|1571
# Yakima, WA|179

########################