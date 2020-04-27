
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)
library(stringr)
library(dplyr)
#library(rgdal)
#library(randomcoloR)
library(DT)
library(shiny)

# Define UI for application that draws a histogram




MasterList<- read.csv("Master.txt", sep =",",header=TRUE,stringsAsFactors=TRUE)
#Release date alter
MasterList$Date <- as_date(MasterList$Date)


###
#Generates a unique list of years from all the options.
GetYearList<- function(Data){
    Y<-Data$Date
    Y<-lubridate::year(Y)
    Y<-data.frame(Y)
    Y<-unique(Y)
    Y<-Y[order(Y$Y),]
    Y<-as.list(t(Y))
    Y
    
}




GetGenreList<- c("Documentary","Fantasy","Mystery","Thriller", "Comedy", "Drama", "Horror", "Action", "Crime","Sci-Fi","Music","Musical", "Biography", "History","Animation"
                 ,"Adventure","War","Romance","Western","Sport","Family","Sci-fi","Film-Noir")

GetDecade<- c("1910","1920","1930","1940","1950","1960","1970","1980","1990","2000","2010","2020")
#########################
#####Primary Table reducer
getTable<-function(Dec,Yr,Gen,Key){
    
    
    if(Dec != "ALL"){
        Dec<-as.numeric(Dec)
    }
    
    NewDat<-MasterList
    
    if(Yr!= "ALL"){
        NewDat<-MasterList[which(year(MasterList$Date)== Yr),]
    }
    
    if(Yr == "ALL" && Dec != "ALL"){
        NewDat<-NewDat[which((year(NewDat$Date)%/%10)==(Dec%/%10)),]
    }
    
    if(Gen!="ALL"){
        C<-grep(Gen,NewDat$Genre)
        C<-as.integer(C)
        NewDat<-NewDat[C,]
    }
    
    if(Key!="ALL"){
        D<-grep(Key,NewDat$Keyword)
        D<-as.integer(D)
        NewDat<-NewDat[D,]
    }
    
    NewDat
    
}
##End of table reducer
###################
getKeyList<-function(Dec,Yr,Gen,Key){
    X<-getTable(Dec,Yr,Gen,Key)
    X<-X$Keyword
    #X<-data.frame(X)
    R<-  tail(sort(table(unlist(strsplit(as.character(X), " ")))), 10)
    keywordslist<-data.frame(R)
    keywordslist<-as.character(keywordslist$Var1)
    keywordslist
}

#side bar
sidebar <- dashboardSidebar(
    disable = FALSE,
    collapsed = TRUE,
    
    selectInput("Decade", "Choose the decade", c("ALL",GetDecade), selected = "Test"),
    selectInput("Year", "Choose the year", c("ALL",GetYearList(MasterList)), selected = "ALL"),
    selectInput("Genre", "Choose the genre", c("ALL",GetGenreList), selected = "ALL"),
    selectInput("Keywords", "Selected words",c("ALL",getKeyList("ALL","ALL","ALL","ALL")), selected = "Test"),
    
    sidebarMenu(
        menuItem(
            "Dashboard",
            tabName = "dashboard",
            icon = icon("dashboard")
        ),
        menuItem(
            "About",
            icon = icon("th"),
            tabName = "about",
            badgeColor = "green"
        )
    )
)

#Body
body <- dashboardBody(tabItems(
    tabItem (tabName = "dashboard",
             fluidRow(
<<<<<<< HEAD
                 tabBox(width = 6,height = 450, id = "tabset1",
=======
                 tabBox(width = 4,height = 275, id = "tabset1",
>>>>>>> 0487f47b7f5c3ef0cbe3a4179f69d1d19b59a786
                        title = "Movies released by year",
                        side= "right",
                        tabPanel("Graphical", plotOutput("YearGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset2",
                        title = "Movies released by month",
                        side= "right",
                        tabPanel("Graphical", plotOutput("MonthGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 )
             ), fluidRow(
                 tabBox(width = 6,height = 450, id = "tabset3",
                        title = "Distribution of running times",
                        side= "right",
                        tabPanel("Graphical", plotOutput("RunningGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset4",
                        title = "distribution of certificates",
                        side= "right",
                        tabPanel("Graphical", plotOutput("CertificateGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 ),
             ),
             fluidRow(
                 tabBox(width = 6,height = 450, id = "tabset5",
                        title = "distribution of genres",
                        side= "right",
                        tabPanel("Graphical", plotOutput("GenreGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset5",
                        title = "top n keywords",
                        side= "right",
                        tabPanel("Graphical", plotOutput("KeywordGraph")),
                        tabPanel("Tabular", p("Tabular"))
                 )
             )),
    tabItem(tabName = "about",
            h1("About Page"),
            h3("Group Members:"),
            h4("- Syed Hadi"),
            h4("- Josh Rowan"),
            h4("- Sean Stiely"),
            h3("Libraries being used:"),
            h4("Shiny, shinydashboard, ggplot2, lubridate, DT, jpeg, grid, leaflet, scales, rgdal"),
            h3("Data Source:"),
            h4(" IMDB from December 2017: ftp://ftp.fu-berlin.de/pub/misc/movies/database/frozendata/ "),
    )
)  )


ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "Movie Night", titleWidth = 200),
                    sidebar,
                    body
)

# Define server logic required to draw a histogram
server <- function(input,output,session) {
    theme_set(theme_grey(base_size = 18))
    
    observe({
        inYear<- input$Year
        inDecade<- input$Decade
        inGenre<- input$Genre
        inKey<- input$Keywords
        
        NewList<-getKeyList("ALL","ALL","ALL","ALL")
        
        if(inYear!="ALL"|| inDecade != "ALL" || inGenre!="ALL"){
            NewList <- getKeyList(inDecade,inYear,inGenre,inKey)
        }
        
        
        updateSelectInput(session,"Keywords",choices=c("ALL",NewList),selected = inKey)
        
    })
    
    
    
    output$YearGraph <- renderPlot({
        plot(table(year(MasterList$Date)))
    },height = 400,width = 500)
    output$MonthGraph <- renderPlot({
        
        plot(table(month(MasterList$Date,abbr = TRUE)))
    },height = 400,width = 500)
    
    output$RunningGraph <- renderPlot({
        plot(table(MasterList$duration))
    },height = 400,width = 500)  
    
    output$GenreGraph <- renderPlot({
        plot(table(MasterList$Genres))
    },height = 400,width = 500)  
    
    output$CertificateGraph <- renderPlot({
        plot(table(MasterList$Cert))
    },height = 400,width = 500)  
    
    output$KeywordGraph <- renderPlot({
        plot(table(MasterList$Keyword))
    },height = 400,width = 500)  
    
    output$YearDT <- renderDT({
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)