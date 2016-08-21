# Load the libraries
library(stringi)

setwd("/Users/admin/Capstone/")
sampleSize <- 2000 # For sampling a file

# Read in Blog file
entireBlogsText <- readLines(con <- file("./en_US.blogs.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.
sampleBlogs <- sample(entireBlogsText, sampleSize)
remove(entireBlogsText) # Reclaim memory.

# Read in News file
entireNewsText <- readLines(con <- file("./en_US.news.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.
sampleNews <- sample(entireNewsText,sampleSize)
remove(entireNewsText) # Reclaim memory.

# Read in Twitter file
entireTwitterText <- readLines(con <- file("./en_US.twitter.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.
sampleTwitter <- sample(entireTwitterText,sampleSize)
remove(entireTwitterText) # Reclaim memory.

# Combine samples
sample <- c(sampleBlogs,sampleNews,sampleTwitter)
remove(sampleBlogs,sampleNews,sampleTwitter) # Reclaim memory.

