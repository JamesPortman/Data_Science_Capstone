# libraries required
library(stringi)
library(ggplot2)
library(gridExtra)
library(tm)
library(quanteda)
library(R.utils)
library(dplyr)
library(qdap)
library(RWeka)
library(beepr)

setwd("/Users/admin/Capstone/")
# Windows: setwd("C:/Users/jportman/Documents/Capstone")

set.seed(1969)
options(mc.cores=1) # Sets the default number of threads to use

# download.file(url = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", 
#               destfile = "Coursera-SwiftKey.zip", method = "curl")
#  unzip('Coursera-SwiftKey.zip') 

# Read in Blog file
blogs <- readLines(con <- file("./en_US.blogs.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

# Read in News file
news <- readLines(con <- file("./en_US.news.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

# Read in Twitter file
tweets <- readLines(con <- file("./en_US.twitter.txt"), encoding = "UTF-8", skipNul = TRUE)
close(con) # Close the connection to the file.

sampleSize <- 15000
blogsSamples <- sample(blogs, sampleSize)
newsSamples  <- sample(news, sampleSize)
tweetsSamples  <- sample(tweets, sampleSize)
beep(sound = 1, expr = NULL)

#_____ BELOW need to CLEANSE____
# Concatenate all samples into one learning source
learningLines <- c(blogsSamples, newsSamples, tweetsSamples)

# Clean data
learningLines <- stripWhitespace(learningLines)
learningLines <- removePunctuation(learningLines)
learningLines <- removeNumbers(learningLines)
learningLines <- tolower(learningLines)

# Create 1-column data.frame
df <- data.frame(learningLines, stringsAsFactors = F)

# Create words / pairs-of-words / triplets of words  -> then remove duplicates
onegrams <- unlist(strsplit(learningLines, "\\s+"))
beep(sound = 1, expr = NULL)

bigrams  <- NGramTokenizer(df, Weka_control(min = 2, max = 2))
beep(sound = 1, expr = NULL)
trigrams <- NGramTokenizer(df, Weka_control(min = 3, max = 3))
beep(sound = 1, expr = NULL)
fourgrams <- NGramTokenizer(df, Weka_control(min = 4, max = 4))
beep(sound = 1, expr = NULL)

# Frequency of words
df_onegrams <- data.frame(table(onegrams))
df_bigrams <- data.frame(table(bigrams))
df_trigrams <- data.frame(table(trigrams))
df_fourgrams <- data.frame(table(fourgrams))
beep(sound = 1, expr = NULL)

# Normalize column names
colnames(df_onegrams) <- c("word", "frequency")
colnames(df_bigrams) <- c("word", "frequency")
colnames(df_trigrams) <- c("word", "frequency")
colnames(df_fourgrams) <- c("word", "frequency")

# Filter out low frequencies n-grams
df_onegrams <- filter(df_onegrams, frequency >= 2)
df_bigrams <- filter(df_bigrams, frequency >= 2)
df_trigrams <- filter(df_trigrams, frequency >= 2)
df_fourgrams <- filter(df_fourgrams, frequency >= 2)

# Convert words - factors -> characters
df_onegrams$word <- as.character(df_onegrams$word)
df_bigrams$word <- as.character(df_bigrams$word)
df_trigrams$word <- as.character(df_trigrams$word)
df_fourgrams$word <- as.character(df_fourgrams$word)

# Sort by frequency
df_onegrams <- df_onegrams[order(df_onegrams$frequency, decreasing = T), ] 
df_bigrams <- df_bigrams[order(df_bigrams$frequency, decreasing = T), ]
df_trigrams <- df_trigrams[order(df_trigrams$frequency, decreasing = T), ]
df_fourgrams <- df_fourgrams[order(df_fourgrams$frequency, decreasing = T), ]

# Store bigrams & trigrams to disk
save(df_onegrams, df_bigrams, df_trigrams, df_fourgrams, file = "ngrams.RData")
