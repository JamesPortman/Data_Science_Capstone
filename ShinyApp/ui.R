# ui.R
# Date: Oct 5, 2016
# Author: James Portman

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
titlePanel("", windowTitle="iClairvoyance"),

img(src = "headerImage.PNG"),
hr(),

  sidebarLayout(
    
    sidebarPanel(
     
      textInput("text", label = h4("Input"), value = ""),
      helpText("Type a sentence above and press the 'Predict Next Word' button below. The suggested word will display to the right."),
      submitButton("Predict Next Word")
    ),
    
    mainPanel(

      h4("Predicted word:", align="left"),
      div(tableOutput("predictedWords"), align="left")
    )
  )
))
# END ui.R