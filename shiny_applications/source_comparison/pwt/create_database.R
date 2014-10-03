require(foreign)

pwt_df <- read.dta('pwt/pwt80.dta')
pwt_df$y_p <- with(pwt_df, rgdpe / pop)
pwt_df <- subset(pwt_df, select = c('countrycode', 'country', 'year', 'y_p', 'csh_c'))
names(pwt_df) <- c('countrycode', 'country', 'year', 'y_p', 'c_y')

wdi_df <- read.csv('../econdev/data.csv', stringsAsFactors = F)
wdi_df <- subset(wdi_df, Indicator.Name %in% c("GDP per capita, PPP (constant 2011 international $)", "Household final consumption expenditure, etc. (% of GDP)"  ))
# wdi_df <- read.csv('../econdev/data_2.csv', stringsAsFactors = F)
require(reshape2)

wdi <- melt(wdi_df)
wdi <- dcast(data = wdi,Country.Name + Country.Code + variable ~ Indicator.Name + Indicator.Code)
require(stringr)
wdi$variable <- as.integer(str_sub(wdi$variable, 2,5))
names(wdi) <- c('country', 'countrycode', 'year', 'y_p','c_y')

total_df <- merge(pwt_df, wdi, by = c('countrycode', 'year'), all.x = TRUE, all.y = TRUE)
with(subset(total_df, is.na(country.x)), table(country.y))

# total_df <- na.exclude(total_df)
total_df <- subset(total_df, !is.na(country.x))

names(total_df) <- c('countrycode', 'year', 'country_PWT','y_p_PWT', 'c_y_PWT', 'country_WDI', 'y_p_WDI', 'c_y_WDI')
total_df$c_y_PWT <- total_df$c_y_PWT * 100

write.table(total_df,'data.csv', sep = ',', row.names = F)
writeLines(unique(total_df$country_PWT), 'countrynames')
