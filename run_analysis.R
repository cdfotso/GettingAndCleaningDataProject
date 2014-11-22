####### DOWNLOAD THE DATA ######

setwd("~/CourseraProject")

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
zipFileName <- "RAW_DATA.zip"
download.file(url,destfile="RAW_DATA.zip",mode="wb",method="curl")
unzip(zipFileName)

######### TIDY DATA I ##########

mergeData <- function(df1,df2) {
  rbind(df1,df2)
}

addColumn <- function(df1,df2) {
  cbind(df1,df2)
}

#1 Add the subjects columns
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects <- mergeData(subjects_train,subjects_test)
colnames(subjects) <- c("subject_id")

#2 Merge x_trains
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")

x_total <- mergeData(x_train,x_test)
#2.1 Add the columns
x_colnames <- read.table("UCI HAR Dataset/features.txt")
colnames(x_total) <- x_colnames$V2

#2.2 Extract mean and standard deviation
x_total_colnames <- as.list(colnames(x_total))
x_total_subset_names_idx <- sapply(x_total_colnames,function(x) grepl("mean|std",x))
x_total_subset_names <- x_total_colnames[x_total_subset_names_idx]
x_total_subset <- x_total[,unlist(x_total_subset_names)]

#2.3 Merge with subjects columns
x_total_subset <- addColumn(subjects,x_total_subset)

#3 Add the activity column

#3.1 read the activities infos
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("id_activity", "name_activity")

#3.2 read and merge the activities label
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_total <- mergeData(y_train,y_test)
colnames(y_total) <- c("id_activity")
subset_with_activity <- addColumn(x_total_subset,y_total)

#3.3 Join activities Names to label ids
library(plyr)
subset_with_activity_name <- merge(activities,subset_with_activity,all=TRUE)

########### TIDY DATASET II ##########

data_col_name <- colnames(subset_with_activity_name)
ids <- data_col_name[1:3]
measures <- data_col_name[4:length(data_col_name)]

datasetMeans <- ddply(subset_with_activity_name, ids, function(x) return( c(avg=colMeans(x[measures]))))
write.table(datasetMeans, file="tidyData5.txt",row.names=FALSE )
