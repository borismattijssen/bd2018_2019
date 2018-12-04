# Shiny Madrid

Shiny Madrid is an application that provides visual insights in the airpollution of Madrid. Hopefully, this will help legislators to make Madrid shiny again. An online version of the application can be found [here](https://madrid-pollution.shinyapps.io/shiny-madrid/).

## How to use Shiny Madrid?

![Shiny App](https://github.com/borismattijssen/bd2018_2019/raw/master/exercise2/img/app.png)

1. This panel is used to set filters for the application.
2. This map shows the Air Quality Subindex for the selected chemical, averaged over the given time range.
3. This plot shows the magnitude of the selected chemical for the selected stations. Additionally, rainfall and wind data can be selected and plotted. Selections can be made in the plot to zoom in to more detailed parts of the plot. Double-click to zoom out again. Select the 'Show trend line' option in Part 1 to include a trend line. Values in the plot are daily average values.
4. This plot shows the hourly values of a specific day. It can be activated by clicking on the plot from Part 3.

## How to run Shiny Madrid locally?

1. Clone this repository: `git clone https://github.com/borismattijssen/bd2018_2019.git`.
2. Install the following dependencies: `install.packages("DBI", "DBI", "leaflet", "tidyverse", "leaflet.extras", "dplyr", "deldir", "sp", "zoo", "reshape2", "scales")`.
3. Install the `weatherData` package through `devtools`.
   ```
   install.packages("devtools")
   library("devtools")
   install_github("Ram-N/weatherData")
   ```
4. Run the application: `runApp('exercise2')`.
