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
############################################################
############################################################
############################################################
############################################################


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
############################################################
############################################################
############################################################
############################################################


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
############################################################
############################################################
############################################################
############################################################


#4. Across the United States, how have emissions from 
#coal combustion-related sources changed from 1999-2008?
library(plyr)
library(ggplot2)
library(sqldf)
library(psych)
#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# spent alot of time figuring how to identify coal combusting related
# data.  This includes reviewing the data and the code book at
# http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf
# after alot of mucking around with the above, I think EI Sector is the way to go...
sqldf("select distinct EI_Sector from SCC where EI_Sector like ('%coal%')")
# below are some of the queries I used with describe (psych library) and sqldf
# just because I'm familiar with sql (but hitting sqlite can take a while)
#describe(SCC)
#table(SCC$EI.Sector)
#table(SCC$SCC.Level.One)
#table(SCC$SCC.Level.Two)
#table(SCC$SCC.Level.Three)
#table(SCC$SCC.Level.Four)
##### HAVE TO LOAD THE sqldf and psych libraries.
##### sqldf turns the . in the columns names to underscores before sending it to sqlite
#sqldf("select distinct SCC_Level_One from SCC where SCC_Level_One like ('%coal%')")
#sqldf("select distinct SCC_Level_Two from SCC where SCC_Level_Two like ('%coal%')")
#sqldf("select distinct SCC_Level_Three from SCC where SCC_Level_Three like ('%coal%')")
#sqldf("select distinct SCC_Level_Four from SCC where SCC_Level_Four like ('%coal%')")
#sqldf("select distinct Short_Name from SCC where Short_Name like ('%coal%')")

#sqldf("select distinct EI_Sector from SCC where EI_Sector like ('%coal%')") gives 
#the following 3 values
#      Fuel Comb - Electric Generation - Coal
# Fuel Comb - Industrial Boilers, ICEs - Coal
#       Fuel Comb - Comm/Institutional - Coal

#get the codes
coalscc <- subset(SCC, EI.Sector %in% c("Fuel Comb - Electric Generation - Coal",
                                                   "Fuel Comb - Industrial Boilers, ICEs - Coal",
                                                   "Fuel Comb - Comm/Institutional - Coal"))
#get only the data related to the coal codes
dcoal <- subset(NEI, SCC %in% coalscc$SCC)

#roll it up by year
dcoalemi = aggregate(Emissions ~ year, data=dcoal, sum)

#plot
png(filename="plot4.png", height=480, width=480, units="px")
barplot(dcoalemi$Emissions, 
        main=expression("Total PM2.5 Emissions from Coal Combustion Related Sources"),
        xlab="Year", 
        ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)")
)
axis(1, at=c(1:4), labels=c("1999", "2002", "2005", "2008"))
dev.off()

# answer: they've decreased overtime.  big decrease from 2005 to 2008
############################################################
############################################################
############################################################
############################################################


#5.How have emissions from motor vehicle sources 
#changed from 1999-2008 in Baltimore City?
library(plyr)
library(ggplot2)
library(sqldf)
library(psych)
#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#explored different ways to identify 'motor vehicles' sources
#x<-sqldf("select distinct EI_Sector from SCC where EI_Sector like ('%vehicle%')")
#x
#y<-sqldf("select distinct EI_Sector from SCC where Data_Category like ('%Onroad%')")
#y
#z<-sqldf("select distinct Data_Category from SCC where Data_Category like ('%Onroad%')")
#z
#Data.Category of 'Onroad' includes aircraft and marine vessels
#I could just select EI.Sector with vehicle in their name
#but I think Onroad is vehicles that are motorized so I'll stick with that
#select onroad vehicles in baltimore with data.category of Onroad

#get the codes for onroad data category
onroadscc <- subset(SCC, Data.Category=='Onroad')
#get only the data related to the onroad codes in baltimore
dbaltmv <- subset(NEI, NEI$fips == "24510" & NEI$SCC %in% onroadscc$SCC)
#aggregate by year
dbaltmvemi = aggregate(Emissions ~ year, data=dbaltmv, sum)

#plot
png(filename="plot5.png", height=480, width=480, units="px")
barplot(dbaltmvemi$Emissions, 
        main=expression("Total PM2.5 Emissions from Baltimore Motor Vehicles"),
        xlab="Year", 
        ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)")
)
axis(1, at=c(1:4), labels=c("1999", "2002", "2005", "2008"))
dev.off()

# answer: they decreased from over 300 tons to about 100 tons
############################################################
############################################################
############################################################
############################################################

#6. Compare emissions from motor vehicle sources in Baltimore 
#City with emissions from motor vehicle sources in 
#Los Angeles County, California (fips == "06037"). Which 
#city has seen greater changes over time in motor vehicle 
#emissions?
library(plyr)
library(ggplot2)
library(sqldf)
library(psych)
#set the working directory.  
#This is also where I downloaded and uncompressed the files:
#https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
setwd("c:/_coursera")  # use / instead of \ in windows 

#read the RDS files. See source link above.  take a minute or so to load
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#explored different ways to identify 'motor vehicles' sources
#x<-sqldf("select distinct EI_Sector from SCC where EI_Sector like ('%vehicle%')")
#x
#y<-sqldf("select distinct EI_Sector from SCC where Data_Category like ('%Onroad%')")
#y
#z<-sqldf("select distinct Data_Category from SCC where Data_Category like ('%Onroad%')")
#z
#Data.Category of 'Onroad' includes aircraft and marine vessels
#I could just select EI.Sector with vehicle in their name
#but I think Onroad is vehicles that are motorized so I'll stick with that
#select onroad vehicles in baltimore with data.category of Onroad

#get the codes for onroad data category
onroadscc <- subset(SCC, Data.Category=='Onroad')
#get only the data related to the onroad codes in baltimore
dmv <- subset(NEI, (NEI$fips == "24510"|NEI$fips=="06037") & NEI$SCC %in% onroadscc$SCC)
#aggregate by year
dmvemi = aggregate(Emissions ~ year + fips, data=dmv, sum)

#plot
png("plot6.png")
qplot(year, Emissions, data=dmvemi, color=fips, geom="line") +
        ggtitle(expression("Motor Vehicle Emissions:Baltimore City (24510) vs LA County (06037)")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

#answer:LA County (fips 06037) increased while Baltimore decreased