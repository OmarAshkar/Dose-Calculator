library(shiny)

shinyUI(fluidPage(
        sidebarPanel(width=5,
                numericInput(inputId = "weight", 
                            label = "Weight",
                            min = 0,
                            max = 200,
                            value = 12, width = 70),
                div(style="display: inline-block;vertical-align:bottom;width: 100px;",
                    numericInput(inputId = "dose",
                                 label = "Dose",
                                 value = 30)),
                div(style="display: inline-block;vertical-align:bottom;width: 70px;",
                    selectInput( inputId = "unit", 
                                 label = NULL,
                                 choices = c("mcg","mg", "g"))) ,
                div(style="display: inline-block;vertical-align:bottom;width: 30px;",p("/Kg/")),
                div(style="display: inline-block;vertical-align:bottom;width: 70px;",
                    selectInput( inputId = "division", 
                               label = NULL,
                               choices = c("day", "dose"))
                ),
                sliderInput(inputId = "frequency", label = "How to divide?", min = 0.5,
                             max = 24, step = 0.5, value = 24, post = " Hour", pre = "Every "),
                sliderInput(inputId = "reduction", label = "Dose Reduction", min = 0, max = 95, step = 5, value = 0, post = "%"),
                div(style="display: inline-block;vertical-align:bottom;width: 100px;",
                    numericInput(inputId = "conc",
                                 label = "Concentration",
                                 min = 0,
                                 max = 1000000,
                                 step = 0.5,
                                 value = NULL)),
                div(style="display: inline-block;vertical-align:bottom;width: 70px;",
                    selectInput( inputId = "mass", 
                                 label = NULL,
                                 choices = c("mcg","mg", "g"))
                ),
                div(style="display: inline-block;vertical-align:bottom;width: 70px;",
                    selectInput( inputId = "volu", 
                                 label = NULL,
                                 choices = c("ml"))
                )
        ), # End sidepanel
        mainPanel(width=5,
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
                  p(textOutput("finalvol", inline = T))
                  
                  
                  
)))