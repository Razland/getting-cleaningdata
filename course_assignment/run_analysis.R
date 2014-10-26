## Coursera Getting and Cleaning Data, Johns Hopkins  Oct 2014. Course
## assignment. Download and clean data files specified in assignment details.
## Output results as a formatted table of original data with a separate table
## of summary information (mean) by user and data type.  D. Kenny.
 
library(plyr)                                 ## Load libraries
library(dplyr)
library(tidyr)
library(stringr)

stripColumnChars <- function(inStr) {         ## A very ugly function to
  inStr <- tolower(inStr)                     ## prettify input data variable
  inStr <- gsub("\\,|\\(|\\)|\\-", "", inStr) ## names for the output table
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
#  View(inStr)                                 ## debug View
  return(inStr)
}

## Go to my working directory.  Note: developed using wrkdir on 2nd hard drive
## of Dell studio 1745 T6600 laptop with 64 bit Linux (Fedora 20). 
## Your mileage will vary.
startPoint <-   ## !! Modify the following line to your working directory !! ##
  "/media/sdb1/Projects/Rstudio/getting-cleaningdata/course_assignment"
if(!file.exists(startPoint)){                  ## If this isn't on my PC, tell
  printf(                                      ## the user to edit this script.
    paste0("Directory not found. ",            ## and quit.
           "Modify startPoint variable in run_analysis.R"))
  return(0)                                    
  }
setwd(startPoint)

