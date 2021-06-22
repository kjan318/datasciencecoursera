# Getting and Cleaning Data Project John Hopkins Coursera
# Author: Kieso Jan
# created date: 2021.06.21

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#set up working folder to "S03/W4_Assignment/" ####
getwd()
setwd("S03/W4_Assignment/")

#Loading library
library(data.table)

# Load Packages and get the Data ####
# To run following code can directly download "zip" file from internet 
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")


# Load activity labels + features ####
path <- getwd() #get current working folder

#read activity name from txt file and assign column name "classLabels" & "activityName" respectively
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))

#read feature Names from "features.txt" and assign column name "index" & "featureNames respectively
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))

#To get index value by extract "featureNames" value matching "mean" or "std" from dataframe "features"
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
#apply the output as filter to get exact name of featurenames relates to "mean" or "std"
measurements <- features[featuresWanted, featureNames]
#remove '()' character
measurements <- gsub('[()]', '', measurements)


# Load train datasets ####

#creating train with only mean & std variables by reading file "X_train.txt" & applying index filter "featuresWanted"
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
#rename train column by applying cleaned measurement name 
data.table::setnames(train, colnames(train), measurements)

#reading file "Y_train.txt" with name column name "Activity"
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))

#reading file "subject_train.txt" with name column name "SubjectNum"
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
#combine dataset "trainActivities" & "trainSubjects" to train by following sequence.
train <- cbind(trainSubjects, trainActivities, train)

# Load test datasets ####

#creating test dataset with only mean & std variables by reading file "X_test.txt" & applying index filter "featuresWanted"
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]

#rename test column by applying cleaned measurement name 
data.table::setnames(test, colnames(test), measurements)

#reading file "Y_test.txt" with name column name "Activity"
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))

#reading file "subject_test.txt" with name column name "SubjectNum"
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("SubjectNum"))

#combine dataset "testActivities" & "testSubjects" to test by following sequence.
test <- cbind(testSubjects, testActivities, test)

# merge train & test datasets ####
combined <- rbind(train, test)

# Convert classLabels to activityName basically. More explicit. 
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

#  From the data set above "combined"
# creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

#Writing tidydata to target folder with assigned file name 
data.table::fwrite(x = combined, file = "output/tidyData.txt", quote = FALSE, row.names = FALSE)








