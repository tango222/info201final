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
                  choices= mort.Alabama$Category, selected = "Neonatal Disorders")),
    
    mainPanel(
      fluidRow(
        column(8, tabsetPanel(
          type = "tabs",
                              tabPanel("descript", h2("Description"),verbatimTextOutput("info")),
                              tabPanel("Binge"),
                              tabPanel("Map: Binge Drinking", h2("Binge Drinking Percent"), plotOutput("binge",click = "plot_click")),
                              tabPanel("Map: Mortality Rate", h2('Mortality Rate'), plotOutput("mort",click = "plot_click")),
                              tabPanel("Map: Mortality Rate vs Binge Drinking", h2('Mortality Rate vs Binge Drinking'), plotOutput("both", click = "plot_click"))
        )
        ),
        column(4,
               verbatimTextOutput("info"), br(),
               dataTableOutput('table')
        )
      )
    )
  )
)

server <- function(input, output) {
  
  filter.binge.mean.state <- reactive({
    info <- select(binge.drinking.com, 1,2, paste0("mean.", input$Sex))
    info <- filter(info, state == location)
    info <- select(info, 1, 3)
    return(info)
  })
  
  filter.mort.state.category <- reactive({
    info <- filter(mort.state, Category == input$category)
    return(info)
  })
  
  output$mort <- renderPlot({
    mort <- filter.mort.state.category()
    mort <- mutate(mort, region = tolower(Location))
    mort <- select(mort, 5,4)
    mort$level <- cut(mort[ ,2], breaks = 8)
    map.US <- left_join(map.US, mort, by = 'region')
    ggplot(data = map.US) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = level, color = "Black"))+
      scale_fill_brewer(palette = "Greens", direction = -1)+
      ggtitle(input$category) +
      theme_bw()
  })
  
  output$binge <- renderPlot({
    binge <- filter.binge.mean.state()
    binge <- mutate(binge, region = tolower(state))
    binge <- select(binge, 3,2)
    binge$level <- cut(binge[ ,2], breaks = 8)
    map.US <- left_join(map.US, binge, by = 'region')
    ggplot(data = map.US) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = level, color = "Black"))+
      scale_fill_brewer(palette = "Oranges", direction = -1)+
      theme_bw()
  })
  
  output$both <- renderPlot({
    mort <- filter.mort.state.category()
    mort <- mutate(mort, region = tolower(Location))
    mort <- select(mort, 5,4)
    binge <- filter.binge.mean.state()
    binge <- mutate(binge, region = tolower(state))
    binge <- select(binge, 3,2)
    both <- left_join(mort, binge, by = 'region')
    both <- mutate(both, scale = both[ ,3] / both[ ,2])
    both$level <- cut(both[ ,'scale'], breaks = 8)
    map.US <- left_join(map.US, both, by = 'region')
    ggplot(data = map.US) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = level, color = "Black"))+
      scale_fill_brewer(palette = "Purples", direction = -1)+
      theme_bw()
  })
  
  output$time.plot <- renderPlot({
    
  })
  
  output$table <- renderDataTable({
    filter.binge.mean.state()
  })
  
  output$info <- renderText({
    paste(GetCountryAtPoint(input$plot_click$x, input$plot_click$y))
  })
}

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)