dataDirName <- "UCI HAR Dataset"               ## Download files if the unzipped
if(! file.exists(dataDirName)){                ## data directory isn't present
  print("downloading data")
  dataFileName <- 
    paste0("https://d396qusza40orc.cloudfront.net/",
           "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
  destFileName <- "UCI_HAR_Dataset.zip"
  download.file(dataFileName, 
                destfile = destFileName, 
                method = "curl")
  dateDownLoaded <- date()
  print("decompressing data files")
  unzip(destFileName)                          ## Unzip the files and change
                                               ## to new directory.
  rm("dataFileName", "destFileName")           ## Cleanup
 }

setwd(dataDirName)                             ## Change to data directory

print("reading data tables")

dataColNames <-                                ## Load header/variable label
  read.table("features.txt", header=F )        ## information into tables
colnames(dataColNames) <- 
  c("index", "names")
dataColNames$names<-                           ## Send column names to 
  stripColumnChars(as.character(               ## formatting function
      dataColNames$names)) 

activityTypeLabels <- 
  read.table("activity_labels.txt")
colnames(activityTypeLabels) <- 
  c("index", "activity")

activityTypeLabels$activity <-                 ## Change activity labels to
  gsub("_",                                    ## lower case, remove label
       " ",                                    ## punctuation, and fix common
       tolower(activityTypeLabels$activity))   ## grammatical error (xyz axis 
activityTypeLabels$activity <-                 ## acceleration levels seem too
  gsub("laying",                               ## low for subjects to actually 
       "lying",                                ## be engaged in the stated
       activityTypeLabels$activity)            ## activity)
#View(activityTypeLabels)                      ## debug commented out

trainXYDataTable <-                            ## Load train data, naming 
  read.table("train/X_train.txt", header=F )   ## columns to dataColNames 
colnames(trainXYDataTable) <-                  ## values.  
  dataColNames[1:561,2]
 
trainUserDataTable <-                          ## Load train user and activity
  rename(read.table("train/subject_train.txt", ## data into tables, naming User
                    header=F ),                ## ID and Activity variables at
        "user ID" = V1)                        ## column headings.
trainActivityDataTable <- 
  rename(read.table("train/y_train.txt", 
                    header=F ), 
         "activity ID" = V1)
trainActivityDataTable <-                      ## Add column for Activity Name
  mutate(trainActivityDataTable,               ## from activityTypeLabels
        "activity name" = 
          as.character(
            activityTypeLabels$activity[trainActivityDataTable[,1]]))
trainDataTable <-                              ## Join train data into a single
  cbind(trainUserDataTable,                    ## table, with Subject ID,
        trainActivityDataTable,                ## Activity data, and
        trainXYDataTable )                     ## trainXY computed values

testXYZDataTable <-                            ## Load test data, naming
  read.table("test/X_test.txt", header=F )     ## columns to dataColNames
colnames(testXYZDataTable) <-                  ## values
  dataColNames[1:561,2]

testUserDataTable <-                           ## Load test user and activity
  rename(read.table("test/subject_test.txt",   ## data, naming User ID and 
                    header=F ),                ## Activity variables
         "user ID" = V1)                       ##
testActivityDataTable <- 
  rename(read.table("test/y_test.txt", 
                    header=F ), 
        "activity ID" = V1)
testActivityDataTable <-                       ## Add column for Activity Name
  mutate(testActivityDataTable,                ## from activityTypeLabels
         "activity name" =                     ##
          as.character(
            activityTypeLabels$activity[
              testActivityDataTable[,1]]))

testDataTable <-                               ## Join Test data to a single 
  cbind(testUserDataTable,                     ## table, including Subject ID,
        testActivityDataTable,                 ## Activity data, and
        testXYZDataTable )                     ## testXY computed values

combDataTable <-                               ## Concatenate Test and Train
  rbind(testDataTable,                         ## data tables to one object.
        trainDataTable)                        ## Too many variables!

combDataTable <-                               ## Gross extraction of only the
  combDataTable[,                              ## columns with std dev, user, 
      grep("mean|deviation|user|activity",     ## activity, and mean data 
            names(combDataTable))]             ## summaries. List of both table
                                               ## column names.
#View(names(combDataTable))                    ## debug
combDataTable <- 
  arrange(combDataTable,
          combDataTable[,3], 
          combDataTable[,1])

rm("activityTypeLabels", "dataColNames",       ## Cleanup all interim functions 
   "stripColumnChars", "testActivityDataTable",## and data. 
   "testDataTable", "testUserDataTable",
   "testXYZDataTable", "trainActivityDataTable", 
   "trainDataTable", "trainUserDataTable",
   "trainXYDataTable", "dataDirName")

setwd(startPoint)                              ## Go back to nominal starting 
                                               ## point.

## Format and return a pretty and clean data set with simple summary (mean)
## of each measurement for each user by activity name and for all users by
## the activity name.

print("getting summary user activity data")    ## Get vectors of activity and user
userVector <- unique(combDataTable[,1])        ## values
activityVector <- sort(unique(combDataTable[,2]))

for(user in userVector){                       ## For each user. iterate  
  for(activity in activityVector){             ## through the activity IDs, and
  combDataTable[which(                         ## push the mean of all
        combDataTable$"user ID"==user &        ## observations to a 
        combDataTable$"activity ID"==activity) ## separate table. Use
                   ,1:89] %>%                  ## command chainingto fill the 
                ddply(4:89, fun=mean)->        ## output data frame with all 
                  userActivityDF               ## rows, including the new mean
  lastRec <- length(userActivityDF[,1])        ## summary. If not initialized,
  if(!"userActivitySummaryTable" %in% ls()){   ## start an output table
    userActivitySummaryTable <-                ## instance using only the last,
      userActivityDF[lastRec,]                 ## newest observation (mean)
    }                                          ## computed by ddply. Otherwise,
  else {                                       ## append the last row of this
    userActivitySummaryTable <-                ## iteration of the summary to
      rbind(userActivitySummaryTable,          ## the output data frame. 
            userActivityDF[lastRec,])          ## Discard the original data 
    }                                          ## observations (rows) kept by 
  }                                            ## ddply. 
}
lastRec <-                                     ## How many rows of mean did we
  length(userActivitySummaryTable[,1])         ## get?
row.names(userActivitySummaryTable) <- 
  1:lastRec                                    ## Clean row names from View.
#View(userActivitySummaryTable)                ## uncomment for debug

rm("lastRec", "userActivityDF", "user",        ## Cleanup
   "activity", "activityVector", 
   "userVector", "startPoint")

#return(combDataTable)                         ## Return full data table
return(userActivitySummaryTable)               ## Return summary table