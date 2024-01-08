library(shiny)
library(plotly)
library(ggplot2)
library(gridExtra)
library(shinythemes)
library(lmtest)
library(car)
library(olsrr)
library(nortest)


# Define UI
ui <- fluidPage(
  theme = shinytheme("cyborg"),
  titlePanel("Regression Model"),
  sidebarLayout(
    sidebarPanel(
      selectInput("vardipen", label = h3("Dependen"),
                  choices = list("y" = "y"), selected = 1),
      
      selectInput("varindepen", label = h3("Independen"),
                  choices = list("x" = "x1","x2","x3","x4","x5"), selected = 1)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Scatterplot", plotOutput("scatterplot")), # Plot
                  tabPanel("Summary Model", verbatimTextOutput("summary")), # output Regresi
                  tabPanel("Residual Normality Test", verbatimTextOutput("residualPlot")),
                  tabPanel("Heteroscedasticity", verbatimTextOutput("heteroPlot")),
                  tabPanel("Multicollinearity", verbatimTextOutput("multicollinearity")),
                  tabPanel("Autocorrelation", verbatimTextOutput("autokorelasi")),
                  tabPanel("Data", DT::dataTableOutput('tbl')), # Data dalam tabel
                  tabPanel("Prediction",
                           fluidPage(
                             titlePanel(title = div("Monthly Sales Volume", style = "color: #333333; font-size: 40px; font-weight: bold; text-align: center; height: 120px")),
                             sidebarLayout(
                               sidebarPanel(
                                 numericInput("x1.input", "x1 Value:", value = 150000),
                                 numericInput("x2.input", "x2 Value:", value = 8000),
                                 numericInput("x3.input", "x3 Value:", value = 5),
                                 numericInput("x4.input", "x4 Value:", value = 8.5),
                                 numericInput("x5.input", "x5 Value:", value = 20000),
                                 actionButton("predict_button", "Generate Predict", class = "btn-primary")
                               ),
                               
                               mainPanel(
                                 plotOutput("Monthly_Sales_Volume"),
                                 verbatimTextOutput("prediction_output")
                               )
                             )
                           )
                  )
                  
      )
      
    )
  )
)