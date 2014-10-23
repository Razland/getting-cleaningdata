## Coursera Getting and Cleaning Data, Johns Hopkins  Oct 2014 course
## assignment D. Kenny.  Download and clean data files specified in
## assignment details.  Output results as a formatted table of original data
## with a separate table of summary information by user and data type.
 
library(plyr) ## Load libraries
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

## Go to my working directory.  Note: developed using wdir on 2nd hard drive of
## Dell studio 1745 T6600 laptop with Linux -- Fedora 20. 
## Your mileage will vary.
startPoint <- 
  "/media/sdb1/Projects/Rstudio/getting-cleaningdata/course_assignment"
setwd(startPoint)

dataDirName <- "UCI HAR Dataset"  ## Download files if the unzipped
if(! file.exists(dataDirName)){   ##  directory isn't present
  print("downloading data")
  dataFileName <- paste0("https://d396qusza40orc.cloudfront.net/",
                          "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
  destFileName <- "UCI_HAR_Dataset.zip"
  download.file(dataFileName, 
                destfile = destFileName, 
                method = "curl")
  dateDownLoaded <- date()
  print("decompressing data files")
  unzip(destFileName)                ## Unzip the files and change to directory
  rm("dataFileName", "destFileName") ## Cleanup
 }

setwd(dataDirName)  ## Change to data directory

print("reading data tables")

## Load header/variable label information into tables
dataColNames <- read.table("features.txt", header=F )
colnames(dataColNames) <- c("index", "names")
dataColNames$names<- stripColumnChars(as.character(dataColNames$names))

activityTypeLabels <- read.table("activity_labels.txt")
colnames(activityTypeLabels) <- c("index", "activity")

## Change activity labels to lower case, remove label punctuation, and fix
## common grammatical error (xyz axis acceleration levels seem too low for 
## subjects to actually be engaged in the stated activity)
activityTypeLabels$activity <- 
  gsub("_"," ",tolower(activityTypeLabels$activity))
activityTypeLabels$activity <- 
  gsub("laying", "lying", activityTypeLabels$activity)

#View(activityTypeLabels)

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
          as.character(
            activityTypeLabels$activity[trainActivityDataTable[,1]]))
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
rm("activityTypeLabels", "dataColNames", "stripColumnChars",
   "testActivityDataTable", "testDataTable", "testUserDataTable",
   "testXYZDataTable", "trainActivityDataTable", "trainDataTable",
   "trainUserDataTable","trainXYDataTable", "dataDirName")

## Go back to nominal starting point.
setwd(startPoint)

## Format and return a pretty and clean data set with simple summary (mean)
## of each measurement for each user by activity name and for all users by
## the activity name.

## Get vectors of activity and user values
print("getting summary user activity data")
userVector <- unique(combDataTable[,1])
activityVector <- sort(unique(combDataTable[,2]))

for(user in userVector){                  ## For each user. iterate through the
  for(activity in activityVector){        ## activity IDs, and push the mean of   
  combDataTable[which(combDataTable$"user ID"==user &  ## all observations to a
                      combDataTable$"activity ID"==activity ),    ## separate
                1:89] %>% ddply(4:89, fun=mean)-> userActivityDF  ## table
  lastRec <- length(userActivityDF[,1])   ## How many did we read?
  if(!"userActivitySummaryTable" %in% ls()){ ## If not initialized, start table
    userActivitySummaryTable <- userActivityDF[lastRec,]
    } else {                                 ## Otherwise, row bind the summary
    userActivitySummaryTable <-              ## to the output table.
      rbind(userActivitySummaryTable, userActivityDF[lastRec,])
    }
  
  }
}
lastRec <- length(userActivitySummaryTable[,1])  ## How many did we get?
row.names(userActivitySummaryTable) <- 1:lastRec ## Clean row names
#View(userActivitySummaryTable)

## Cleanup
rm("lastRec", "userActivityDF", "user", "activity","activityVector", 
   "userVector", "startPoint")

## Return data table
return(combDataTable)