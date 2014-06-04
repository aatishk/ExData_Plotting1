# Set the working directory (user dependent)
setwd("~/Google Drive/Coursera/Data Science/4 Exploratory Data Analysis/Assignment 1")

# Read the data for February 1-2, 2007 using sql query
library(sqldf)
day12 <- read.csv.sql("household_power_consumption.txt", header = TRUE, sep=";", 
                      sql='select * from file where Date = "1/2/2007" or Date = "2/2/2007"')

# Convert the date from character to date class
day12 <- within( day12, Date2 <- as.Date(Date, "%d/%m/%Y") )

# Create time-stamp by combining Date and Time variables
day12 <- within(day12, DateTime <- strptime(paste(Date2, Time), format="%Y-%m-%d %H:%M:%S"))

# Indicate the missing data labels (?, NA or empty)
day12 = data.frame(day12, na.strings=c("?","NA",""))

#Figure 4
png(file="plot4.png")

# make a 2x2 plot
par(mfrow=c(2,2))

plot(day12$DateTime, day12$Global_active_power, type='l', col=1, main="", xlab="", ylab="Global Active Power")

plot(day12$DateTime, day12$Voltage, type='l', col=1, main="", xlab="datetime", ylab="Voltage")

plot(day12$DateTime, day12$Sub_metering_1, type="l", col=1, main="", xlab="", ylab="Energy sub metering")
lines(day12$DateTime, day12$Sub_metering_2, type="l", col=2)
lines(day12$DateTime, day12$Sub_metering_3, type="l", col=4)
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c(1,2,4), bty="n")

plot(day12$DateTime, day12$Global_reactive_power, type='l', col=1, main="", xlab="datetime", ylab="Global_reactive_power")

dev.off()

