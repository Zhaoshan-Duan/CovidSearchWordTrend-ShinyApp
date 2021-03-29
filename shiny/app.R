library(pacman)
p_load(shiny,shinythemes)

if(!exists("trend")) {source("wrangle.R")}

# css design for the buttons ---- 
button_color_css <- "
#DivCompClear, #FinderClear, #EnterTimes{
background: DodgerBlue;
font-size: 15px;
}"

# UI Definition ---- 
ui <- fluidPage(
    #Navbar 
    navbarPage("Google Trend during COVID", theme = shinytheme("lumen"),
               
               # "Interest Over Time" Tab ----     
               tabPanel("Interest Over Time", fluid = TRUE, icon = icon("google"), tags$style(button_color_css),
                        
                        # Sidebar 
                        sidebarLayout(
                            sidebarPanel(
                                
                                # Application title 
                                titlePanel("Search Terms"),
                                
                                # title line
                                hr(style="border-color: grey;"),
                                
                                # search word page
                                fluidRow(
                                    # search word list of 6
                                    column(3,
                                           # select which search keyword to plot 
                                           checkboxGroupInput(inputId = "keyword",
                                                              # label = "Select Keyword(s):",
                                                              label = "Search words:",
                                                              choices = c("COVID Symptoms","Coronavirus Symptoms","Sore Throat",
                                                                          "Shortness of Breath","Fatigue","Cough"),
                                                              selected = "COVID Symptoms"),
                                    ),
                                    # search word list of 5
                                    column(3, offset = 2,
                                           # select which search keyword to plot 
                                           checkboxGroupInput(inputId = "keyword",
                                                              label = "",
                                                              choices = c("Corona Virus Testing Centers", "Loss of Smell", "Lysol",
                                                                          "Antibodies","Face Masks","Coronavirus Vaccine","COVID Stimulus Check"),
                                                              selected = "Face Masks"),
                                    )),
                            ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                plotOutput(outputId = "distPlot")
                            )
                        )
               ),
               
               # "Interest Comparison" Tab ---- 
               tabPanel("Interest Comparisons", fluid = TRUE, icon = icon("th"),
                        titlePanel("Interest Comparisons"),
                        
                        mainPanel(
                            plotOutput(outputId = "facetPlot")
                        )
                        
               )
               ,
               # "About " Tab ---- 
               tabPanel("About", fluid = TRUE, icon = icon("question-circle"),
                        titlePanel("About This Project"),
                        mainPanel(
                            p("This project is made by Zhaoshan Duan for STAT 694"),
                        )
                        
               )
    )
    
)






# Server Definition ----
server <- function(input, output,session) {
    
    filtered_data <- reactive({
        dplyr::filter(trend, keyword == input$keyword)
    })
    
     output$distPlot <- renderPlot({
         
         ggplot(filtered_data(),aes(x=date, y=hits,group=keyword,col=keyword))+
             geom_line(size=1.5)+
             xlab('Time')+ylab('Relative Interest')+ theme_bw()+
             theme(legend.title = element_blank(),
                   legend.position="bottom",legend.text=element_text(size=12))+
             ggtitle("Google Search")
     })
    
    
    
    
    
    
    
    # Interest Over Time 

    
    output$facetPlot <- renderPlot({

        ggplot(trend,aes(x=date, y=hits,group=keyword,col=keyword))+
            geom_line(size=1.5)+
            xlab('Time')+ylab('Relative Interest')+ theme_bw()+
            theme(legend.title = element_blank(),
                  legend.position="bottom",legend.text=element_text(size=12))+
            ggtitle("Google Search") +
            facet_wrap(~keyword)
        
        
    })
}



shinyApp(ui = ui, server = server)