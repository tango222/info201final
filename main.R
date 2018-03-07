##https://www.quandl.com/data/USMISERY-United-States-Misery-Index/usage/quickstart/r

##https://www.quandl.com/data/ZILLOW-Zillow-Real-Estate-Research


#####Olivia's work#######
library("dplyr")
library("httr")
library("jsonlite")
source("APIKeys.R")
library(Quandl)

mort <- read.csv("data/mort.csv")

mort.simple <- select(mort, Location, FIPS, Category, Mortality.Rate..2010.)
mort.state <- filter(mort.simple, !grepl(',', Location))
mort.state <- filter(mort.state, Location != 'United States')
mort.Alabama <- filter(mort.state, Location == "Alabama")

binge.drinking <- read.csv("data/binge_drinking.csv")
binge.drinking.simple <- select(binge.drinking, state, location, 15:29) 

neededColumns <- grepl('both_sexes', colnames(binge.drinking.simple))
neededColumns[1:2] <- TRUE
important <- select(binge.drinking.simple, which(neededColumns))
binge.drinking.both.avg <- mutate(important, mean.both = rowMeans(important[ ,3:7]))
binge.drinking.both.avg <- select(binge.drinking.both.avg, 1, 2, 8)

neededColumns <- grepl('male', colnames(binge.drinking.simple))
neededColumns[1:2] <- TRUE
important <- select(binge.drinking.simple, which(neededColumns))
neededColumns <- !grepl('female', colnames(important))
neededColumns[1:2] <- TRUE
important <- select(important, which(neededColumns))
binge.drinking.male.avg <- mutate(important, mean.male = rowMeans(important[ ,3:7]))
binge.drinking.male.avg <- select(binge.drinking.male.avg, 1, 2, 8)

neededColumns <- grepl('female', colnames(binge.drinking.simple))
neededColumns[1:2] <- TRUE
important <- select(binge.drinking.simple, which(neededColumns))
binge.drinking.female.avg <- mutate(important, mean.female = rowMeans(important[ ,3:7]))
binge.drinking.female.avg <- select(binge.drinking.female.avg, 1, 2, 8)

binge.drinking.com <- mutate(binge.drinking.both.avg, mean.male = binge.drinking.male.avg[ ,3])
binge.drinking.com <- mutate(binge.drinking.com, mean.female = binge.drinking.female.avg[ ,3])
