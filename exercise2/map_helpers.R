library(leaflet)
library(tidyverse)
library(leaflet.extras)
library(dplyr)
library(deldir)
library(sp)
library(zoo)


# pollution levels
# reference https://www.airqualitynow.eu/download/CITEAIR-Comparing_Urban_Air_Quality_across_Borders.pdf


renderMap <- function(data, pickedStations, pollutant){
    # we are going to want to use this:
    # https://rud.is/b/2015/07/26/making-staticinteractive-voronoi-map-layers-in-ggplotleaflet/
  stationsInfo <- stationsGeoData()
  pickedStations=as.integer(pickedStations)
  print(data)
  df <- aggregate(data[,"pollution"], list(data$station_id), mean, na.rm=TRUE)
  # print(df)
  colnames(df)=c("station_id", "mean")
  
  labels <- factor(c(1,2,3,4,5), ordered = TRUE)
  
  
  df = df %>%
    mutate(subInd = cut(mean, breaks = pollutionLevels[,pollutant], labels = labels))
  
  
  stationsInfo<-merge(stationsInfo, df, by.x="id", by.y="station_id")
  
  print(stationsInfo)
  
  vor_pts <- SpatialPointsDataFrame(cbind(stationsInfo$lon,
                                          stationsInfo$lat),
                                    stationsInfo, match.ID=TRUE)
  print(vor_pts)
  picked_pts <- stationsInfo[which(stationsInfo$id %in% pickedStations), c("name","lon", "lat")]
  vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)
  
  
  vor_df <- fortify(vor)
  colors <- c("LimeGreen",
              "GreenYellow",
              "Yellow",
              "Orange",
              "Red")
  pal <- colorBin(colors, domain = vor$mean, bins = pollutionLevels[,pollutant])
  
  leaflet(data=picked_pts, width=900, height=650) %>%
    # base map
    addTiles() %>%  # Add default OpenStreetMap map tiles%>%
    addMarkers(~lon, ~lat) %>%

    # voronoi (click) layer
    addPolygons(data=vor,
                fillColor = ~pal(mean),
                weight = 2,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.5
               )
  
}

SPointsDF_to_voronoi_SPolysDF <- function(sp) {
  
  # tile.list extracts the polygon data from the deldir computation
  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))
  
  lapply(1:(length(vor_desc)), function(i) {
    
    # tile.list gets us the points for the polygons but we
    # still have to close them, hence the need for the rbind
    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
    tmp <- rbind(tmp, tmp[1,])
    
    # now we can make the Polygon(s)
    Polygons(list(Polygon(tmp)), ID=i)
    
  }) -> vor_polygons
  
  # hopefully the caller passed in good metadata!
  sp_dat <- sp@data
  
  # this way the IDs _should_ match up w/the data & voronoi polys
  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons),
                                  'polygons'),
                             slot, 'ID')
  
  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
                           data=sp_dat)
  
}



  
  