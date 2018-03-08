library("shiny")
library(ggplot2)
library(dplyr)
library('maps')
source("main.R")
source('spatial_utils.R')

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
                     "both" = "both")),
      
      br(),
      
      h3("Category of Mortality"),
      selectInput('category', h3(label = "choose mortality"),
                  choices= mort.Alabama$Category, selected = "Neonatal Disorders"),
      
      width = 2),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Descript", h2("Description"), verbatimTextOutput('description')),
                  tabPanel("Map: Binge Drinking", h2("Binge Drinking Percent"),
                           column(8,verbatimTextOutput("bingeInfo"), br(), plotOutput("binge",click = "plot_click")),
                           column(4, dataTableOutput("bingeTable"))),
                  tabPanel("Map: Mortality Rate", h2('Mortality Rate'), 
                           column(8,verbatimTextOutput("mortInfo"), br(), plotOutput("mort",click = "plot_clicks")),
                           column(4, tabPanel("Table",dataTableOutput("mortTable")))),
                  tabPanel("Map: Mortality Rate vs Binge Drinking", h2('Binge Drinking vs Mortality Rate'),
                           column(8, verbatimTextOutput("bothInfo"), br(), plotOutput("both", click = "plot_clickss")),
                           column(4, dataTableOutput("bothTable"))),
                  tabPanel("Conclusion", h2("Conclusion"),verbatimTextOutput('conclusion')),
                  tabPanel("Work Cited", h2("Work Cited"),verbatimTextOutput('work'))
      )
    )
  )
)

shinyUI(ui)