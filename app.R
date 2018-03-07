library("shiny")
source("main.R")

ui <- fluidPage(
  
  ##A titlePanel layout  
  titlePanel("Binge Drinking v Mortality"),
  
  ##lays out the page in two columns
  sidebarLayout(
    
    sidebarPanel( ##control panel that contains interaction widgets
      
      h3("By Gender"),
      radioButtons('sex', h3(label = "By Sex"), 
                   choices = c("male" , 
                               "female","both"), selected = "both"),
      
      h3("Category of Mortality"),
      selectInput('category', h3(label = "choose mortality"),
                  choices= mort.Alabama$Category, selected = "Neonatal Disorders")),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Description of Data",h2("Description"), textOutput('text')),          
                  tabPanel("Binge",h2("Change of Binge Drinking over US") ,plotOutput('bingePlot', hover = "binge_hover")), ##range of change for binge drinking of specific for entire US
                  tabPanel("Category", h2("change in Mortality for Specific Mortality Cause"), plotOutput('deathPlot', hover = "death_hover")), ##rate of change of specfic disease mortality for entire country
                  tabPanel("Map",h2("Binge Drinking and Mortality across the US"),verbatimTextOutput("info"))
      ))) 