
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

country_list <- readLines('countrynames')

require(rCharts)
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Source comparison: PWT vs WDI"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
      
    sidebarPanel(
      selectInput("selected_country",
                  "Choose country: ",
                  choices = country_list,
                  selected = "China"),
      htmlOutput("legend") 
    ),

    # Show a plot of the generated distribution
    mainPanel(
        h3("Per capita GDP"),
        h5("PWT (2005 PPP-adj $), WDI (2011 PPP-adj $)"),
      showOutput("yp", "morris"),
      tags$style("#yp{width:500px;height:250px}"),
      h3("Household consumption"),
      h5("Share of GDP (%)"),
      showOutput("cy", "morris"),
      tags$style("#cy{width:500px;height:250px}")
      
    )
  )
  
))
