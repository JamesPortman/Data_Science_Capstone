
directory <- "/Users/admin/Capstone/"
sampleSize <- 1000 # For sampling a file

entireBlogsText <- readLines(paste(directory, "en_US.blogs.txt", sep=""), skipNul = TRUE)
sampleBlogs <- sample(entireBlogsText, sampleSize)
remove(entireBlogsText) # Reclaim memory.

entireNewsText <- readLines(paste(directory,"en_US.news.txt", sep=""), skipNul = TRUE)
sampleNews <- sample(entireNewsText,sampleSize)
remove(entireNewsText) # Reclaim memory.

entireTwitterText <- readLines(paste(directory,"en_US.twitter.txt",sep=""), skipNul = TRUE)
sampleTwitter <- sample(entireTwitterText,sampleSize)
remove(entireTwitterText) # Reclaim memory.

# Combine samples
sample <- c(sampleBlogs,sampleNews,sampleTwitter)
remove(sampleBlogs,sampleNews,sampleTwitter) # Reclaim memory.

#txt <- sent_detect(sample)
