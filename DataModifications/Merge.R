keyWords <- read.csv("FixedKeywords.txt",stringsAsFactors = FALSE)
Movies <- read.csv("FixedMovies.txt",stringsAsFactors = FALSE)
Certificates <- read.csv("FixedCertificates.txt",stringsAsFactors = FALSE)
Ratings <- read.csv("Fixedratings.txt",stringsAsFactors = FALSE)
Release <- read.csv("FixedRelease.txt",stringsAsFactors = FALSE)
RunningTimes <- read.csv("FixedRunningTimes.txt",stringsAsFactors = FALSE)
Genres <- read.csv("FixedGenres.txt",stringsAsFactors = FALSE)

keyWords <- keyWords[,2:3]
Ratings <- Ratings[,2:5]
RunningTimes <- RunningTimes[,2:4]
RunningTimes <- RunningTimes[grepl("USA",RunningTimes$rawlen),]
RunningTimes <- RunningTimes[,-2]
colnames(Genres) <- c("name","genre")
colnames(Certificates) <- c("name","certificate")
colnames(Movies) <- "name"
colnames(Release)[1] <- "name"
testL <-  merge(Movies,Certificates,all = FALSE)
testL <- merge(testL,Ratings,all = FALSE)
testL <- merge(testL,Release,all = FALSE)
testL <- merge(testL,RunningTimes,all = FALSE)
write.csv(testL,file = "MergedFiles.txt",quote = FALSE,row.names = FALSE)



