#3. Of the four types of sources indicated by the type (point, nonpoint, 
#onroad, nonroad) variable, which of these four sources have seen decreases 
#in emissions from 1999-2008 for Baltimore City? Which have seen increases 
#in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
#answer this question.

library(plyr)
library(ggplot2)

#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#grab baltimore data only and then aggregate emissions by year and type
#orignially used plyr for the second step but found it can be done with
#aggregate usint + sign.  plus, I don't have to rename column3
#plyr way: x <- ddply(dbalt, .(year, type), function(x) sum(x$Emissions))
#colnames(x)[3] <- "emissions"
dbalt=subset(NEI, NEI$fips == "24510")
dbaltemitype = aggregate(Emissions ~ year + type, data=dbalt, sum)

#uncomment the code below to see the chart in rstudio's plot window
#plot3<-qplot(year, Emissions, data=dbaltemitype, color=type, geom="line") +
#        ggtitle(expression("Baltimore City Emissions by Type and Year")) +
#        xlab("Year") +
#        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
#plot3
png("plot3.png")
qplot(year, Emissions, data=dbaltemitype, color=type, geom="line") +
        ggtitle(expression("Baltimore City Emissions by Type and Year")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

#answer:if you compare the first year with the last all decrease except
# 'point' which is slightly higher after it peaked