#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny); require(caret);require(plotly);
require(e1071);require(MASS)


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  

  datos1<- reactive({  
  sample <- createDataPartition(iris$Species, p=(input$perc/100), list=FALSE)
  
  })

  iristr<- reactive({  
    sample <- datos1()
    
    # Create training data
    iris_train <- iris[sample,]
    return(iris_train)
  })
    
  iriste<- reactive({  
    sample <- datos1()
    
    # Create training data
    iris_test <- iris[-sample,]
    return(iris_test)
  })
  
  
  output$plot1 <- renderPlotly({
    
    iris_train<-iristr()
    
    if(input$plots == 1){
      p1 <- plot_ly(iris_train, y = ~Sepal.Length, type = "box", name="Sepal Length") 
      p2 <- plot_ly(iris_train, y=~Sepal.Width , type = "box" , name="Sepal Width")
      p3 <- plot_ly(iris_train, y=~Petal.Length , type = "box" , name="Petal Length")
      p4 <- plot_ly(iris_train, y=~Petal.Width , type = "box" , name="Petal Width")
      
      subplot(p1, p2,p3,p4,shareX = F)
    } else if(input$plots==2){
      
      iris_train$count <- 1
      dat <- aggregate(count ~ Species, iris_train,sum)
      
      plot_ly(dat, x = ~Species,y = ~count, type = "bar") 
      
    }
  })
  
  
  output$plot2 <- renderPlot({
    
    iris_train <- iristr()
    
    if(input$plots2==1){
      
      x <- iris_train[,1:4]
      y<- iris_train[,5]
      
      require(caret)
      featurePlot(x=x, y=y, plot='ellipse', auto.key=list(columns=3))
      
    } else if(input$plots2==2){
      
      x <- iris_train[,1:4]
      y<- iris_train[,5]
      
      featurePlot(x=x, y=y, plot='box', auto.key=list(columns=3))
      
    } else if(input$plots2==3){
      
      x <- iris_train[,1:4]
      y<- iris_train[,5]
      
      featurePlot(x=x, y=y, 
                  plot='density', 
                  scales = list(x = list(relation='free'),
                                y = list(relation='free')),
                  auto.key=list(columns=3))
      
    }
  })
  
  
  mod1 <- eventReactive(input$do,{
    
    iris_train <- iristr()
    
    control <- trainControl(method='cv', number=10)
    metric <- 'Accuracy'
    
    model <- list()
    
    # Linear Discriminant Analysis (LDA)
    set.seed(200)
    model[["lda"]] <- train(Species~., data=iris_train, method='lda', 
                     trControl=control, metric=metric)
    
    # Classification and Regression Trees (CART)
    set.seed(200)
    model[["cart"]] <- train(Species~., data=iris_train, method='rpart', 
                      trControl=control, metric=metric)
    
    # k-Nearest Neighbors (KNN)
    set.seed(200)
    model[["knn"]] <- train(Species~., data=iris_train, method='knn', 
                     trControl=control, metric=metric)
    
    # Support Vector Machines (SVM) with a radial kernel
    set.seed(200)
    model[["svm"]] <- train(Species~., data=iris_train, method='svmRadial', 
                     trControl=control, metric=metric)
    
    # Random Forest (RF)
    set.seed(200)
    model[["RF"]] <- train(Species~., data=iris_train, method='ranger', 
                    trControl=control, metric=metric)
    
    #list1 <- list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf)
    
    iris.results <- resamples(model[input$checkmet])
    
    
    return(iris.results)
    
  })


  
  output$summary <- renderPrint({
    results <- mod1()
    summary(results)
  })
  
  output$plot3 <- renderPlot({
    results <- mod1()
    bwplot(results)
  })
  
  output$plot4 <- renderPlot({
    results <- mod1()
    dotplot(results)
  })
}
)

