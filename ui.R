# ui.R
# Date: Oct 1, 2016
# Author: James Portman

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word Predictor App"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Input"), value = "Happy birthday to"),
      submitButton("Predict next word")
    ),
    
    mainPanel(
      div(tableOutput("predictedWords"), align="left")
    )
  )
  ))
