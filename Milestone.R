# Milestone.R

library(ggplot2)
library(stringi)
library(R.utils)

setwd("/Users/admin/Capstone/")
set.seed(1969)

# download.file(url = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", 
# destfile = "Coursera-SwiftKey.zip", method = "curl")
# unzip('Coursera-SwiftKey.zip') 

# Read in Blog file
blogs <- readLines(con <- file("./en_US.blogs.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

# Read in News file
news <- readLines(con <- file("./en_US.news.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

# Read in Twitter file
tweets <- readLines(con <- file("./en_US.twitter.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

# Summary statistics about the data sets.
# Lines Summary
number_of_lines <- c(length(blogs), length(news), length(tweets))
number_of_lines <- data.frame(number_of_lines)
number_of_lines$names <- c("Blogs","News","Twitter")

# Lines data table
number_of_lines

# Lines Plot
ggplot(number_of_lines,aes(x=names,y=number_of_lines)) + geom_bar(stat='identity', fill="green", color='green') + xlab('Source') + ylab('# of Lines') + ggtitle('Lines per Source')

# Word Summary
blogs.words <- sum(sapply(gregexpr("\\W+", blogs), length) + 1)
news.words <- sum(sapply(gregexpr("\\W+", news), length) + 1)
tweets.words <- sum(sapply(gregexpr("\\W+", tweets), length) + 1)
number_of_words <- c(blogs.words, news.words, tweets.words)
number_of_words <- data.frame(number_of_words)
number_of_words$names <- c("Blogs","News","Twitter")

# Words data table
number_of_words

# Word Plot
ggplot(number_of_words,aes(x=names, y=number_of_words)) + geom_bar(stat='identity', fill="blue", color='blue') + xlab('Source') + ylab('# of words') + ggtitle('Words per Source')

# Sample data
sampleSize <- 2000 # For sampling a file
sampleBlogs <- sample(blogs, sampleSize)
sampleNews <- sample(news, sampleSize)
sampleTweets <- sample(tweets, sampleSize)

# Reclaim memory
remove(blogs) 
remove(news) 
remove(tweets) 

# Explore data
# Sample Blog data
sampleBlogs[100]

# Sample News data
sampleNews[100]

# Sample Tweet data
sampleTweets[1:3]




