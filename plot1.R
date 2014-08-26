#1. Have total emissions from PM2.5 decreased in the United States 
#from 1999 to 2008? Using the base plotting system, make a plot 
#showing the total PM2.5 emission from all sources for each of 
#the years 1999, 2002, 2005, and 2008.

#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#aggregate emissions for all the years. var names are case sensitive
demi = aggregate(Emissions ~ year, data=NEI, sum)

# plot
png(filename="plot1.png", height=480, width=480, units="px")
barplot(demi$Emissions, names = demi$year,
        xlab='year', ylab='PM2.5 Emissions (tons)',
        main = 'U.S. Total PM2.5 Emissions by Year')
dev.off()

#answer: yes, they have decreased