

library(shiny); require(caret);require(plotly)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Comparing Models",
                 theme = "bootstrap.css",
                 tabPanel("Parameters",
                          # Sidebar with a slider input for number of bins 
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput("plots", label = "Chose the univariate plot you want to see:", 
                                          choices = list("Univariate plots - Boxplot - Var" = 1, 
                                                         "Univariate plots - Barplot - Class" = 2 
                                          ), 
                                          selected = 1),
                              
                              selectInput("plots2", label = "Chose the multivariate plot you want to see:", 
                                          choices = list("Multivariate plots - Scatter" = 1,
                                                         "Multivariate plots - Boxplot" = 2,
                                                         "Multivariate plots - Density" = 3), 
                                          selected = 1),
                              
                              sliderInput("perc",
                                          "Percentage for the training set (%):",
                                          min = 1,
                                          max = 100,
                                          value = 80),
                              
                              
                              checkboxGroupInput("checkmet", label ="Metodologies that you want to compare", 
                                                 choices = list("Linear Discriminant Analysis" = "lda", 
                                                                "Classification and Regression Trees" = "cart",
                                                                "k-Nearest Neighbors" = "knn",
                                                                "Support Vector Machines" = "svm",
                                                                "Random Forest" = "RF"),
                                                 selected = c("lda","cart","knn","svm","RF")),
                                   actionButton("do", "Compute")      
                              
                              
                            ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                              tabsetPanel(
                                tabPanel("Analysis",
                              plotlyOutput("plot1"),
                              plotOutput("plot2")
                              ),
                              tabPanel("Results",

                              h3("Please Click Compute to see the results"),
                                       
                              verbatimTextOutput("summary"),
                
                              
                              plotOutput("plot3"),
                              plotOutput("plot4"),
                              hr(),
                              h3("This example was taken from Rpubs https://rpubs.com/mohitagr18/239997 by Mohit and converted to a Shiny App")
                              )
                              )
                            )
                          )
                 )
)
)

