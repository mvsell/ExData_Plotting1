# Assignment 1

install.packages("data.table")
library(data.table)
install.packages("lubridate")
library(lubridate)

# Download the file to load
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp<-tempfile()
download.file(fileUrl, destfile = temp, method="curl")


#alternative if only reading certain rows and or cols
consumption <- read.table(unz(temp, "household_power_consumption.txt"), sep=";", colClasses=c("character"), header=TRUE)
unlink(temp)

data<-consumption[66637:69516,] # these rows pertain to the dates in question

which(data=="?")
data[data=="?"] <- "NA"

## read in date/time info in format 'm/d/y h:m:s'
dates <- data$Date
times <- data$Time
x<-paste(dates, times)
tmp<-fast_strptime(x, format="%d/%m/%Y %H:%M:%S")
data$DateTime<-tmp

#plot 1: Global Active power hist
png(file="plot1.png",width=480,height=480)

hist(as.numeric(data$Global_active_power), c="red",xlab="Global Active Power (kilowatts)", main="Global Active Power")

dev.off()