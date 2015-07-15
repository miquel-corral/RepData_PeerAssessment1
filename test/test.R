# unzip dataset file
unzip("activity.zip")

# read the data
row_data <- read.csv("activity.csv")

# quick look at the row data
summary(row_data)
head(row_data)

## mean total number of steps taken per day

# total number of steps taken per day
total_steps_per_day<-aggregate(steps~date,data=row_data,sum,na.rm=TRUE)

# histogram of total number of steps taken each day
hist(total_steps_per_day$steps,col="blue",xlab="Total steps taken each day", main="Histogram - Total steps taken each day")

# median and mean of the total number of steps taken per day
# median
median_steps_taken_daily <-median(total_steps_per_day$steps)
# mean
mean_steps_taken_daily <-mean(total_steps_per_day$steps)


## What is the average daily activity pattern?

# time series plot of the 5 min. interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
# 1. calculate the average of steps for the 5' interval
average_steps_per_interval <- aggregate(steps~interval, data=row_data, mean)
# 2. plot
plot(average_steps_per_interval$interval, average_steps_per_interval$steps,type="l", frame=FALSE, col="blue",main="Average daily activity pattern accross all days",xlab="5-minute interval", ylab="Average number of steps")

# Which 5-minutes interval, on average accross all the days in the dataset, contains the maximum number of steps?
max.interval <- average_steps_per_interval[which.max(average_steps_per_interval$steps),]

## Imputing missing values

# calculate and report the total number of missing values in the dataset(i.e. the total number of rows with NAs)
total_rows_with_NAs <- sum(is.na(row_data$steps))

# devise a strategy for filling in all of the missing values in the dataset. 
# my option is to use the mean of the interval accross all days given the observacion of the original dataset that shows there are NA values spread among all days

#Create a new dataset that is equal to the original dataset but with all the missing data filled in.
# new dataset
no_na_data <- row_data
# rows with na values
rows_with_na_values <- which(is.na(row_data))
# fill na values with average values for the interval accross all days
for (i in rows_with_na_values) { 
  no_na_data[i, 1] <- average_steps_per_interval[average_steps_per_interval$interval==no_na_data[i,3], 2]
}
summary(no_na_data)



# make a histogram of the total number of steps taken each day
# calculate data
total_steps_per_day_no_na <-aggregate(steps~date,data=no_na_data,sum,na.rm=TRUE)
# plot histogram
hist(total_steps_per_day_no_na$steps,col="blue",xlab="Total steps taken each day", main="Histogram - Total steps taken each day with no NA values")
# Mean of steps taken per day
mean_steps_taken_daily_no_na <- mean(total_steps_per_day_no_na$steps)
# median of steps taken per day
median_steps_taken_daily_no_na <- median(total_steps_per_day_no_na$steps)
# do these values differ from the estimates from the first part of the assignment?
# the variation is a slight increase due to the filling of the NA values with the mean values of the intervals.
# in the histogram this increase can be appreciated as an increase in the total steps taken each day in the central range of values, as we replace NAs with average values.

## Are there differences in activity patterns between weekdays and weekends?

# create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating wether a given date is a weekday or a weekend day
# create the new factor variable
no_na_data$date <- as.Date(no_na_data$date,"%Y-%m-%d")
week_days <- weekdays(no_na_data$date) %in% c("Saturday", "Sunday", "sabado", "domingo")
no_na_data$weekend_or_weekday <- ifelse(week_days, "weekend", "weekday")


# make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged accross all weekdays or weekend days (y-axis)
# caculation of average steps grouping by interval on weekdays 
average_steps_taken_weekdays_by_interval <- aggregate(steps ~ interval, subset(no_na_data, weekend_or_weekday=="weekday"), mean)
# caculation of average steps grouping by interval on weekends
average_steps_taken_weekends_by_interval <- aggregate(steps ~ interval, subset(no_na_data, weekend_or_weekday=="weekend"), mean)

# print the plot
par(mfrow=c(2,1))
plot(x=average_steps_taken_weekdays_by_interval$interval, y=average_steps_taken_weekdays_by_interval$steps,main="Average steps taken at weekdays", xlab="5-minute interval", ylab="",type='l', ylim=c(0,200), frame=FALSE, col="blue")
plot(x=average_steps_taken_weekends_by_interval$interval, y=average_steps_taken_weekends_by_interval$steps,main="Average steps taken at weekends", xlab="5-minute interval", ylab="",type='l', ylim=c(0,200), frame=FALSE, col="blue")

# Observation: at the weekend activity starts a bit late and it is less concentrated in first part of the day, it is more distributed along the day.




