library(stringi)

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
  
  from <- max(existingText_countOfWords-1, 0)
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


#load("ngrams.RData", envir = parent.frame(), verbose = FALSE)
#predictNextWord("I want to her I", df_bigrams, df_trigrams, df_fourgrams)
