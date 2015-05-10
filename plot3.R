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

#plot 3: energy sub-metering
png(file="plot3.png",width=480,height=480)

data$Sub_metering_1<-as.numeric(data$Sub_metering_1)
data$Sub_metering_2<-as.numeric(data$Sub_metering_2)
data$Sub_metering_3<-as.numeric(data$Sub_metering_3)

x<-data$DateTime
y1<-data$Sub_metering_1
y2<-data$Sub_metering_2
y3<-data$Sub_metering_3

plot(x,y1,type='l',xlab="",ylab="Energy sub metering")
lines(x,y2,col ="red")
lines(x,y3,col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1), lwd=c(2.5,2.5),col=c("black","red","blue"))

dev.off()
