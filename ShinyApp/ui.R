# ui.R
# Date: Oct 3, 2016
# Author: James Portman

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word Predictor App"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h4("Input"), value = "I have to"),
      helpText("Type a sentence above and then press the 'Predict Next Word' button below. The results will display to the right."),
      submitButton("Predict Next Word")
    ),
    
    mainPanel(
      div(tableOutput("predictedWords"), align="left")
    )
  )
  ))
