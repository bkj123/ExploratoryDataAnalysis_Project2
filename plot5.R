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