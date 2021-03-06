library("dplyr")

# Data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
dataZip <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataDir <- "./data"
dataFile <- "./data/household_power_consumption.txt"

# Prep and extract data
if (!file.exists(dataDir)) {
  dir.create(dataDir)
}

unzip(dataZip, exdir = dataDir)

# Load full data
fullData <- read.table(dataFile, stringsAsFactors=FALSE, sep = ";", header=TRUE)
names(fullData) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# Filter down to desired dates
fullData$Date <- as.Date(x = as.character(fullData$Date), format = "%d/%m/%Y")

beginDate <- as.Date("2007-02-01")
endDate <- as.Date("2007-02-02")

limitedData <- filter(fullData, Date >= beginDate & Date <= endDate)

rm(fullData)

# Get data
subMet1 <- as.numeric(limitedData$Sub_metering_1)
subMet2 <- as.numeric(limitedData$Sub_metering_2)
subMet3 <- as.numeric(limitedData$Sub_metering_3)
dateTime <- strptime(paste(limitedData$Date, limitedData$Time), "%Y-%m-%d %H:%M:%S")

# Plot graph
png("plot3.png",width=480, height = 480)
plot(dateTime, subMet1, type="l", xlab = "", ylab="Energy sub metering")
lines(dateTime, subMet2, type="l", col="red")
lines(dateTime, subMet3, type="l", col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=(c("black","red","blue")),lty=1)
dev.off()
