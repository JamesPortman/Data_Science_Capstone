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

sampleSize <- 25000
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
learningLines <- iconv(learningLines, "latin1", "ASCII", sub="") # remove non-ASCII characters
learningLines <- tolower(learningLines)

# Create 1-column data.frame
df <- data.frame(learningLines, stringsAsFactors = F)

bigrams  <- NGramTokenizer(df, Weka_control(min = 2, max = 2))
beep(sound = 1, expr = NULL)
trigrams <- NGramTokenizer(df, Weka_control(min = 3, max = 3))
beep(sound = 1, expr = NULL)
fourgrams <- NGramTokenizer(df, Weka_control(min = 4, max = 4))
beep(sound = 1, expr = NULL)

# Frequency of words
df_bigrams <- data.frame(table(bigrams))
df_trigrams <- data.frame(table(trigrams))
df_fourgrams <- data.frame(table(fourgrams))
beep(sound = 1, expr = NULL)

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
beep(sound = 1, expr = NULL)
