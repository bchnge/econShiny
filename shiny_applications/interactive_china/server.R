
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(rCharts)
require(RColorBrewer)

chosen_vars <- read.csv('chosen_variables.csv', sep = ',', stringsAsFactors = F)
chosen_vars$Code <- gsub('.','_',chosen_vars$Code, fixed = T)
v_choices <- split(chosen_vars$Name, paste('value_', chosen_vars$Code,sep = ''))
data <- read.csv('final_data_2.csv')
names(data) <- gsub('.','_',names(data),fixed = T)


shinyServer(function(input, output) {
    transform_series <- function(series, date, trigger = 1, base_yr, chosen_lag){
        if(trigger == 1){
            # Index 2010
            new_series <- series / series[date == base_yr] * 100
        }
        else if (trigger == 2){
            new_series <- series
        }
        else if (trigger == 3){
            temp <- diff(series, lag = chosen_lag) / series * 100
            temp <- temp[1:(length(temp)-chosen_lag)]
            
            new_series <- append(rep(NA, chosen_lag), temp)
        }
        else if (trigger == 4){
            new_series <- log(series)
        }
        return(new_series)
    }        
    
    
    observe({    
        temp_data <- subset(data, Country == input$selected_countries)
        for (v in input$var){
            temp_data[,paste('NEW_',v,sep = '')] <- transform_series(temp_data[,v], temp_data$Year, input$radio, input$index_year, input$lag)            
        }
        
        colors <- brewer.pal(max(3,length(input$var)), "Set1")
        
        output$timeplot <- renderChart({
            m2 <- mPlot(x = 'Year',
                        y = paste('NEW_',input$var,sep = ''),
                        type = 'Line',
                        data = temp_data)
            m2$set(pointSize = 3, lineWidth = 1)
            m2$set(parseTime = F)
            
            tooltip_stuff <- c()
            
            for (i in input$var){
                tooltip_stuff <- append(tooltip_stuff, paste(v_choices[i],": '", "+ '<b>' + Math.round(row.",i, "*100)/100 + '</b>'", sep = ''))
            }
            
            tooltip_stuff_string <- paste("'", tooltip_stuff, collapse = " + '<br/>' + ")
            tooltip_0 <- "#! function(index, options, content){
var row = options.data[index]
return '<b>' + row.Country + '</b>   ' + row.Year + '<br/>' + "
            
            tooltip_total <- paste(tooltip_0, tooltip_stuff_string, "} !#", sep = '')
            if (input$show_labels == T){
                m2$set(hoverCallback = tooltip_total)
            }
            
            else {
                m2$set(hoverCallback = "#! function(index, options, content){ var row = options.data[index] 
               return row.Year} !#")
            }
            m2$set(dom = 'timeplot')
            m2$set(lineColors = colors)
            return(m2)
        })
        
        output$title <- renderText({input$selected_countries})
        
        legends <- '<br/>'        
        for (i in 1:length(input$var)){
            legends <- paste(legends, div(v_choices[input$var[i]], style = paste('', "color:", colors[i], '', sep = '')),sep = '')
        }
        
        output$legend <- renderText({legends})
    })
})
