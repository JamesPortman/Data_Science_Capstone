# server.R
# Date: Oct 4, 2016
# Author: James Portman

# Run-once section
library(shiny)
get(load("ngrams.RData"))
source('PredictShiny.R', local = TRUE)
# END Run-once section

shinyServer(function(input, output) {
  
  output$predictedWords <- renderText({
        predictNextWord(input$text, df_bigrams, df_trigrams, df_fourgrams)
  })
  
})
# End server.R

#predictNextWord("I want to", df_bigrams, df_trigrams, df_fourgrams)
