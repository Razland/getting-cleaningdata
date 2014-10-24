Codebook for Coursera "Getting and Cleaning Data" course assignment.
To accompany the R script "run_analysis.R", Dave Kenny, 24 Oct 2014.

Data were initially created by UCI using information from Samsung.  Per the assignment,
the data description and data are located at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip,
respectively.  The data zip file contains a README.txt file which is copied in the same
location as this codebook, using the name "Data_Readme.txt".  The UCI data description web
page (first URL, above) as of the time this assignment is completed, is also copied here as
"UCI_Machine_Learning_Repository_Human_Recognition_Using_Smart_Phones.pdf"

This codebook is incomplete without the original producer's Data_Readme.txt.

The course assignment web page is also reproduced here as 
"Course_project_assignment_and_submit_page.pdf"

The implementation of this run_analysis script interpreted the assignment instructions to
modify the data variable names and the activity labels by removing all punctuation text and 
by replacing all abbreviations with the full form of the terms as they aredescribed in
Data_Readme.txt.  Variable names and activity labels were also changed to lower case, and
separated by spaces.  In the case of the variable names, this has resulted in rather long
and ungainly "column" labels.  For instance, the original data variable "tBodyAcc-mean()-X" 
is modified by the script to the "tidy" (and verbose) name "time domain body accelerometer
mean x axis". Likewise, the abbreviation "std" is replaced by the full "standard deviation",
and "acc" by "accelerometer" (Note: not "acceleration", while the second term was probably 
intended by the data producer, only "accelerometer" was found in the original data 
instrument description for the readings in the data).  These terms are verbose, but it is
believed that they meet the requirements of the assignment.

Per the assignment, the script removes all data variables from the original data set that
do not contain the "[Mm]ean" or "std" (standard deviation) tags.  Those that remain are the
only original data produced in the table named "combDataTable", which remains in the user's
Global Environment in Rstudio after the run_analysis script is completed. A second table, 
"userActivitySummaryTable" contains the data for the final part of the assignment -- each
data variable is averaged for each user and activity.  This table is written out and
submitted for the assignment as userActivitySummaryData.txt (from Coursera peer assessment
page, linked at 
https://s3.amazonaws.com/coursera-uploads/user-4382e8e1899332caa83d7adb/972586/asst-3/0dd477305a7c11e48f30cb53ef02ead9.txt )
As per the course forumn discussion page " David's " at 
https://class.coursera.org/getdata-008/forum/thread?thread_id=24, the data can be viewed by
loading it into R using the following code:

data <- read.table(file_path, header = TRUE)
View(data)
