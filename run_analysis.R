if (!require("reshape2")) {install.packages("reshape2")}
library("reshape2")

# load datasets
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

names(X_train) <- features
names(X_test) <- features

# merge datasets
data <- rbind(X_train, X_test)
activity <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# extract mean & std
extract_features <- grepl("mean|std", features)
data <- data[,extract_features]

# name activities
names(activity) <- "activity"
names(subject) <- "subject"

# label datasets
data <- cbind(subject,activity,data)
data <- melt(data,(id.vars=c("subject","activity")))
data2 <- dcast(data, subject + activity ~ variable, mean)

# create tidy dataset
write.table(data2, file="./tidydata.txt")