# server.R
# Date: Oct 3, 2016
# Author: James Portman

library(shiny)
# source('predict.R')

shinyServer(function(input, output) {
  
  df <- data.frame(Next_Word=c("be","do","go","see"), Ranked_Score = c("11","10","7","5"))
  output$predictedWords <- renderTable(df)
  
})
# End server.R
