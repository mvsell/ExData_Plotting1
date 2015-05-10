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

#plot 4: energy sub-metering
y<-data$Global_active_power
x<-data$DateTime
data$Sub_metering_1<-as.numeric(data$Sub_metering_1)
data$Sub_metering_2<-as.numeric(data$Sub_metering_2)
data$Sub_metering_3<-as.numeric(data$Sub_metering_3)
y1<-data$Sub_metering_1
y2<-data$Sub_metering_2
y3<-data$Sub_metering_3

png(file="plot4.png",width=480,height=480)

par(mfrow=c(2,2))
plot(x,y,type="l",xlab="", ylab="Global Active Power",cex.axis = 1.0)
plot(data$DateTime, data$Voltage, xlab="datetime",ylab="Voltage", type='l' ,cex.axis = 1.0)
plot(x,y1,type='l',xlab="",ylab="Energy sub metering",cex.axis = 1.0)
lines(x,y2,col ="red")
lines(x,y3,col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1), lwd=c(2.5,2.5),col=c("black","red","blue"), cex=1.0, bty="n", xjust=0.8, yjust=0.8)
plot(data$DateTime,data$Global_reactive_power, type="l",xlab="datetime",ylab="Global_reactive_power",cex.axis = 1.0)

dev.off()

