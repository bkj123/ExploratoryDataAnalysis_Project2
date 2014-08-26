#2. Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
#system to make a plot answering this question.

#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#grab baltimore data only and then aggregate emissions for all the years
dbalt=subset(NEI, NEI$fips == "24510")
#nrow(NEI)
#nrow(dbalt)
dbaltemi = aggregate(Emissions ~ year, data=dbalt, sum)

# plot
png(filename="plot2.png", height=480, width=480, units="px")
barplot(dbaltemi$Emissions, names = dbaltemi$year,
        xlab='year', ylab='PM2.5 Emissions (tons)',
        main = 'Baltimore PM2.5 Emissions by Year')
dev.off()

# answer: they have decreased from 99 to 08.  Note: 2002 was 
# lower than 2005