library("shiny")
library(ggplot2)
library(dplyr)
library('maps')
source("main.R")

ui <- fluidPage(
  
  ##A titlePanel layout  
  titlePanel("Binge Drinking v Mortality"),
  
  ##lays out the page in two columns
  sidebarLayout(
    
    sidebarPanel( ##control panel that contains interaction widgets
      
      h3("By Gender"),
      radioButtons('Sex', h3(label = "By Sex"), 
                   c("male" = "male", 
                     "female" = "female",
                     "both" = "both"), selected = "both"),
      
      h3("Category of Mortality"),
      selectInput('category', h3(label = "choose mortality"),
                  choices= mort.Alabama$Category, selected = "Neonatal Disorders")),
    
    
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Description of Data",h2("Description"), verbatimTextOutput('info')),          
                  tabPanel("Binge",h2("Change of Binge Drinking over US") ,plotOutput('bingePlot', hover = "binge_hover")), ##range of change for binge drinking of specific for entire US
                  tabPanel("Category", h2("change in Mortality for Specific Mortality Cause"), plotOutput('deathPlot', hover = "death_hover")), ##rate of change of specfic disease mortality for entire country
                  tabPanel("Map",verbatimTextOutput("info"))
      )
    )
  )
) 
  
server <- function(input, output) {
  filter.binge.mean <- reactive({
    return(input$sex)
  })
  
  output$info <- renderText({
    paste("ahasdofiasodifj")
  })
}

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)