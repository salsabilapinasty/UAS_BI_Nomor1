server <- function(input, output) {
  data <- data.frame(
    Month = c("January", "February", "March", "April","Mei", "June", "July", "August", 
              "September", "October", "November", "December"),
    x1 = c(150000,160000,170000,180000,190000,200000,210000,220000,230000,
           240000,250000,260000),
    x2 = c(8000,9500,10000,10500,11000,9000,11500,12000,12500,13000,14000,15000),
    x3 = c(5,4.5,4.8,4.6,5.1,4.7,4.9,5.0,5.2,5.3,5.4,5.5),
    x4 = c(8.5,8.2,8.4,8.5,8.6,8.7,8.8,8.9,8.7,8.8,8.9,9.0),
    x5 = c(20000,22000,25000,23000,30000,28000,27000,35000,40000,45000,50000,60000),
    y = c(120,150,160,165,180,170,190,210,230,250,300,350)
  )
  
  # Output Regresi
  fit <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = data)
  names(fit$coefficients) 
  summary_output <- summary(fit)
  residual_plot <- ad.test(fit$residuals)
  autokorelasi_plot <- dwtest(fit)
  hetero_plot <- bptest(fit, studentize = F, data= data)
  multicollinearity_output <- vif(fit)
  
  output$summary <- renderPrint({
    summary_output
  })
  
  output$residualPlot <- renderPrint({
    residual_plot
  })
  
  output$heteroPlot <- renderPrint({
    print(hetero_plot)
  })
  
  output$multicollinearity <- renderPrint({
    multicollinearity_output
  })
  
  output$autokorelasi <- renderPrint({
    autokorelasi_plot
  })
  
  # Output Data
  y_Monthly_Sales_Volume <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = data)
  data$Prediksi <- -138.2 + -0.0004914 * data$x1 + 0.01112 * data$x2 + -44.69 * data$x3 + 42.41 * data$x4 + 0.005185 * data$x5 
  data$Prediksi <- abs(data$Prediksi)
  data$Prediksi=round(data$Prediksi)
  output$tbl = DT::renderDataTable({
    DT::datatable(data, options = list(lengthChange = FALSE))
  })
  
  # Output Scatterplot
  output$scatterplot <- renderPlot({
    plot(data[,input$varindepen], data[,input$vardipen], main="Scatterplot",
         xlab=input$varindepen, ylab=input$vardipen, pch=19)
    abline(lm(data[,input$vardipen] ~ data[,input$varindepen]), col="red")
    lines(lowess(data[,input$varindepen],data[,input$vardipen]), col="blue")
  }, height=400)
  
  # Prediction 
  observeEvent(input$predict_button, {
    new_data <- data.frame(
      x1 = input$x1.input,
      x2 = input$x2.input,
      x3 = input$x3.input,
      x4 = input$x4.input,
      x5 = input$x5.input
    )
    
    # Predicted predicted_Monthly_Sales_Volume
    predicted_Monthly_Sales_Volume <- predict(y_Monthly_Sales_Volume, newdata = new_data)
    predicted_Monthly_Sales_Volume <- abs(predicted_Monthly_Sales_Volume)
    predicted_Monthly_Sales_Volume <- round(predicted_Monthly_Sales_Volume)
    
    output$Monthly_Sales_Volume <- renderPlot({
      plot(data$x1, data$y, col = "#3498DB", xlab = "number of website visitors per month", ylab = "Sales", main = "Scatterplot of Predicted Monthly Sales Volume")
      points(new_data$x1, predicted_Monthly_Sales_Volume, col = "red", pch = 16)
      legend("topright", legend = c("Actual Data", "Predicted Data"), col = c("#3498DB", "red"), pch = c(1, 16))
    })
    
    output$prediction_output <- renderPrint({
      cat("Prediction of Monthly Sales Volume: ", predicted_Monthly_Sales_Volume,"\n")
    })
  })
}

