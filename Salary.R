library(shiny)
#https://cse-ab.shinyapps.io/Salary/
#Train model
#Mul_Reg_Result <- lm(Salary~., data = Mul_Reg_data)
#saveRDS(Mul_Reg_Result, "Mul_Reg_Result.rds")

# Define UI for application
ui <- fluidPage(
  titlePanel("Salary Prediction App"),
  sidebarLayout(
    sidebarPanel(
      numericInput("experience", "Experience:", value = ""),
      numericInput("score", "Score:", value = ""),
      selectInput("gender", "Gender:", choices = c("", "M", "F")),
      selectInput("department", "Department:", choices = c("", "Aministrative", "Engineering","Finance", "Human Resource", "Procurement")),
      actionButton("predict", "Predict Salary"),
      br(),
      h5("Note: Please input numerical values only.")
    ),
    mainPanel(
      h3("Salary projection App (Prototype)"),
      h4("This App is for projecting salary based on work experience and a score from a job interview, gender, and department"),
      h3(tags$b("How to predict salary:")),
      h4("Please input the number of years of job experience, a score between 0 and 100, gender, and the department for the job."),
      h4("To reveal the projected salary, please click the Predict Salary button."), 
      h4("Predicted Salary:"),
      verbatimTextOutput("prediction")
    )
  )
)

# Define server logic required
server <- function(input, output) {
  # Load the saved model
  Model <- readRDS("Mul_Reg_Result.rds")
  
  observeEvent(input$predict, {
    experience <- input$experience
    score <- input$score
    gender <- as.factor(input$gender)
    department <- as.factor(input$department)
    newdata <- data.frame(Experience = experience, Score = score, Gender = gender, Department = department)
    predicted_salary <- predict(Model, newdata)
    predicted_salary <- round( predicted_salary, digits = 2)
    output$prediction <- renderPrint({
      paste("Based on the given experience, and score, the projected salary is:", predicted_salary)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)

