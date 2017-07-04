## Written By Ishai Green
	
## Download the dataset and unzip folder
	
	## Create working folder for the project
	if(!file.exists("./getting-and-cleaning-data-project")){
	  dir.create("./getting-and-cleaning-data-project")
	  }
	Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

	## Download data zip
	if(!file.exists("./getting-and-cleaning-data-project/project_Dataset.zip")){
	  download.file(Url,destfile="./getting-and-cleaning-data-project/project_Dataset.zip",mode = "wb")
	  }

	## Unzip datasets
	if(!file.exists("./getting-and-cleaning-data-project/UCI HAR Dataset")){
	  unzip(zipfile="./getting-and-cleaning-data-project/project_Dataset.zip",exdir="./getting-and-cleaning-data-project")
	}
	
		
	## Load activity, subject and feature info.

	## 1. Read the Activity files
	path <- file.path("./getting-and-cleaning-data-project" , "UCI HAR Dataset")
	TestActivity  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
	TrainActivity <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

	## 2. Read the Subject files
	TrainSubject <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
	TestSubject  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

	## 3. Read Fearures files
	TestFeatures  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
	TrainFeatures <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
	

	## Merges the training and the test sets to create one data set.
	## rbind the data tables by rows
	SubjectData <- rbind(TrainSubject, TestSubject)
	ActivityData<- rbind(TrainActivity, TestActivity)
	FeaturesData<- rbind(TrainFeatures, TestFeatures)
	

	## 2. Set names to variables
	names(SubjectData)<-c("subject")
	names(ActivityData)<- c("activity")
	FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
	names(FeaturesData)<- FeaturesNames$V2
	

	## 3. Merge columns to get the data frame Data for all data
	MergeData <- cbind(SubjectData, ActivityData)
	FullData <- cbind(FeaturesData, MergeData)
	

	## Extracts only the mean and standard deviation measurements. 
	## 1. Subset Name of Features by measurements on the mean and standard deviation
	subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

	## 2. Subset the data frame Data by seleted names of Features
	SelectedNames<- c(as.character(subFeaturesNames), "subject", "activity" )
	Data<-subset(FullData,select=SelectedNames)


	## Uses descriptive activity names to name the activities in the data set
	## 1. Read descriptive activity names from "activity_labels.txt"
	ActivityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
	## 2. Factorize Variale activity in the data frame Data using descriptive activity names
	Data$activity<-factor(Data$activity,labels=ActivityLabels[,2])
	## Test Print
	head(Data$activity,30)
	

	## Appropriately labels the data set with descriptive variable names
	names(Data)<-gsub("^t", "time", names(Data))
	names(Data)<-gsub("^f", "frequency", names(Data))
	names(Data)<-gsub("Acc", "Accelerometer", names(Data))
	names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
	names(Data)<-gsub("Mag", "Magnitude", names(Data))
	names(Data)<-gsub("BodyBody", "Body", names(Data))
	## Test Print
	names(Data)
	

	## Step 7: Creates a independent tidy data set
	
	TidyData<-aggregate(. ~subject + activity, Data, mean)
	TidyData<-TidyData[order(TidyData$subject,TidyData$activity),]
	write.table(TidyData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')


