##https://www.quandl.com/data/USMISERY-United-States-Misery-Index/usage/quickstart/r

#####Olivia's work#######
library("dplyr")
library("httr")
library("jsonlite")
source("APIKeys.R")
library(Quandl)
library(maps)
library(ggplot2)

map.US <- map_data('state')
map.US <- select(map.US, 1:5)

mort <- read.csv("data/mort.csv", stringsAsFactors = FALSE)
mort <- filter(mort, !grepl("Alaska", Location))
mort[ , 4:ncol(mort)] <- mort[ , 4:ncol(mort)] / 1000

mort.simple <- select(mort, Location, FIPS, Category, Mortality.Rate..2010.)
mort.state <- filter(mort.simple, !grepl(',', Location))
mort.state <- filter(mort.state, Location != 'United States')
mort.Alabama <- filter(mort.state, Location == "Alabama")

binge.drinking <- read.csv("data/binge_drinking.csv", stringsAsFactors = FALSE)
binge.drinking <- filter(binge.drinking, state != "Alaska")
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

binge.drinking.com <- mutate(binge.drinking.both.avg, mean.male = binge.drinking.male.avg[ ,3], mean.female = binge.drinking.female.avg[ ,3])

bing.drinking.com.state <- filter(binge.drinking.com, state == location)

