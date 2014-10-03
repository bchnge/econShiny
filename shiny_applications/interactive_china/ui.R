
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
countrynames <- readLines('countrynames')
chosen_vars <- read.csv('chosen_variables.csv', sep = ',', stringsAsFactors = F)
chosen_vars$Code <- gsub('.','_',chosen_vars$Code, fixed = T)
v_choices <- split(paste('value_', chosen_vars$Code,sep = ''), list(chosen_vars$Name))

library(rCharts)
library(shiny)
shinyUI(fluidPage(

  # Application title
  titlePanel("Time series explorer"),
  
  # Input panels
  sidebarPanel(selectInput(inputId = 'var',
                              label = h5('Choose variable(s): '),
                              choices = v_choices,
                              selected = c('value_NY_GDP_PCAP_KD', 'value_NE_CON_PETC_ZS'),
                              multiple = TRUE),
                  
               selectInput(inputId = "selected_countries",
                              label = h5("Choose country: "),
                              choices = countrynames,
                              selected = 'China'),
               radioButtons(inputId = "radio", 
                               label = h5("Choose variable transformation"),
                               choices = list("Index (select base year)" = 1, 
                                              "Level" = 2,
                                              "Y-O-Y % Change" = 3,
                                              "Logarithmic" = 4),
                               selected = 1),
               sliderInput(inputId = "index_year",
                              label = h5("Choose index base year"),
                              min = 1990,
                              max = 2010,
                              value = 2000,
                              format="###0"),
               sliderInput(inputId = "lag",
                              label = h5("Choose period % change"),
                              min = 1,
                              max = 5,
                              value = 1),
               checkboxInput(inputId = 'show_labels',
                             label = 'Display level information in tooltip',
                             value = TRUE)                 
                  ),
  mainPanel(
      h3(textOutput("title")),      
      h5("Source: World Development Indicators (2013)"),
      showOutput("timeplot", "morris"),
      htmlOutput("legend")            
  )
    
))
  
          