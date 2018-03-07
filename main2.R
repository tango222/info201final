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

result2 <- Quandl(paste0("ZILLOW/CO",codes[9],"_PRRAH"))
name <- filter(binge.WA, code == codes[9])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[10],"_PRRAH"))
# name <- filter(binge.WA, code == codes[10])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[11],"_PRRAH"))
name <- filter(binge.WA, code == codes[11])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[12],"_PRRAH"))
# name <- filter(binge.WA, code == codes[12])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[13],"_PRRAH"))
name <- filter(binge.WA, code == codes[13])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[14],"_PRRAH"))
name <- filter(binge.WA, code == codes[14])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[15],"_PRRAH"))
name <- filter(binge.WA, code == codes[15])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[16],"_PRRAH"))
name <- filter(binge.WA, code == codes[16])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[17],"_PRRAH"))
name <- filter(binge.WA, code == codes[17])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[18],"_PRRAH"))
name <- filter(binge.WA, code == codes[18])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[19],"_PRRAH"))
name <- filter(binge.WA, code == codes[19])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[20],"_PRRAH"))
# name <- filter(binge.WA, code == codes[20])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[21],"_PRRAH"))
name <- filter(binge.WA, code == codes[21])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[22],"_PRRAH"))
# name <- filter(binge.WA, code == codes[22])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[23],"_PRRAH"))
name <- filter(binge.WA, code == codes[23])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[24],"_PRRAH"))
name <- filter(binge.WA, code == codes[24])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[25],"_PRRAH"))
# name <- filter(binge.WA, code == codes[25])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")
# 
# result2 <- Quandl(paste0("ZILLOW/CO",codes[26],"_PRRAH"))
# name <- filter(binge.WA, code == codes[26])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[27],"_PRRAH"))
name <- filter(binge.WA, code == codes[27])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[28],"_PRRAH"))
name <- filter(binge.WA, code == codes[28])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[29],"_PRRAH"))
name <- filter(binge.WA, code == codes[29])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[30],"_PRRAH"))
name <- filter(binge.WA, code == codes[30])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[31],"_PRRAH"))
name <- filter(binge.WA, code == codes[31])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[32],"_PRRAH"))
name <- filter(binge.WA, code == codes[32])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[33],"_PRRAH"))
name <- filter(binge.WA, code == codes[33])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[34],"_PRRAH"))
name <- filter(binge.WA, code == codes[34])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[35],"_PRRAH"))
# name <- filter(binge.WA, code == codes[35])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[36],"_PRRAH"))
name <- filter(binge.WA, code == codes[36])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[37],"_PRRAH"))
name <- filter(binge.WA, code == codes[37])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")

# result2 <- Quandl(paste0("ZILLOW/CO",codes[38],"_PRRAH"))
# name <- filter(binge.WA, code == codes[38])[1,2]
# name <- as.character(droplevels(name))
# colnames(result2)[2] <- name
# result <- left_join(result, result2, by = "Date")

result2 <- Quandl(paste0("ZILLOW/CO",codes[39],"_PRRAH"))
name <- filter(binge.WA, code == codes[39])[1,2]
name <- as.character(droplevels(name))
colnames(result2)[2] <- name
result <- left_join(result, result2, by = "Date")
