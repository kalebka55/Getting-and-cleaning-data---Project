# Downlaod file and unzip data in wd if not already available
wd <- getwd()
if ( !exists("UCI HAR Dataset")) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile= "UCI HAR Dataset.zip",
                      quiet= TRUE)
        unzip("UCI HAR Dataset.zip")
        
        setwd(paste(getwd(), "UCI HAR Dataset", sep= "/"))
        
        data_wd <- getwd()
}

# Assign features and activity labels to an object
features <- read.table("features.txt", header= FALSE, sep= " ")
activity <- read.table("activity_labels.txt", header= FALSE)

# Import training data, reduce and clean
setwd(paste(getwd(), "train", sep= "/"))
subject_train <- read.table("subject_train.txt")
training_data <- read.table("X_train.txt")      
training_activity <- read.table("y_train.txt")

## select mean and std data
colnames(training_data) <- t(features[,2])
training_data_mean <- training_data[,grep("mean()", colnames(training_data))]
training_data_std <- training_data[,grep("std()", colnames(training_data))]
training_data <- cbind(subject_train, training_activity, 
                       training_data_mean, training_data_std)

colnames(training_data)[1] <- "subject"
colnames(training_data)[2] <- "activity"
training_data$data_type <- "training"

##  rename activity value with activity name
training_data$activity <- activity[match(training_data$activity, activity$V1), 2]

# remove obsolete objects and reset wd
rm(training_activity, subject_train, training_data_mean, training_data_std)
setwd(data_wd)

# Import test data, reduce and clean
setwd(paste(getwd(), "test", sep= "/"))
subject_test <- read.table("subject_test.txt")
test_data <- read.table("X_test.txt")
test_activity <- read.table("y_test.txt")

## select mean and std data
colnames(test_data) <- t(features[,2])
test_data_mean <- test_data[,grep("mean()", colnames(test_data))]
test_data_std <- test_data[,grep("std()", colnames(test_data))]
test_data <- cbind(subject_test, test_activity, 
                       test_data_mean, test_data_std)

colnames(test_data)[1] <- "subject"
colnames(test_data)[2] <- "activity"
test_data$data_type <- "test"

## reassign activity value with acitvity name
test_data$activity <- activity[match(test_data$activity, activity$V1), 2]

# merge training and test data sets
data <- rbind(training_data, test_data)
data$subject <- as.factor(data$subject)
data$data_type <- as.factor(data$data_type)

# remove obsolete objects
rm(test_activity, subject_test, features, activity, training_data, test_data,
   test_data_mean, test_data_std)

library(plyr); library(dplyr); library(reshape2)

# Calculate means of columns & tidy data
data_mean <- aggregate(x= data, by= list(data$subject, data$activity, data$data_type), FUN= "mean")
data_mean <- subset(data_mean, select = -c(4,5,85))
colnames(data_mean)[1] <- "Subject"
colnames(data_mean)[2] <- "Activity"
colnames(data_mean)[3] <- "Data_Type"
data_mean <- arrange(data_mean, Subject, Activity)
rm(data); setwd(wd)

# melt mean calculations by direction (x ,y, z)

data <- list()

datamelt <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-mean()-Z"),
                  value.name= "tbody acc-mean()")
        colnames(datamelt)[4] <- "movement_axis"
        colnames(datamelt)[5] <- "mean tbodyacc"

tGravAcc <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c("tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z"), 
                  value.name= "tGravityAcc-mean()")
        colnames(tGravAcc)[5] <- "mean tgravity acc"              
        data[[1]] <- tGravAcc ; rm(tGravAcc)

tBodAccJerk <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c("tBodyAccJerk-mean()-X", "tBodyAccJerk-mean()-Y", "tBodyAccJerk-mean()-Z"), 
                  value.name= "tBodyAccJerk-mean()")
        colnames(tBodAccJerk)[5] <- "mean tbody acc jerk"
        data[[2]] <- tBodAccJerk ; rm(tBodAccJerk)

tBodyGyro <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c("tBodyGyro-mean()-X", "tBodyGyro-mean()-Y", "tBodyGyro-mean()-Z"), 
                  value.name= "tBodyGyro-mean()")
        colnames(tBodyGyro)[5] <- "mean tbodygyro"
        data[[3]] <- tBodyGyro ; rm(tBodyGyro)

tBodyGyroJerk <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c("tBodyGyroJerk-mean()-X" ,"tBodyGyroJerk-mean()-Y", "tBodyGyroJerk-mean()-Z"), 
                  value.name= "tBodyGyroJerk-mean()")
        colnames(tBodyGyroJerk)[5] <- "mean tbodygyrojerk"
        data[[4]] <- tBodyGyroJerk ; rm(tBodyGyroJerk)

fBodyAccFreq <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c( "fBodyAcc-meanFreq()-X", "fBodyAcc-meanFreq()-Y", "fBodyAcc-meanFreq()-Z"), 
                  value.name= "fBodyAcc-meanFreq()")
        colnames(fBodyAccFreq)[5] <- "mean freq fbody acc "
        data[[5]] <- fBodyAccFreq ; rm(fBodyAccFreq)

