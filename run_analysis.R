## Getting and Cleaning Data Course Project
## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

## Library
library(data.table)

## Read data 

featuredata <- read.table('./data/UCI HAR Dataset/features.txt')
## Test Set
test_x <- read.table('./data/UCI HAR Dataset/test/X_test.txt',col.names=featuredata[,2])
test_activity <- read.table('./data/UCI HAR Dataset/test/y_test.txt',col.names = 'activity')
test_subject <- read.table('./data/UCI HAR Dataset/test/subject_test.txt',col.names = 'subject')
test_data <- data.frame(test_subject,test_activity,test_x)

## Train Set
train_x <- read.table('./data/UCI HAR Dataset/train/X_train.txt',col.names=featuredata[,2])
train_activity <- read.table('./data/UCI HAR Dataset/train/y_train.txt', col.names = 'activity')
train_subject <- read.table('./data/UCI HAR Dataset/train/subject_train.txt',col.names = 'subject')
train_data <- data.frame(train_subject,train_activity,train_x)


## 1 Merges the training and the test sets to create one data set.
all_data <- rbind(train_data,test_data)

## 2 Extracts only the measurements on the mean and standard deviation for each measurement.
##   preserve the first 2 columns (subject,activity)
mean_std_filter <- grepl('mean|std', featuredata[,2])
mean_std_data <- all_data[,c(TRUE,TRUE,mean_std_filter)]

## 3 Uses descriptive activity names to name the activities in the data set
activity_label <- read.table('./data/UCI HAR Dataset/activity_labels.txt')
activity_label <- as.character(activity_label[,2])
mean_std_data$activity <- activity_label[mean_std_data$activity]


## 4 Appropriately labels the data set with descriptive variable names.
names(mean_std_data)<-gsub("^t", "time", names(mean_std_data))
names(mean_std_data)<-gsub("^f", "frequency", names(mean_std_data))
names(mean_std_data)<-gsub("Acc", "Accelerometer", names(mean_std_data))
names(mean_std_data)<-gsub("Gyro", "Gyroscope", names(mean_std_data))
names(mean_std_data)<-gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data)<-gsub("BodyBody", "Body", names(mean_std_data))

## 5 From the data set in step 4, creates a second, independent tidy data set with the average 
##   of each variable for each activity and each subject
clean_data <- aggregate(mean_std_data[,3:81], by = list(subject = mean_std_data$subject, 
                                                       activity = mean_std_data$activity  ),FUN = mean)
write.table(x = clean_data, file = "tidy_data.txt", row.names = FALSE)
