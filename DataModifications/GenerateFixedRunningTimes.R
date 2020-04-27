library(stringr)
rTimes <- read.delim("running-times.list",header = FALSE, sep = "\n",stringsAsFactors = FALSE,quote = "")
rTimes <- rTimes[-1:-8,]
rTimes <- rTimes[-length(rTimes)]
rTimes <- rTimes[-1:-575972]

rawlen <- trimws(sub(".*?\t","",rTimes)) #length with other formatting data
name <- trimws(str_extract(rTimes,".*?\t"))
rTimes <- cbind.data.frame(name,rawlen,stringsAsFactors = FALSE)
rTimes$duration <- as.numeric(str_extract(rTimes$rawlen,"\\d+\\d*\\d*\\d*")) #matches 1-4 numbers
rTimes <- rTimes[rTimes$duration > 59,]
write.csv(rTimes,file = "FixedRunningTimes.txt")