fBodyAcc <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c( "fBodyAcc-mean()-X", "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z"), 
                  value.name= "fBodyAcc-mean()")
        colnames(fBodyAcc)[5] <- "mean fbody acc"
        data[[6]] <- fBodyAcc ; rm(fBodyAcc)

fBodAccJerk <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c( "fBodyAccJerk-mean()-X", "fBodyAccJerk-mean()-Y", "fBodyAccJerk-mean()-Z"), 
                  value.name= "fBodyAccJerk-mean()")
        colnames(fBodAccJerk)[5] <- "mean fbody acc jerk"
        data[[7]] <- fBodAccJerk ; rm(fBodAccJerk)

fBodAccJerkFreq <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                  measure.vars= c( "fBodyAccJerk-meanFreq()-X", "fBodyAccJerk-meanFreq()-Y", "fBodyAccJerk-meanFreq()-Z"), 
                  value.name= "fBodyAccJerk-meanFreq()")
        colnames(fBodAccJerkFreq)[5] <- "mean fbody acc"
        data[[8]] <- fBodAccJerkFreq ; rm(fBodAccJerkFreq)

fBodGyro <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "fBodyGyro-mean()-X", "fBodyGyro-mean()-Y", "fBodyGyro-mean()-Z"), 
                   value.name= "fBodyGyro-mean()")
        colnames(fBodGyro)[5] <- "mean fbody gyro"
        data[[9]] <- fBodGyro ; rm(fBodGyro)

fBodGyroFreq <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "fBodyGyro-meanFreq()-X", "fBodyGyro-meanFreq()-Y", "fBodyGyro-meanFreq()-Z"), 
                   value.name= "fBodyGyro-meanFreq()")
        colnames(fBodGyroFreq)[5] <- "mean freq fbodygyro"
        data[[10]] <- fBodGyroFreq ; rm(fBodGyroFreq)

tBodAccStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "tBodyAcc-std()-X", "tBodyAcc-std()-Y", "tBodyAcc-std()-Z"), 
                   value.name= "tBodyAcc-std()")
        colnames(tBodAccStd)[5] <- "stdev tbody acc"
        data[[11]] <- tBodAccStd ; rm(tBodAccStd)

tGravStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "tGravityAcc-std()-X", "tGravityAcc-std()-Y", "tGravityAcc-std()-Z"), 
                   value.name= "tGravityAcc-std()")
        colnames(tGravStd)[5] <- "stdev tgrav acc"
        data[[12]] <- tGravStd ; rm(tGravStd)

tBodAccJerkStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "tBodyAccJerk-std()-X", "tBodyAccJerk-std()-Y", "tBodyAccJerk-std()-Z"), 
                   value.name= "tBodyAccJerk-std()")
        colnames(tBodAccJerkStd)[5] <- "stdev tbody acc jerk"
        data[[13]] <- tBodAccJerkStd ; rm(tBodAccJerkStd)

tBodGyroStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "tBodyGyro-std()-X", "tBodyGyro-std()-Y", "tBodyGyro-std()-Z"), 
                   value.name= "tBodyGyro-std()")
        colnames(tBodGyroStd)[5] <- "stdev tbody gyro"
        data[[14]] <- tBodGyroStd ; rm(tBodGyroStd)

tBodGyroJerkStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "tBodyGyroJerk-std()-X", "tBodyGyroJerk-std()-Y", "tBodyGyroJerk-std()-Z" ), 
                   value.name= "tBodyGyroJerk-std()")
        colnames(tBodGyroJerkStd)[5] <- "stdev tbodygyro jerk"
        data[[15]] <- tBodGyroJerkStd ; rm(tBodGyroJerkStd)

fBodAccStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "fBodyAcc-std()-X",  "fBodyAcc-std()-Y", "fBodyAcc-std()-Z"), 
                   value.name= "fBodyAcc-std()")
        colnames(fBodAccStd)[5] <- "stdev fbody acc"
        data[[16]] <- fBodAccStd ; rm(fBodAccStd)

fBodAccJerkStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c( "fBodyAccJerk-std()-X", "fBodyAccJerk-std()-Y", "fBodyAccJerk-std()-Z"), 
                   value.name= "fBodyAccJerk-std()")
        colnames(fBodAccJerkStd)[5] <- "stdev fbody acc jerk"
        data[[17]] <- fBodAccJerkStd ; rm(fBodAccJerkStd)

fBodGyroStd <- melt(data_mean, id= c("Subject", "Activity", "Data_Type"), 
                   measure.vars= c(  "fBodyGyro-std()-X", "fBodyGyro-std()-Y", "fBodyGyro-std()-Z"), 
                   value.name= "fBodyGyro-std()")
        colnames(fBodGyroStd)[5] <- "stdev fbody gyro"
        data[[18]] <- fBodGyroStd ; rm(fBodGyroStd)


for (i in seq_along(data)) { 

colname <- colnames(data[[i]][5]) 
datamelt <- cbind(datamelt, colname= data[[i]][, 5])
colnames(datamelt)[ncol(datamelt)] <- colname
}

datamelt$movement_axis <- gsub("tBodyAcc-mean()-", "", datamelt[,4], fixed=T)

rm(data, i, colname, data_mean, wd, data_wd)


# Write tidy data to text file
write.table(datamelt, file= "run_analysis_output.txt", sep= " ", row.names= FALSE)
