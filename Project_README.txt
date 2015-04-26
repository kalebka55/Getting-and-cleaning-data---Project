README for GACD_Project

System information:
Windows 7
RStudio (v0.98.1091)

R Package prerequisites:
dplyr
plyr
reshape2


Instruction list/ filename:
run_analysis.R

Raw data found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Further details of experimental study design found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


Code book (Variables in tidy data set):

Subject - Human candidate with a designated numeric identifier (1-30)
Activity - Activity the candidate conducted (Laying, Standing, Walking, Walking upstairs, Walking Downstairs, Sitting) during monitoring
Data_Type - Test data or Training data
movement_axis - axis plane of movement (X, Y, Z)

The below are the summarised sensor features - summarized by mean and standard deviation of the respective sensor signals

mean tbodyacc  - mean time signal from the body accelerometer
mean tgravity acc  - mean time signal from the gravity accelerometer
mean tbody acc jerk - mean time signal from the body jerk accelerometer
mean tbodygyro  - mean time signal from the body gyroscope
mean tbodygyrojerk  - mean time signal from the body jerk gyroscope
mean freq fbody acc  - mean frequency (fourier transformed) signal from body accelerometer
mean fbody acc  - mean fourier transformed signal from body accelerometer
mean fbody acc jerk  - mean fourier transformed signal from the body jerk accelerometer
mean fbody acc  - mean fourier transformed signal from body accelerometer
mean fbody gyro  - mean fourier transformed from body gyroscope
mean freq fbodygyro  - mean frequency (fourier transformed) signal from body gyroscope
stdev tbody acc  - standard deviation of time signal form body accelerometer
stdev tgrav acc  - standard deviation of time signal from gravimetric accelerometer
stdev tbody acc jerk  - standard deviation of time signal from body jerk accelerometer 
stdev tbody gyro - standards deviation of time signal from body gyroscope
stdev tbodygyro jerk  - standard deviation of time signal from body jerk gyroscope
stdev fbody acc  - standard deviation of fourier transformed signal from body accelerometer
stdev fbody acc jerk  - standard deviation of fourier transformed signal from body jerk accelerometer
stdev fbody gyro - standards deviation of fourier transformed signal from body gyroscope


