# load the data
library(chron)
library(ggplot2)
file1<-read.csv(file = "E:\\johns hopkins\\Exploring Data GitHub\\household_power_consumption.txt",
                sep = ";",stringsAsFactors = FALSE)

file1$Date<- as.Date(x = file1$Date,format ="%d/%m/%Y")
file1$Time<-strptime(x = file1$Time,format = "%H:%M:%S",tz = "")
file1$Time<-format(file1$Time,"%H:%M:%S")
file1$Time<-times(x = file1$Time)
# filter out rows for the sepcific dates into a new df. 1st and 2nd Feb 2007
file2<- file1%>%filter(file1$Date %in% c(as.Date('2007-02-01','%Y-%m-%d'),as.Date('2007-02-02','%Y-%m-%d')))
# drop file1 to free memory.
# convert the other charachter into numeric.
file2$Global_active_power<- as.numeric(file2$Global_active_power)
file2$Global_reactive_power<-as.numeric(file2$Global_reactive_power)
file2$Voltage<-as.numeric(file2$Voltage)
file2$Sub_metering_1<-as.numeric(file2$Sub_metering_1)
file2$Sub_metering_2<-as.numeric(file2$Sub_metering_2)
file2$Global_intensity<-as.numeric(file2$Global_intensity)
rm(file1)
# to make 4 plots
# Plot #1 : Histogram
png(filename ="E:\\johns hopkins\\Exploring Data GitHub\\plot1.png",width = 480,height = 480,units = "px")
g<- ggplot(data = file2,mapping = aes(x = file2$Global_active_power))
g+geom_histogram(bins = 45)
dev.off()
# end of plot1
