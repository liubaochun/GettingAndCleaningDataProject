## Getting and Cleaning Data - Project

### Data Source
Source dataset https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

### Requirements
*  You should create one R script called run_analysis.R that does the following.
*  Merges the training and the test sets to create one data set.
*  Extracts only the measurements on the mean and standard deviation for each measurement.
*  Uses descriptive activity names to name the activities in the data set
*  Appropriately labels the data set with descriptive activity names.
*  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Notes
*  Requires dplyr package.
*  Assumes the dataset is unzipped in the current directory with name "UCI HAR Dataset"

##  How to run in a command line?

```bash
$ Rscript run_analysis.R
```

tidyData.txt and activitySummary.txt are output.