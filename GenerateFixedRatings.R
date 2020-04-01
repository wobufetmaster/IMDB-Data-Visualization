ratings <- read.delim("ratings.list",header = FALSE, sep = "\n",stringsAsFactors = FALSE)
#copy <- ratings
ratings <- ratings[-1:-281,] #Get rid of the beginning stuff
ratings <- ratings[-770712:-770820] #Get rid of the end stuff
ratings <- ratings[-1:-363587] #everything that starts with " gets removed
#write.csv(ratings,file = "FixedRatings.txt",quote = FALSE,)
distribution <- substr(ratings,7,16)
name <- substr(ratings,33,99)
almost<- substr(ratings,17,32)
almost <- strsplit(almost," ")
almost <- unlist(almost)
almost <- almost[almost != ""]
amount <- almost[seq(1,814248,by = 2)]
score <- almost[seq(2,814248,by = 2)]
ratings <- cbind.data.frame(name,distribution,score,amount)
ratings <- ratings[-grep("(VG)",ratings$name),]
ratings <- ratings[-grep("(V)",ratings$name),]
ratings <- ratings[-grep("(TV)",ratings$name),]

write.csv(ratings,file = "Fixedratings.txt",quote = FALSE)
