
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(rCharts)
library(shiny)
require(RColorBrewer)

data <- read.csv('data.csv', sep = ',', stringsAsFactors = F)
sources <- c('PWT', 'WDI')
colors <- brewer.pal(max(3,length(sources)), "Set1")
shinyServer(function(input, output) {
    observe({
        output$yp <- renderChart({        
            yr_yp <- mPlot(x = "year",
                           y = c("y_p_PWT", "y_p_WDI"),
                           type = "Line",
                           data = subset(data, country_PWT == input$selected_country))
            yr_yp$set(dom = "yp")
            yr_yp$set(pointSize = 3, lineWidth = 1)
            yr_yp$set(parseTime = F)
            yr_yp$set(lineColors = colors)
            yr_yp$set(hoverCallback = "#! function(index, options, content){ var row = options.data[index] 
               return '<b>' + row.year + '</b>' + '<br/>' + 'PWT: ' + Math.round(row.y_p_PWT) + '<br/>' + 'WDI: ' + Math.round(row.y_p_WDI)} !#")
            
            return(yr_yp)
        })
        output$cy <- renderChart({        
            yr_cy <- mPlot(x = "year",
                           y = c("c_y_PWT", "c_y_WDI"),
                           type = "Line",
                           data = subset(data, country_PWT == input$selected_country))
            yr_cy$set(dom = "cy")
            yr_cy$set(pointSize = 3, lineWidth = 1)
            yr_cy$set(parseTime = F)
            yr_cy$set(lineColors = colors)
            yr_cy$set(hoverCallback = "#! function(index, options, content){ var row = options.data[index] 
               return '<b>' + row.year + '</b>' +  '<br/>' + 'PWT: ' + Math.round(row.c_y_PWT) + '<br/>' + 'WDI: ' + Math.round(row.c_y_WDI)} !#")
            return(yr_cy)
            
        })
        
        
        legends <- '<br/>' 

        for (i in 1:length(sources)){
            legends <- paste(legends, div(sources[i], style = paste('', "color:", colors[i], '', sep = '')),sep = '')
        }
        
        output$legend <- renderText({legends})
    })
})
