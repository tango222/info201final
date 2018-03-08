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
      scale_fill_brewer(palette = "Greens", direction = 1)+
      ggtitle(input$category) +
      theme_bw()
  })
  
  output$binge <- renderPlot({
    binge <- filter.binge.mean.state()
    binge <- mutate(binge, region = tolower(state))
    binge <- select(binge, 3,2)
    binge$level <- cut(binge[ ,2], breaks = c(0,10,12.5,15,17.5,20,22.5,25,30,35,40))
    map.US <- left_join(map.US, binge, by = 'region')
    ggplot(data = map.US) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = level, color = "Black"))+
      scale_fill_brewer(palette = "Oranges", direction = 1)+
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
  
  output$bingeTable <- renderDataTable({
    filter.binge.mean.state()
  })
  
  output$mortTable <- renderDataTable({
    mort <- filter.mort.state.category()
    select(mort, 1,3,4)
  })
  
  output$bothTable <- renderDataTable({
    mort <- filter.mort.state.category()
    mort <- mutate(mort, region = tolower(Location))
    mort <- select(mort, 5,4)
    binge <- filter.binge.mean.state()
    binge <- mutate(binge, region = tolower(state))
    binge <- select(binge, 3,2)
    both <- left_join(mort, binge, by = 'region')
    both <- mutate(both, scale = both[ ,3] / both[ ,2])
  })
  
  output$bingeInfo <- renderText({
    if(!is.na(GetCountryAtPoint(input$plot_click$x, input$plot_click$y))){
      name <- GetCountryAtPoint(input$plot_click$x, input$plot_click$y)
      binge <- filter.binge.mean.state()
      binge <- mutate(binge, region = tolower(state))
      binge <- filter(binge, region == name)
      i <- paste0("This state is ", name, " the binge drinking percent in this state is ", binge[1,2], ".")
    }else {
      binge <- filter.binge.mean.state()
      if(input$Sex == "male"){
        binge <- arrange(binge, -mean.male)
      }else if(input$Sex == "female"){
        binge <- arrange(binge, -mean.female)
      }else{
        binge <- arrange(binge, -mean.both)
      }
      i <- paste0("This map shows you the different levels of binge drinking accross the US, not including Alaska and Hawaii. ",
                  "The table to the right of the map shows you what data was being used to create the map. ",
                  "The state with the highest level of binge drinking for ", input$Sex, " is ", binge[1,1], ". ",
                  "The binge Drinking percent in this state is ", binge[1,2], ".")
    }
    return(i)
  })
  
  output$mortInfo <- renderText({
    if(!is.na(GetCountryAtPoint(input$plot_clicks$x, input$plot_clicks$y))){
      name <- GetCountryAtPoint(input$plot_clicks$x, input$plot_clicks$y)
      mort <- filter.mort.state.category()
      mort <- mutate(mort, region = tolower(Location))
      mort <- filter(mort, region == name)
      i <- paste0("This state is ", name, " the mortality rate for ", input$category,"in this state is, ", mort[1,4], ".")
    }else {
      mort <- filter.mort.state.category()
      mort <- arrange(mort, Mortality.Rate..2010.)
      i <- paste0("This map shows you the different levels of mortality accross the US, not including Alaska and Hawaii, for ", input$category, ". ",
                  "The table to the right of the map shows you what data was being used to create the map. ",
                  "The state with the highest level of death in ", input$category, " is ", mort[1,1], ". ",
                  "The mortality rate in this state is ", mort[1,4], ".")
    }
    return(i)
  })
  
  output$bothInfo <- renderText({
    if(!is.na(GetCountryAtPoint(input$plot_clickss$x, input$plot_clickss$y))){
      name <- GetCountryAtPoint(input$plot_clickss$x, input$plot_clickss$y)
      mort <- filter.mort.state.category()
      mort <- mutate(mort, region = tolower(Location))
      mort <- select(mort, 5,4)
      binge <- filter.binge.mean.state()
      binge <- mutate(binge, region = tolower(state))
      binge <- select(binge, 3,2)
      both <- left_join(mort, binge, by = 'region')
      both <- mutate(both, scale = both[ ,3] / both[ ,2])
      both <- mutate(both, region = tolower(region))
      both <- filter(both, region == name)
      i <- paste0("This state is ", name, " the correlation for in this state is, ", both[1,4], ".")
    }else {
      mort <- filter.mort.state.category()
      mort <- mutate(mort, region = tolower(Location))
      mort <- select(mort, 5,4)
      binge <- filter.binge.mean.state()
      binge <- mutate(binge, region = tolower(state))
      binge <- select(binge, 3,2)
      both <- left_join(mort, binge, by = 'region')
      both <- mutate(both, scale = both[ ,3] / both[ ,2])
      both <- arrange(both, scale)
      i <- paste0("This map shows you the correlation between, ", input$category, " and ", input$Sex,
                  " accross the US, not including Alaska and Hawaii. The closer to 1 the more correlated they have.",
                  "The table to the right of the map shows you what data was being used to create the map. ",
                  "The state with the highest correlation is ", both[1,1], ". ",
                  "The correlation in this state is ", both[1,4], ".")
    }
    return(i)
  })
  
  output$description <- renderText({
    paste(	"Our first dataset is made up of countrywide data on binge drinking. This includes the percentages of males and/or females who participate in binge drinking.",
           " Binge drinking is defined as consuming more than five drinks in one day.", 
           " It has county and state level data for these different categories.",
           "Our second dataset is information on countrywide mortality rates. This includes more than 20 different causes of mortality and can be sorted by state or by county.",
           "To make sure our data was correlated we only used information from 2006 to 2010.",
           "There were many different questions we came up with to ask about these datasets, but we narrowed it down to three:
             -          How does binge drinking rate vary by state or area of the country?
             -          How does binge drinking relate to neonatal mortality? 
             -          How does mortality rate vary by state or area of the country? "
    )
  })
  
  output$conclusion <- renderText({
    paste("-Binge Drinking is more prevalent amongst males than females.

-From the maps we can see that different areas of the United States are plagued by different causes of death. For example, we can see that Neonatal Disorders are more prevalent in the South. Examples of neonatal disorders are Prematurity, respiratory dysfunction, birth trauma, congenital malformations, neonatal infection and haemolytic disorders of the newborn.

-There is higher correlation between binge drinking and mortality rate percentages in the south. The correlation between genders for binge drinking and mortality changes across genders. For example, for females the correlation is much higher than males when binge drinking is correlated with neonatal disorders, which makes sense because females carry the child." 
    )
  })
  
  output$work <- renderText({
    paste("Mortality Rate data retrieved from Kaggle.com

Binge drinking data retrieved from INFO 201 class at the University of Washington Winter ‘18"
    )
  })
}

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)
