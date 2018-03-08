# author: Joel Ross

suppressWarnings(library(maps))
suppressWarnings(library(sp))
suppressWarnings(library(maptools))

# This function takes in a longitude and latitude (East by North)
# And returns the name of the country at that point.
# Adapted from https://stackoverflow.com/q/14334970/8716253

GetCountryAtPoint <- function(long, lat) {
  # handle invalid input
  if(!is.numeric(long) | !is.numeric(lat)){
    return(NA)
  }
  
  # prep map and data structures
  world <- map("state", fill = T, plot = F) 
  IDs <- sapply(strsplit(world$names, ":"), function(x) x[1])
  world.sp <- map2SpatialPolygons(world, IDs=IDs, proj4string=CRS("+proj=longlat +datum=WGS84"))
  country.names = sapply(world.sp@polygons, function(x) x@ID)

  # create spatial point from coords
  point.sp = SpatialPoints(data.frame(long, lat), proj4string=CRS("+proj=longlat +datum=WGS84"))

  # look up point in map
  country.index <- over(point.sp, world.sp)

  # get country name
  country.names[country.index]
}