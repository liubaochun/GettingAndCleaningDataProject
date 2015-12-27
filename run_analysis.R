library(dplyr)

#Define the directories and files.
rootDir <- file.path("./UCI HAR Dataset")
testDir <- file.path(rootDir, "test")
trainDir <- file.path(rootDir, "train")
featuresFile <- file.path(rootDir, "features.txt")
activitiesFile <- file.path(rootDir, "activity_labels.txt")
testXFile <- file.path(testDir, "X_test.txt")
testYFile <- file.path(testDir, "y_test.txt")
testSubjectFile <- file.path(testDir, "subject_test.txt")
trainXFile <- file.path(trainDir, "X_train.txt")
trainYFile <- file.path(trainDir, "y_train.txt")
trainSubjectFile <- file.path(trainDir, "subject_train.txt")

#Read features.txt and activity_labels.txt
features <- read.table(featuresFile)
activities <- read.table(activitiesFile)

#Merge the test and train data sets into one data set.
testX <- read.table(testXFile)
testY <- read.table(testYFile)
testSubject <- read.table(testSubjectFile)
test <- cbind(testSubject, testY, testX)
trainX <- read.table(trainXFile)
trainY <- read.table(trainYFile)
trainSubject <- read.table(trainSubjectFile)
train <- cbind(trainSubject, trainY, trainX)
dataSet <- rbind(test, train)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
columnNames <- c("Subject", "ActivityId", as.character(features[, 2]))
grepIndex <- grep("Subject|ActivityId|-std\\(\\)|-mean\\(\\)", columnNames)
columnNames <- make.names(names=columnNames, unique=TRUE, allow_=TRUE)
names(dataSet) <- columnNames
extractDataSet <- select(dataSet, grepIndex)

#Labels the data set with descriptive variable names. 
changeColName <- function(colName) {
    colName <- gsub("tBody", "Time.Body", colName)
    colName <- gsub("tGravity", "Time.Gravity", colName)
    
    colName <- gsub("fBody", "FFT.Body", colName)
    colName <- gsub("fGravity", "FFT.Gravity", colName)
    
    colName <- gsub(".mean...", ".Mean.", colName)
    colName <- gsub(".std...", ".Std.", colName)
    
    colName <- gsub(".mean..", ".Mean", colName)
    colName <- gsub(".std..", ".Std", colName)
    
    return(colName)
}
names(extractDataSet) <- changeColName(columnNames[grepIndex])

#Uses descriptive activity names to name the activities in the data set
names(activities) <- c("ActivityId", "ActivityName")
tidyDataSet <- merge(extractDataSet, activities, by="ActivityId")
tidyDataSet <- tidyDataSet[ , -which(names(tidyDataSet) %in% c("ActivityId"))]

#Create an independent tidy data set with the average of each variable for each activity and each subject.
activitySummary <- (tidyDataSet %>% group_by(Subject,ActivityName) %>% summarise_each(funs( mean)))

#Output to files.
write.csv(tidyDataSet, file = "tidyData.txt",row.names = FALSE)
write.csv(activitySummary, file = "activitySummary.txt",row.names = FALSE)
