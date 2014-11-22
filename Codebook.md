---
title: "Wearable computing tidy data 5"
author: "Cedric FOTSO DEFFO"
date: "22 Nov 2014"
output: html_document
---

This file contains the description of how were processed the raw data described here <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.
From that processing, new variables will be generated, and this codebook will described each of them.

###Study design

The goal of this project, is to merge two sets of data (**training set** and **test set**), extract the mean and standard deviation columns, and compute their average for each subject and activity.
For this scope, two strategies can be used:

+ Clean the training set, then the test set and merge the results
+ Merge common parts in the training and the test set, binding new columns to the main data frame.

I used the second strategy, as it enabled me to work with similar data set together.
The processing has been made in the following steps:

1. I first merged the subjects train and test sets (subject_train and subject_test).
2. I merged then the train and test datasets (x_train and x_set).
3. I added the columns name (thanks to the file features.txt), and I used it to extract the standard deviation and the mean.
4. After that I binded the obtained dataframe with the one containing subjects.
5. I merged the activities label together (y_train.txt and y_test.txt), and I binded the column to the main data frame.
6. I joined the main data frame with the frame containing the activities name (in order to have the activities name present in the final data frame).

At this stage, we have the first tidy data set, which will be used to compute the second one.
For the second data set, in order to compute the average of all variable for each activities and subject, I used the following command:

```
datasetMeans <- ddply(subset_with_activity_name, ids, function(x) return( c(colMeans(x[measures])))) 
```

***ids*** is a vector containing the column names subjects_id, id_activity and name_activity.

***measures*** is a vector containig all the other variables, that will be used to compute the average.



###Cookbook

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

1. tBodyAcc-XYZ
2. tGravityAcc-XYZ
3. tBodyAccJerk-XYZ
4. tBodyGyro-XYZ
5. tBodyGyroJerk-XYZ
6. tBodyAccMag
7. tGravityAccMag
8. tBodyAccJerkMag
9. tBodyGyroMag
10. tBodyGyroJerkMag
11. fBodyAcc-XYZ
12. fBodyAccJerk-XYZ
13. fBodyGyro-XYZ
14. fBodyAccMag
15. fBodyAccJerkMag
16. fBodyGyroMag
17. fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

1. mean(): Average mean value
1. std(): Average standard deviation
2. meanFreq(): Average weighted average of the frequency components to obtain a mean frequency

Our tidy data set contains for each ***subject*** and ***activity*** the ***average*** of each of the previous given variables.

The resulting columns will have the value ***avg.*** prepended to the columns names, to show the fact that they represent averages (Ex. ***avg.tBodyAcc-mean()-Z***, ***avg.tBodyAcc-std()-X***)
