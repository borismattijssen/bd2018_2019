#library('rhdf5')
#new5 <- H5Fopen('data/madrid.h5')
#new5 <- h5read('data/madrid.h5', 'master')
#
##loadhdf5data <- function(h5obj) {
#  h5obj <- new5
#  listing <- names(h5obj)
#  data_nodes <- grep("_values", listing)
#  name_nodes <- grep("_items", listing)
#  
#  columns = list()
#  for (idx in seq(data_nodes)) {
#    data_node = listing[data_nodes[idx]]
#    name_node = listing[name_nodes[idx]]
#    data <- t(h5obj[[data_node]])
#    names <- t(h5obj[[name_node]])
#    entry <- data.frame(data)
#    colnames(entry) <- names
#    columns <- append(columns, entry)
#  }
#  
#  data <- data.frame(columns)
#  
##  return(data)
##}
#
#
#data_column_names <- new5$axis0
#data_matrix <- new5
#
#
#station = "28079001"
#get(station,new5)$block0_items
#
#mad5 <- H5File$new('data/madrid.h5', mode="r+")
#h5attr_names(mad5[['master']])
#list.datasets(mad5)
#list.attributes(mad5[['28079001/block0_values']])
#h5attr(mad5[['28079001']], 'pandas_type')
#
#
#
#
#
#
#
#library('dplyr')
#library('zoo')
#
#madrid = data.frame()
#
#for (file in list.files('data/csvs_per_year')) {
#  d <- read.csv('data/csvs_per_year/madrid_2001.csv')
#  madrid <- rbind(madrid, d)
#}
#
#
#station_28079016 <- madrid[madrid$station == 28079016,]
#station_28079016_clean = station_28079016[,-1]
#station_28079016_clean = station_28079016_clean[1:length(station_28079016_clean)-1]
#m = rollmean(station_28079016_clean, 24)
#
#df = data.frame(m[,'CO'],m[,'NO_2'],m[,'NOx'],m[,'O_3'],m[,'PM10'],m[,'SO_2'])
#names(df) <- c('CO','NO_2','NOx','O_3','PM10','SO_2')
#plot(df)
#