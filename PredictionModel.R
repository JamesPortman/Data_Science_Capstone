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

###_____ Function _____
lookupNextWord <- function(df_ngrams, existingText){
  pattern <- paste0('^', existingText, ' ')
  
  predictedWord <- 'no-prediction-provided'
  max <- nrow(df_ngrams)
  for(i in 1:max) {
    matches <- length(grep(pattern, df_ngrams[i,1])) > 0
    if (matches){
      predictedWord <- df_ngrams$word[i]
      predictedWord <- unlist(strsplit( predictedWord, "\\s+"))
      predictedWord <- predictedWord[length(predictedWord)]
      break;
    }
  }
  
  return(predictedWord)
}

predictNextWord <- function(existingText, df_bigrams, df_trigrams, df_fourgrams){
  existingText <- tolower(existingText)
  existingText_splitted <- unlist(strsplit( stri_trim_both(existingText), "\\s+"))
  existingText_countOfWords <- length(existingText_splitted)
  
  #from <- max(existingText_countOfWords-1, 0)
  from <- 1
  until <- existingText_countOfWords;
  
  lastWords_vector <- existingText_splitted[from:until]
  
  lastWords <- paste(lastWords_vector, collapse = ' ')
  
  finalPrediction <- 'no-prediction-provided'
  
  # Try to look best prediction after 3-words
  if (length(lastWords_vector) == 3){
    predictedWord <- lookupNextWord(df_fourgrams, lastWords)
    #    print(paste0("predictedWord=", predictedWord))
    predictionWasFound <- (predictedWord != 'no-prediction-provided')
    if (predictionWasFound){
      finalPrediction <- predictedWord
    }else{
      lastWords_vector <- existingText_splitted[3]
      lastWords <- lastWords_vector
    }
  }
  
  # Try to look best prediction after 2-words
  if (length(lastWords_vector) == 2){
    predictedWord <- lookupNextWord(df_trigrams, lastWords)
    predictionWasFound <- (predictedWord != 'no-prediction-provided')
    if (predictionWasFound){
      finalPrediction <- predictedWord
    }else{
      lastWords_vector <- existingText_splitted[2]
      lastWords <- lastWords_vector
    }
  }
  
  # Try to look best prediction after one-word
  if (length(lastWords_vector) == 1){
    lastWords <- lastWords_vector[length(lastWords_vector)]
    predictedWord <- lookupNextWord(df_bigrams, lastWords)
    predictionWasFound <- (predictedWord != 'no-prediction-provided')
    if (predictionWasFound){
      finalPrediction <- predictedWord
    }
  }
  
  return(finalPrediction)
}

paste("Prediction: a case of", predictNextWord("a case of", df_bigrams, df_trigrams, df_fourgrams))

