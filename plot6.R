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