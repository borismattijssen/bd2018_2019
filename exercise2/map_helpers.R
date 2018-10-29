library(leaflet)
library(tidyverse)
library(leaflet.extras)

renderMap <- function(data){
    # we are going to want to use this:
    # https://rud.is/b/2015/07/26/making-staticinteractive-voronoi-map-layers-in-ggplotleaflet/
    leaflet()  %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lat=40.413684, lng=-3.7043527, popup="Madrid")
}