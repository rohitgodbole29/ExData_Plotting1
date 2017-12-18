# load the data
library(chron)
library(ggplot2)
library(lubridate)
library(data.table)
library(cowplot)
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
# combine the date and time into a single new column
file2$date_time<-ymd_hms(paste(file2$Date,file2$Time))

# let us show the facets in a grid.
# plotting below...

plotlbc<-ggplot(data = file2,mapping = aes(x = file2$date_time))+
    geom_line(aes(y =file2$Sub_metering_1,color="Sub_metering_1"))+
    geom_line(aes(y =file2$Sub_metering_2,color="Sub_metering_2"))+
    geom_line(aes(y =file2$Sub_metering_3,color="Sub_metering_3"))+
    scale_x_datetime(date_labels = "%a")+
    scale_color_manual("",values = c("Sub_metering_1" ="red","Sub_metering_2"="blue","Sub_metering_3"="black"))+
    ylab(label="Energy Sub-metering")+
    xlab(label = "")
# this above plot is the left bottom vcorner of the grid.

plotltc<-ggplot(data = file2,mapping = aes(x = file2$date_time,y = file2$Global_active_power))+
  geom_line()+scale_x_datetime(date_labels = "%a")+xlab(label = "")+ylab(label = "Global active power(kilowatts)")
# Above plot is the left top corner.

plotrtc<-ggplot(data = file2,mapping = aes(x = file2$date_time,y = file2$Voltage))+
  geom_line()+scale_x_datetime(date_labels = "%a")+xlab(label = "datetime")+ylab(label = "Voltage")
# above plot is the top right corner

plotrbc<- ggplot(data = file2,mapping = aes(x = file2$date_time,y = file2$Global_reactive_power))+
  geom_line()+scale_x_datetime(date_labels = "%a")+xlab(label = "datetime")+ylab(label = "Global_reactive_power")
# above plot is the bottom right corner

# make a grid below
png(filename ="E:\\johns hopkins\\Exploring Data GitHub\\plot4.png",width = 480,height = 480,units = "px")
plot_grid(plotltc,plotlbc,plotrbc,plotrtc,align = "h",axis = "b",nrow = 2,ncol = 2,rel_widths = c(1,1),rel_heights = c(1,1))
dev.off()
# end of plot4

    