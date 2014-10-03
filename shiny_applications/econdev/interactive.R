require(shiny)
require(rCharts)
require(stringr)
data <- read.csv('final_data_2.csv')
names(data) <- gsub('.','_',names(data), fixed = T)
countries <- c('United States', 'China')
m1 <- mPlot(x = 'value.NY.GDP.PCAP.KD',
            y = 'value.NE.CON.PETC.ZS',
            group = 'Country',
            type = 'Line',
            data = subset(data, Country %in% countries))
m1$set(pointSize = 0, lineWidth = 1)
m1$set(parseTime = FALSE)


m1

subdata <- subset(data, Country %in% countries, 
                  select = c('Year', 'idx_NY_GDP_PCAP_KD', 'Country'))

subdata <- reshape(subdata, timevar = 'Country', idvar = 'Year', direction = 'wide')
names(subdata) <- gsub('.','X',names(subdata), fixed = T)
names(subdata) <- gsub(' ','_',names(subdata), fixed = T)

m2 <- mPlot(x = 'Year',
            y = c('idx_NY_GDP_PCAP_KDXChina', 'idx_NY_GDP_PCAP_KDXUnited_States'),
            type = 'Line',
            data = subdata)
m2$set(pointSize = 3, lineWidth = 1)
m2$set(parseTime = T)
m2$set(hoverCallback = "#! function(index, options, content){
   var row = options.data[index]
   yr = 'Year: ' + row.Year
   line1 = 'Value: blah'
   return [yr, line1].join('<br/>')
} !#")
m2
