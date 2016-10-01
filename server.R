# server.R
# Date: Oct 1, 2016
# Author: James Portman

library(shiny)
library(datasets)

mtcars$am <- as.factor(mtcars$am)
levels(mtcars$am) <- c("Automatic", "Manual")

shinyServer(function(input, output) {
  
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  formulaTextPoint <- reactive({
    paste("mpg ~", "as.integer(", input$variable, ")")
  })
  
  fit <- reactive({
    lm(as.formula(formulaTextPoint()), data = mtcars)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  # Call-back for Box Plots
  output$mpgBoxPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mtcars,
            xlab="Miles per Gallon",
            horizontal = TRUE)
  })
  
  # Call-back for Histograms
  output$mpgHistPlot <- renderPlot({
    
    x <- mtcars$mpg
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    h<-hist(x, breaks=bins, col="red", xlab="Miles per gallon", ylab="Frequency of Cars", main="Car grouped by mpg") 
    
    # Add a Normal Curve. (Thanks to Peter Dalgaard for following code.)
    xfit<-seq(min(x),max(x),length=40) 
    yfit<-dnorm(xfit,mean=mean(x),sd=sd(x)) 
    yfit <- yfit*diff(h$mids[1:2])*length(x) 
    lines(xfit, yfit, col="blue", lwd=2)
  })
  
  # Call-back for summary at bottom
  output$fit <- renderPrint({
    summary(fit())
  })
  
  # Call-back for plot and red regression line
  output$mpgPlot <- renderPlot({
    par(bg = "palegoldenrod")
    with(mtcars, {
      plot(as.formula(formulaTextPoint()))
      abline(fit(), col="red")
    })
  })
  
})
# End server.R
