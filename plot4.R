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