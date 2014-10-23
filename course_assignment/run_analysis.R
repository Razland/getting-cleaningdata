## Coursera Getting and Cleaning Data, Johns Hopkins  Oct 2014
## course assignment D. Kenny.  Download and clean data files specified
## in assignment details.  Output results as a formatted table of original 
## data with a separate table of summary information by user and data type.
## Load libraries
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)

stripColumnChars <- function(inStr) { ## A very ugly function to prettify 
  inStr <- tolower(inStr)             ## variable names for the output table
  inStr <- gsub("\\,|\\(|\\)|\\-", "", inStr)
  inStr <- gsub("bodybody", " body ", inStr)
  inStr <- gsub("tgravity", "time domain gravity", inStr)
  inStr <- gsub("f {0,9}body", "frequency domain body", inStr)
  inStr <- gsub("t {0,9}body", "time domain body", inStr)
  inStr <- gsub("mean", " mean ", inStr)
  inStr <- gsub("mag", " magnitude ", inStr)
  inStr <- gsub("gyro", " gyroscopic ", inStr)
  inStr <- gsub("jerk", " jerk ", inStr)
  inStr <- gsub("acc", " accelerometer ", inStr)
  inStr <- gsub("mean {0,9}x", "mean x axis", inStr)
  inStr <- gsub("mean {0,9}y", "mean y axis", inStr)
  inStr <- gsub("mean {0,9}z", "mean z axis", inStr)
  inStr <- gsub("std {0,9}x", "standard deviation x axis", inStr)
  inStr <- gsub("std {0,9}y", "standard deviation y axis", inStr)
  inStr <- gsub("std {0,9}z", "standard deviation z axis", inStr)
  inStr <- gsub("std", "standard deviation", inStr)
  inStr <- gsub("freqx", "frequency x axis", inStr)
  inStr <- gsub("freqy", "frequency y axis", inStr)
  inStr <- gsub("freqz", "frequency z axis", inStr)
  inStr <- gsub("anglexgravity", "angular x axis gravity", inStr)
  inStr <- gsub("angleygravity", "angular y axis gravity", inStr)
  inStr <- gsub("anglezgravity", "angular z axis gravity", inStr)
  inStr <- gsub("anglet", "angular t", inStr)
  inStr <- gsub(" {2,9}", " ", inStr)
  inStr <- str_trim(inStr)
#  View(inStr)  ## debug View is better than print statements
  return(inStr)
}

## go to my working directory.  Note: developed using wd on 2nd hard drive of
## Dell studio 1745 laptop Linux -- Fedora 20.  Your mileage will vary.
setwd("/media/sdb1/Projects/Rstudio/getting-cleaningdata/course_assignment")

## Download files if the unzipped directory isn't present
dataDirName <- "UCI HAR Dataset"
if(! file.exists(dataDirName)){
  dataFileName <- 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destFileName <- "UCI_HAR_Dataset.zip"
  download.file(dataFileName, destfile = destFileName, method = "curl")
  ## unzip the files and change to directory
  unzip(destFileName)
 }
##change to data directory
setwd(dataDirName)

## load header/variable label information into tables
dataColNames <- read.table("features.txt", header=F )
colnames(dataColNames) <- c("index", "names")
dataColNames$names<- stripColumnChars(as.character(dataColNames$names))

activityTypeLabels <- read.table("activity_labels.txt")
colnames(activityTypeLabels) <- c("index", "activity")

## Load train data, naming columns to dataColNames values
trainXYDataTable <- read.table("train/X_train.txt", header=F )
colnames(trainXYDataTable)<- dataColNames[1:561,2]
## Load train user and activity data into tables, 
## naming User ID and Activity variables
trainUserDataTable <- 
  rename(read.table("train/subject_train.txt", header=F ), "user ID" = V1)
trainActivityDataTable <- 
  rename(read.table("train/y_train.txt", header=F ), "activity ID" = V1)
## Add column for Activity Name from activityTypeLabels
trainActivityDataTable <- 
  mutate(trainActivityDataTable, 
        "activity name" = 
        as.character(activityTypeLabels$activity[trainActivityDataTable[,1]]))
## Join Train data into a single table
trainDataTable <- cbind(trainUserDataTable, 
                        trainActivityDataTable, 
                        trainXYDataTable )


## Load test data, naming columns to dataColNames values
testXYZDataTable <- read.table("test/X_test.txt", header=F )
colnames(testXYZDataTable)<- dataColNames[1:561,2]
## Load test user and activity data, naming User ID and Activity variables
testUserDataTable <- 
  rename(read.table("test/subject_test.txt", header=F ), "user ID" = V1)
testActivityDataTable <- 
  rename(read.table("test/y_test.txt", header=F ), "activity ID" = V1)
## Add column for Activity Name from activityTypeLabels
testActivityDataTable <- 
  mutate(testActivityDataTable, 
         "activity name" = 
          as.character(activityTypeLabels$activity[testActivityDataTable[,1]]))

## Join Test data to a single table
testDataTable <- 
  cbind(testUserDataTable, testActivityDataTable, testXYZDataTable)
## Concatenate Test and Train data tables to one
combDataTable <- rbind(testDataTable, trainDataTable)

## Gross extraction of only the columns with std dev, user, activity, and mean 
## data summaries.  List of both table column names.
combDataTable <- 
  combDataTable[,grep("mean|deviation|user|activity",names(combDataTable))]

#View(names(combDataTable))  ## Debugging: better than print statements
combDataTable <- arrange(combDataTable,combDataTable[,3], combDataTable[,1])

## Cleanup all interim functions and data.
rm("activityTypeLabels", "dataColNames", "dataFileName", "destFileName",
   "testActivityDataTable", "testDataTable", "testUserDataTable",
   "testXYZDataTable", "trainActivityDataTable", "trainDataTable",
   "trainUserDataTable","trainXYDataTable", "dataDirName", 
   "stripColumnChars")

## Go back to nominal starting point.
setwd("/media/sdb1/Projects/Rstudio/getting-cleaningdata/course_assignment")

## To do: format and somehow also return a pretty and clean data set with 
## summary (mean) of each measurement for each user by activity name and for 
## all users by activity name.


## Return data table
return(combDataTable)