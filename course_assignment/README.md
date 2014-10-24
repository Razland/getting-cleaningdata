Course Assignment Getting and Cleaning Data
Dave Kenny
24 Oct 2014

See associated file CODEBOOK.md for supplemental data description and additional data 
viewing and runtime instructions.

File run_analysis.R can be sourced by any user after modifying variable startPoint (~line 46) 
to point to the user's working directory.  Initially, a zip file, specified in the assignment
text, will be downloaded and decompressed. Subsequent executions won't repeat the download
if the decompressed directory structure is not removed.  On the development system, using
Rstudio, the program will reliably complete in less than 5 minutes, even with downloading as
part of the process.  

Program run_analysis ingests the label and lookup tables for the activity names and then the 
X_t[rain|est].txt data files, combining the resulting tables into a single table.  Data
variables that do not contain standard deviation or mean data are discarded, and 83 variables
are kept from the data set.  Variable labels and the names of the activities are changed to
lower case, and extraneous punctuation, duplicate information, and other text are removed,
and explanatory or full-word text replaces abbreviations.

Observations of user activities are sorted and summarized (mean of each data column) into a
smaller table "userActivitySummaryTable."

The user activity summary table is returned, along with be "combDataTable" containing the
original table with un-summarized data, both remaining in the user's global environment.

The original data producer's data explanation file is reproduced in the same directory as 
this file using the name Data_Readme.txt, and included as the definitive code book.  It
contains a description of the original data and how it was composed. Information used to
translate the data variable names came from this document.  Data variables were changed to
verbosely replace abbreviations with full text, reduce text to lower case, insert spaces
between words, and otherwise give them more the appearance of descriptive technical english
terminology.  These changes are better described in the file CODEBOOK.md.

Also included in this directory are the data host's web page as file
"UCI_Machine_Learning_Repository_Human_Activity_Recognition_Using_Smart_Phones.pdf" and a 
copy of the course assignment page as "Course_project_assignment_and_submit_page.pdf." The
submitted output file of userActivitySummaryTable is included in the github directory as
userActivitySummaryData.txt, but is "manually" output from the console, and not an automatic
product of the script.
