# ui.R
# Date: Oct 1, 2016
# Author: James Portman

library(shiny)

shinyUI(
  navbarPage("Word Predictor App",
             
             # Panel 1 Provide background documentation.
             tabPanel("Documentation1",
                      h4("Background"),
                      "The data is from the 1974 Motor Trend magazine article that lists 10 car specifications for 32 different types of cars. The manual cars in the set of data tend to have better MPG ratings but this can be explained by other specifications such as horsepower and weight.",
                      hr(),
                      h4("Original Project"),
                      helpText(  a("View PDF paper on GitHub", href="https://github.com/JamesPortman/DevelopingDataProducts/blob/master/DoesTransmissionTypeAffectMPG.pdf"))
             )
               
  )
)
# End ui.R
