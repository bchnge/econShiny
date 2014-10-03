require(ggplot2)
require(shiny)

chosen_vars <- read.csv('chosen_variables.csv', sep = ',', stringsAsFactors = F)
data <- read.csv('final_data_2.csv')
shinyServer(function(input, output) {
  observe({
  temp_data <- subset(data, Country %in% input$selected_countries)

  x_label <- chosen_vars$Name[match(input$x_var, paste('value.',chosen_vars$Code, sep = ''))]
  y_label <- chosen_vars$Name[match(input$y_var, paste('value.',chosen_vars$Code, sep = ''))]
  
g <- ggplot(temp_data, aes_string(x = input$x_var, y = input$y_var, color = 'Country')) +
      xlab(x_label) + ylab(y_label) +
      geom_point(aes_string(group = 'Country', alpha = 'Year'), size = input$point_size)
  
  if (input$transform_x == 2){
    g <- g + scale_x_log10()}
  
  if (input$transform_y == 2){
    g <- g + scale_y_log10()}

  if (input$path == 2){
    g <- g + geom_path(lineend = "round")
  }
  if (input$years == 2) {
    g <- g + geom_text(aes(label = yr, alpha = Year), size = 3, color = 'black')
  }
  
  output$myChart <- renderPlot({print(g)})
  })
})