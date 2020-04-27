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



test_string <- c("Test")


Cert<- read.csv("FixedCertificates.txt", sep = ",", header=TRUE, stringsAsFactors=FALSE)
Genre<- read.csv("FixedGenres.txt", sep=",", header=TRUE,stringsAsFactors=FALSE)
FK1<- read.csv("FixedKeyWords.txt", sep=",", header=TRUE,stringsAsFactors=FALSE)


MasterList<- read.csv("Master.txt", sep =",",header=TRUE,stringsAsFactors=TRUE)
Merged<- read.csv("MergedFiles.txt", sep=",", header= TRUE,stringsAsFactors=FALSE)
MasterList$Date<-sub("USA:Approved",NA,MasterList$Date)
MasterList$Date<-sub("USA:Passed",NA,MasterList$Date)
#Release date alter

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

keywordslist<-inner_join(Cert,FK1,by="Name")
keywordslist<-table(keywordslist$keyword)
keywordslist<-data.frame(keywordslist)
colnames(keywordslist)[1]<-"keyword"
colnames(keywordslist)[2]<-"count"
keywordslist<-keywordslist[order(keywordslist$count),]
keywordslist<-tail(keywordslist$keyword,100)
#keywordslist<-keywordslist[order(keywordslist$keyword),]
GetGenreList<- c("Documentary","Fantasy","Mystery","Thriller", "Comedy", "Drama", "Horror", "Action", "Crime","Sci-Fi","Music","Musical", "Biography", "History","Animation"
                 ,"Adventure","War","Romance","Western","Sport","Family","Sci-fi","Film-Noir")


#side bar
sidebar <- dashboardSidebar(
    disable = FALSE,
    collapsed = TRUE,
    
    selectInput("Decade", "Choose the decade", test_string, selected = "Test"),
    selectInput("Year", "Choose the year", c("ALL",GetYearList(MasterList)), selected = "ALL"),
    selectInput("Genre", "Choose the genre", c("ALL",GetGenreList), selected = "ALL"),
    selectInput("Keywords", "Selected words",keywordslist, selected = "Test"),

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
                 tabBox(width = 4,height = 275, id = "tabset1",
                     title = "Movies released by year",
                     side= "right",
                     tabPanel("Tab2", p("Graph")),
                     tabPanel("Tab1", p("Tabular"))
                 ),
                 tabBox(width = 4,height = 275, id = "tabset2",
                        title = "Movies released by month",
                        side= "right",
                        tabPanel("Tab2", p("Graph")),
                        tabPanel("Tab1", p("Tabular"))
                 ),
                 tabBox(width = 4,height = 275, id = "tabset3",
                        title = "Distribution of running times",
                        side= "right",
                        tabPanel("Tab2", p("Graph")),
                        tabPanel("Tab1", p("Tabular"))
                 )
             ),
             fluidRow(
                 #chronologically, or alphabetically, or by max wind speed, or minimum pressure.
                 tabBox(width = 4,height = 275, id = "tabset4",
                        title = "distribution of certificates",
                        side= "right",
                        tabPanel("Tab2", p("Graph")),
                        tabPanel("Tab1", p("Tabular"))
                 ),
                 tabBox(width = 4,height = 275, id = "tabset5",
                        title = "distribution of genres",
                        side= "right",
                        tabPanel("Tab2", p("Graph")),
                        tabPanel("Tab1", p("Tabular"))
                 ),
                 tabBox(width = 4,height = 275, id = "tabset5",
                        title = "top n keywords",
                        side= "right",
                        tabPanel("Tab2", p("Graph")),
                        tabPanel("Tab1", p("Tabular"))
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
    
}

# Run the application 
shinyApp(ui = ui, server = server)
