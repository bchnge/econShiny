# setwd('~/Projects/econdev/')

# Read master data
df <- read.csv('data.csv', sep = ',', stringsAsFactors = F)

variable_table <- with(df, list(unique(Indicator.Name), unique(Indicator.Code)))
names(variable_table) <- c("Name", "Code")
getCode <- function(var_name){
    index_val <- match(var_name, variable_table$Name)
    variable_table$Code[index_val]
}

vars <- c('Household final consumption expenditure, etc. (% of GDP)', 
          'GDP per capita (constant 2005 US$)',
          'Exports of goods and services (% of GDP)',
          'GINI index',
          "Employment to population ratio, 15+, total (%) (modeled ILO estimate)",
          "Health expenditure, public (% of total health expenditure)",
          "Public spending on education, total (% of GDP)"           
          )

# Obtain country names
require(countrycode)
df$CountryName <- countrycode(df$Country.Code, "iso3c", "country.name")
df <- df[!is.na(df$CountryName) & !is.na(df$X2010),]

df <- subset(df, Indicator.Name %in% vars)
Filter(function(x) x %in% vars, variable_table$Name)
require(plyr)
require(reshape2)

data <- melt(df)
data <- data[, c('CountryName', 'Indicator.Code', 'variable', 'value')]
data <- reshape(data,
                timevar = 'Indicator.Code',
                idvar = c('CountryName', 'variable'),
                direction = 'wide')
data$yr <- with(data, substr(x = variable, 4,5))
data$variable <- with(data, as.integer(substr(x=variable,2,5)))
names(data)[1:2] <- c('Country', 'Year')

# Create index versions

for (v in vars) {
    vname <- paste('data$idx.', getCode(v), sep = '')
    cmd <- paste("<- with(data, value.", getCode(v), "/ value.", getCode(v), "[data$yr == '10'] * 100)", sep = '')
    cmd <- paste(vname,cmd,sep = '')
    eval(parse(text = cmd))
}

data <- data[with(data, order(Country,Year)),]
#data <- na.exclude(data)
countries <- unique(data$Country)


write(countries, 'countrynames')
write.table(data, 'final_data_2.csv', sep = ',', row.names = F)
write.table(subset(data.frame(variable_table), Name %in% vars), 'chosen_variables.csv', sep = ',', row.names = F)
