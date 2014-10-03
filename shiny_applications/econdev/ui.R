## ui.R

require(shiny)
countrynames <- readLines('countrynames')
chosen_vars <- read.csv('chosen_variables.csv', sep = ',', stringsAsFactors = F)
v_choices <- split(paste('value.', chosen_vars$Code,sep = ''), list(chosen_vars$Name))

shinyUI(pageWithSidebar(
  headerPanel(img(src = "http://demandinstitute.org/sites/default/files/demand_institute_logo.png"),
              windowTitle = "The Demand Institute"),
  
  sidebarPanel(
    selectInput(inputId = "selected_countries",
                label = h4("Begin entering countries..."),
                choices = countrynames,
                selected = c('China', 
                             'Korea, Republic Of',
                             'Hong Kong',
                             'Singapore',
                             'India',
                             'United States'),
                multiple = TRUE),
    selectInput(inputId = 'x_var',
                label = 'X-axis: ',
                choices = v_choices,
#                 choices = list('Per capita GDP (2005 USD)' = 'value.NY.GDP.PCAP.KD', 
#                             'Per capita GDP (Index: 2010 = 100)' = 'idx.NY.GDP.PCAP.KD'),
                selected = 'GDP per capita (constant 2005 US$)'),
    selectInput(inputId = 'y_var',
                label = 'Y-axis: ',
                choices = v_choices,
#                 choices = list('Consumption as a share of GDP (%)' = 'value.NE.CON.PETC.ZS', 
#                                'Consumption as a share of GDP (Index: 2010 = 100)' = 'idx.NE.CON.PETC.ZS',
#                                'Exports of goods and services (%)' = 'value.NE.EXP.GNFS.ZS',
#                                'Exports of goods and services (Index: 2010 = 100)' = 'idx.NE.EXP.GNFS.ZS'),
                
                selected = 'Household final consumption expenditure, etc. (% of GDP)'),
    radioButtons(inputId = "transform_x",
                 label = h4("Transform X axis?"),
                 choices = list("None (level)" = 1,
                                "Logarithmic" = 2),
                 selected = 1),
    radioButtons(inputId = "transform_y",
                 label = h4("Transform Y axis?"),
                 choices = list("None (level)" = 1,
                                "Logarithmic" = 2),
                 selected = 1),
    radioButtons(inputId = "path",
                 label = h4("Plot path?"),
                 choices = list("No" = 1,
                                "Yes" = 2),
                 selected = 1),
    radioButtons(inputId = "years",
                 label = h4("Show years?"),
                 choices = list("No" = 1,
                                "Yes" = 2),
                 selected = 1),
    sliderInput(inputId = "point_size",
                label = h4("Size of points"),
                min = 1,
                max = 10,
                value = 2)
                 ),
  mainPanel(
    h3("Consumption & income (1960-2013)"),
    plotOutput("myChart"),
    h5("Source: World Development Indicators (2013)")
  )))
