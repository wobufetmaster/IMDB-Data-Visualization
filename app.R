
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




MasterList<- read.csv("Master.txt", sep =",",header=TRUE,stringsAsFactors=FALSE)
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

                 #tabBox(width = 6,height = 450, id = "tabset1",

                 tabBox(width = 6,height = 450, id = "tabset1",

                        title = "Movies released by year",
                        side= "right",
                        tabPanel("Graphical", plotOutput("YearGraph")),
                        tabPanel("Tabular", p("Tabular"),tableOutput("K1"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset2",
                        title = "Movies released by month",
                        side= "right",
                        tabPanel("Graphical", plotOutput("MonthGraph")),
                        tabPanel("Tabular", p("Tabular"),tableOutput("K2"))
                 )
             ), fluidRow(
                 tabBox(width = 6,height = 450, id = "tabset3",
                        title = "Distribution of running times",
                        side= "right",
                        tabPanel("Graphical", plotOutput("RunningGraph")),
                        tabPanel("Tabular", p("Tabular"),tableOutput("K3"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset4",
                        title = "distribution of certificates",
                        side= "right",
                        tabPanel("Graphical", plotOutput("CertificateGraph")),
                        tabPanel("Tabular", p("Tabular"),tableOutput("K4"))
                 ),
             ),
             fluidRow(
                 tabBox(width = 6,height = 450, id = "tabset5",
                        title = "distribution of genres",
                        side= "right",
                        tabPanel("Graphical", plotOutput("GenreGraph")),
                        tabPanel("Tabular", p("Tabular"),tableOutput("K5"))
                 ),
                 tabBox(width = 6,height = 450, id = "tabset6",
                        title = "top n keywords",
                        side= "right",
                        tabPanel("Graphical", plotOutput("KeywordGraph")),
                        tabPanel("Tabular",p("Tabular"),  tableOutput("K6"))
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
    
    OurTable<- reactive({
        NewMaster<-getTable(input$Decade,input$Year,input$Genre,input$Keywords)
        NewMaster
    })
    
    
    output$YearGraph <- renderPlot({
        if(nrow(OurTable())==0){
            NoData = paste("\n  There is no Data ")
            ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
        }else{
        ggplot(as.data.frame(table(year(OurTable()$Date)))) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "blue2") +
            scale_x_discrete(name ="Year", limits=seq(from = 1930, to = 2018, by = 5))
        }
            },height = 400,width = 500)
    
    output$MonthGraph <- renderPlot({
        if(nrow(OurTable())==0){
        NoData = paste("\n  There is no Data ")
        ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
    }else{
        ggplot(as.data.frame(table(month(OurTable()$Date)))) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "red2") +
            scale_x_discrete(name ="Month", limits=1:12)
    }
    },height = 400,width = 500)
    
    output$RunningGraph <- renderPlot({
        if(nrow(OurTable())==0){
            NoData = paste("\n  There is no Data ")
            ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
        }else{
        ggplot(as.data.frame(table(OurTable()$duration))) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "green") +
            scale_x_discrete(name ="Running Time",limits = seq(from = 60, to = 180, by = 5))
        }
    },height = 400,width = 500)  
    
    output$GenreGraph <- renderPlot({
        if(nrow(OurTable())==0){
            NoData = paste("\n  There is no Data ")
            ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
        }else{
        ggplot(as.data.frame(table(unlist(strsplit(OurTable()$Genres," "))))) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "blue") +
            scale_x_discrete(name ="Genre")+
                theme(axis.text.x = element_text(face = "bold", color = "black", size = 12, angle = 90))
        }
    },height = 400,width = 500)  
    
    output$CertificateGraph <- renderPlot({
        if(nrow(OurTable())==0){
            NoData = paste("\n  There is no Data ")
            ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
        }else{
        t <- table(OurTable()$Cert)
        t <- t[t > 10]
        
            if(is.null(nrow(t))){
                NoData = paste("\n  Not Enough Data ")
                ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
            }else{
        ggplot(as.data.frame(t)) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "purple") +
            scale_x_discrete(name ="Certificate")
        }
        }
    },height = 400,width = 600)  
    
    output$KeywordGraph <- renderPlot({
        if(nrow(OurTable())==0){
            NoData = paste("\n  There is no Data ")
            ggplot() + annotate("text", x = 4, y = 25, size=8, label = NoData) + theme_bw() + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
        }else{
        myTable <- table(unlist(strsplit(OurTable()$Keyword," ")))
        myTable <- sort(myTable,decreasing = TRUE)
        myTable <- myTable[1:10]
        ggplot(as.data.frame(myTable)) + aes(x = Var1,y = Freq) + 
            geom_bar(stat="identity",fill = "pink") +
            scale_x_discrete(name ="Keywords") +
            theme(axis.text.x = element_text(face = "bold", color = "black", size = 10, angle = 75))
        }
    },height = 400,width = 500)  
    
    output$YearDT <- renderDT({
        
        
    })
    
    output$K1 <- renderTable({
        head(year(OurTable()$Date),10)
    })
    
    output$K2 <- renderTable({
        head(month(OurTable()$Date),10)
    })
    
    output$K3 <- renderTable({
        head(OurTable()$duration,10)
    })
    
    output$K4 <- renderTable({
        head(OurTable()$Genre,10)
    })
    
    output$K5 <- renderTable({
        head(OurTable()$Cert,10)
    })
    
    output$K6 <- renderTable({
        head(OurTable()$Keyword,10)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)