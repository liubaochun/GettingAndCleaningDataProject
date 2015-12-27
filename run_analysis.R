library(dplyr)

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

features <- read.table(featuresFile)
activities <- read.table(activitiesFile)

testX <- read.table(testXFile)
testY <- read.table(testYFile)
testSubject <- read.table(testSubjectFile)
test <- cbind(testSubject, testY, testX)
trainX <- read.table(trainXFile)
trainY <- read.table(trainYFile)
trainSubject <- read.table(trainSubjectFile)
train <- cbind(trainSubject, trainY, trainX)
dataSet <- rbind(test, train)

columnNames <- c("Subject", "ActivityId", as.character(features[, 2]))
grepIndex <- grep("Subject|ActivityId|-std\\(\\)|-mean\\(\\)", columnNames)
columnNames <- make.names(names=columnNames, unique=TRUE, allow_=TRUE)
names(dataSet) <- columnNames
extractDataSet <- select(dataSet, grepIndex)
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
names(activities) <- c("ActivityId", "ActivityName")
tidyDataSet <- merge(extractDataSet, activities, by="ActivityId")
tidyDataSet <- tidyDataSet[ , -which(names(tidyDataSet) %in% c("ActivityId"))]

activitySummary <- (tidyDataSet %>% group_by(Subject,ActivityName) %>% summarise_each(funs( mean)))

write.csv(tidyDataSet, file = "tidyData.txt",row.names = FALSE)
write.csv(activitySummary, file = "activitySummary.txt",row.names = FALSE)
