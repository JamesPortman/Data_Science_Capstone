# libraries required
library(stringi)
library(tm)
library(R.utils)
library(RWeka)
library(beepr)

# Mac: setwd("/Users/admin/Capstone/")
setwd("C:/Users/jportman/Documents/Data_Science_Capstone")

set.seed(1969)
options(mc.cores=1) # Sets the default number of threads to use

# download.file(url = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", 
#               destfile = "Coursera-SwiftKey.zip", method = "curl")
#  unzip('Coursera-SwiftKey.zip') 

# Read in Blog file
blogs <- readLines(con <- file("./en_US.blogs.txt"), encoding = "UTF-8", skipNul = TRUE, warn = FALSE)
close(con) # Close the connection to the file.

# Read in News file
news <- readLines(con <- file("./en_US.news.txt"), encoding = "UTF-8", skipNul = TRUE, warn = FALSE)
close(con) # Close the connection to the file.

# Read in Twitter file
tweets <- readLines(con <- file("./en_US.twitter.txt"), encoding = "UTF-8", skipNul = TRUE, warn = FALSE)
close(con) # Close the connection to the file.

sampleSize <- 15000
blogsSamples <- sample(blogs, sampleSize)
newsSamples  <- sample(news, sampleSize)
tweetsSamples  <- sample(tweets, sampleSize)

# Concatenate all samples into one learning source
combinedLines <- c(blogsSamples, newsSamples, tweetsSamples)

# Clean data
combinedLines <- stripWhitespace(combinedLines)
combinedLines <- removePunctuation(combinedLines)
combinedLines <- removeNumbers(combinedLines)
combinedLines <- iconv(combinedLines, "latin1", "ASCII", sub="") # remove non-ASCII characters
combinedLines <- tolower(combinedLines)

# Create 1-column data.frame
df <- data.frame(combinedLines, stringsAsFactors = F)

# Reclaim memory for unneeded objects.
remove(blogs,news,tweets, blogsSamples, newsSamples, tweetsSamples,combinedLines)

bigrams  <- NGramTokenizer(df, Weka_control(min = 2, max = 2))
trigrams <- NGramTokenizer(df, Weka_control(min = 3, max = 3))
fourgrams <- NGramTokenizer(df, Weka_control(min = 4, max = 4))

# Frequency of words
df_bigrams <- data.frame(table(bigrams))
df_trigrams <- data.frame(table(trigrams))
df_fourgrams <- data.frame(table(fourgrams))

# Normalize column names
colnames(df_bigrams) <- c("word", "frequency")
colnames(df_trigrams) <- c("word", "frequency")
colnames(df_fourgrams) <- c("word", "frequency")

# Filter out low frequencies n-grams
df_bigrams <- filter(df_bigrams, frequency >= 2)
df_trigrams <- filter(df_trigrams, frequency >= 2)
df_fourgrams <- filter(df_fourgrams, frequency >= 2)

# Convert words - factors -> characters
df_bigrams$word <- as.character(df_bigrams$word)
df_trigrams$word <- as.character(df_trigrams$word)
df_fourgrams$word <- as.character(df_fourgrams$word)

# Sort by frequency
df_bigrams <- df_bigrams[order(df_bigrams$frequency, decreasing = T), ]
df_trigrams <- df_trigrams[order(df_trigrams$frequency, decreasing = T), ]
df_fourgrams <- df_fourgrams[order(df_fourgrams$frequency, decreasing = T), ]

# Store to disk
save(df_bigrams, df_trigrams, df_fourgrams, file = "ngrams.RData")

#load("ngrams.RData", envir = parent.frame(), verbose = TRUE, local = TRUE)

# END CreateNgrams.R