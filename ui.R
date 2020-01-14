library(shiny)
library(shinythemes)
library(ggplot2)
library(plotly)

shinyUI(fluidPage(theme = shinytheme("darkly"),
        titlePanel("Dosage Calculator"),
        sidebarPanel(width=6,
                numericInput(inputId = "weight", 
                            label = "Weight",
                            min = 0,
                            max = 200,
                            value = 12, width = 70),
                div(style="display: inline-block;vertical-align:top;width: 100px;height:30px",
                    numericInput(inputId = "dose",
                                 label = NULL,
                                 value = 30)),
                div(style="display: inline-block;vertical-align:top;width: 70px;height:30px",
                    selectInput( inputId = "unit", 
                                 label = NULL,
                                 choices = c("mcg","mg", "g"))) ,
                p(style="display: inline-block;vertical-align:top;width: 30px;","/Kg/"),
                div(style="display: inline-block;vertical-align:top;width: 70px;",
                    selectInput( inputId = "division", 
                               label = NULL,
                               choices = c("day", "dose"))
                ),
                sliderInput(inputId = "frequency", label = "How to divide?", min = 0.5,
                             max = 24, step = 0.5, value = 24, post = " Hour", pre = "Every "),
                sliderInput(inputId = "reduction", label = "Dose Reduction", min = 0, max = 95, step = 5, value = 0, post = "%"),
                p(strong("A Liquid Formulation Concentration")),
                
                div(style="display: inline-block;vertical-align:top;width: 90px;height:30px",
                    numericInput(inputId = "conc",
                                 min = 0,
                                 max = 1000000,
                                 step = 0.5,
                                 value = NULL,
                                 label = NULL)),
                div(style="display: inline-block;vertical-align:top;width: 70px;height:30px",
                    selectInput( inputId = "mass", 
                                 label = NULL,
                                 choices = c("mcg","mg", "g"))
                ),
                p(style="display: inline-block;vertical-align:top;width: 10px;height:30px",strong("/")),
                div(style="display: inline-block;vertical-align:top;width: 80px;height:30px",
                    numericInput(inputId = "suspvol",
                                 label = NULL,
                                 min = 0.25,
                                 max = 1000,
                                 step = 0.5,
                                 value = 1)
                    ) ,
                div(style="display: inline-block;vertical-align:top;width: 70px;height:30px",
                    selectInput( inputId = "volu", 
                                 label = NULL,
                                 choices = c("ml"))
                )
        ), # End sidepanel
        mainPanel(width=5,
                  tabsetPanel(
                  tabPanel("Calculations",
                  h2("Input Parameters"),
                  p("The patient weight is", 
                    textOutput("weight", inline = T),
                    "Kgs"),
                  p("Dose is", 
                    textOutput("dose", inline = T),
                    textOutput("unit", inline = T),
                    "/", "Kg",
                    "/", 
                    textOutput("division", inline = T)),
                  p(textOutput("freqtext")),
                  p(textOutput("reductiontext")),
                  p(textOutput("concentrationtext")),
                  h2("Calculations"),
                  p("Dose is", textOutput("dailydose", inline = T),textOutput("unit2", inline = T) ,"every ", textOutput("freqtext2", inline = T)),
                  h4("Liquid Volume"),
                  p(textOutput("finalvol", inline = T)),
                  plotlyOutput("dosechart")
                  
                  ),
                  tabPanel("About",
                  p("This app is intended to help healthcare professionals to quickly determine the dose required for a patient depends on his weight, renal and hepatic functions. The app also consider if the drug is in a liquid formulation, calculating the required volume.")
                  )
                  )#tabsetpanel
        )
))