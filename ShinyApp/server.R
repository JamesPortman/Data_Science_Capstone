# server.R
# Date: Oct 3, 2016
# Author: James Portman

# Run-once section
library(shiny)
get(load("ngrams.RData"))
source('PredictShiny.R', local = TRUE)
# END Run-once section

shinyServer(function(input, output) {
  
  # df <- data.frame(Next_Word=c("be","do","go","see"), Ranked_Score = c("11","10","7","5"))
  # df <- data.frame(Next_Word=c("be"), Ranked_Score = c("11"))
  # output$predictedWords <- renderTable(df)
  
  output$predictedWords <- renderText({
        predictNextWord(input$text, df_bigrams, df_trigrams, df_fourgrams)
  })
  
})
# End server.R
