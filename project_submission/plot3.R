# set the file url
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# create a temporary directory
td = tempdir()

# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")

# download into the placeholder file (curl method needed for Mac OS X)
download.file(fileurl, tf, method="curl")

# get the name of the first file in the zip archive
fname = unzip(tf, list=TRUE)$Name[1]

# unzip the file to the temporary directory
unzip(tf, files=fname, exdir=td, overwrite=TRUE)

# fpath is the full path to the extracted file
fpath = file.path(td, fname)

# read the data for February 1-2, 2007 using sql query
library(sqldf)
day12 <- read.csv.sql(fpath, header = TRUE, sep=";", 
                      sql='select * from file where Date = "1/2/2007" or Date = "2/2/2007"')

# convert the date from character to date class and store in Date2 variable
day12 <- within( day12, Date2 <- as.Date(Date, "%d/%m/%Y") )

# create time-stamp by combining Date2 and Time variables
day12 <- within( day12, DateTime <- strptime(paste(Date2, Time), format="%Y-%m-%d %H:%M:%S") )

# indicate the missing data labels i.e. ?
day12 = data.frame(day12, na.strings="?")

# generate plot3
png(file="plot3.png")
plot(day12$DateTime, day12$Sub_metering_1, type="l", col=1,  main="", xlab="", ylab="Energy sub metering")
lines(day12$DateTime, day12$Sub_metering_2, type="l", col=2)
lines(day12$DateTime, day12$Sub_metering_3, type="l", col=4)
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c(1,2,4))
dev.off()

