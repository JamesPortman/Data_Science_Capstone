# server.R
# Date: Oct 1, 2016
# Author: James Portman

library(shiny)
# source('predict.R')

shinyServer(function(input, output) {

#output$predictedWords <- renderText({ 
#  "test2"
#})
  
  df <- data.frame(Possibilities=c("A","B","C","D","E"))
  output$predictedWords <- renderTable(df)
  
})
# End server.R
