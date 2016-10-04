library(stringi)

findNextWord <- function(df_ngrams, currentPhrase){
  thePattern <- paste0('^', currentPhrase, ' ')
  
  predictedWord <- 'No prediction available'
  max <- nrow(df_ngrams)
  for(count in 1:max) {
    matches <- length(grep(thePattern, df_ngrams[count,1])) > 0
    if (matches){
      predictedWord <- df_ngrams$word[count]
      predictedWord <- unlist(strsplit( predictedWord, "\\s+"))
      predictedWord <- predictedWord[length(predictedWord)]
      break;
    }
  }
  
  return(predictedWord)
}

predictNextWord <- function(currentPhrase, df_bigrams, df_trigrams, df_fourgrams){
  currentPhrase <- tolower(currentPhrase)
  currentPhrase_splitted <- unlist(strsplit( stri_trim_both(currentPhrase), "\\s+"))
  currentPhrase_countOfWords <- length(currentPhrase_splitted)
  
  from <- max(currentPhrase_countOfWords-1, 0)
  until <- currentPhrase_countOfWords;
  
  lastWords_vector <- currentPhrase_splitted[from:until]
 
  lastWords <- paste(lastWords_vector, collapse = ' ')
  
  finalPrediction <- 'No prediction available'
  
  # Try to look best prediction after 3-words
  if (length(lastWords_vector) == 3){
    predictedWord <- findNextWord(df_fourgrams, lastWords)
#    print(paste0("predictedWord=", predictedWord))
    predictionFound <- (predictedWord != 'No prediction available')
    if (predictionFound){
      finalPrediction <- predictedWord
    }else{
      lastWords_vector <- currentPhrase_splitted[3]
      lastWords <- lastWords_vector
    }
  }
  
  # Try to look best prediction after 2-words
  if (length(lastWords_vector) == 2){
    predictedWord <- findNextWord(df_trigrams, lastWords)
    predictionFound <- (predictedWord != 'No prediction available')
    if (predictionFound){
      finalPrediction <- predictedWord
    }else{
      lastWords_vector <- currentPhrase_splitted[2]
      lastWords <- lastWords_vector
    }
  }
  
  # Try to look best prediction after one-word
  if (length(lastWords_vector) == 1){
    lastWords <- lastWords_vector[length(lastWords_vector)]
    predictedWord <- findNextWord(df_bigrams, lastWords)
    predictionFound <- (predictedWord != 'No prediction available')
    if (predictionFound){
      finalPrediction <- predictedWord
    }
  }
  
  return(finalPrediction)
}

#load("ngrams.RData", envir = parent.frame(), verbose = FALSE)
#predictNextWord("I want to her I", df_bigrams, df_trigrams, df_fourgrams)
# END PredictShiny.R
