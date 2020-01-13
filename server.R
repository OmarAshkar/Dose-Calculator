library(shiny)

shinyServer(
        function(input, output) {
                output$weight <- renderText({input$weight})
                output$dose <- renderText({input$dose})
                output$unit <- renderText({input$unit})
                output$unit2 <- renderText({input$unit})
                output$division <- renderText({input$division})
                output$frequency <- renderText({input$frequency})
                
                output$freqtext <-  renderText({
                        if(input$division == "dose"){
                                paste("Delivered Every", input$frequency, "Hours")}
                        
                        else{
                                paste("Divided Every", input$frequency, "Hours")}
                }
                )
                
                output$reductiontext <-  renderText({
                        if(input$reduction %in% c(0, NULL)){
                                paste("No Dose Reduction Required")}
                        else{
                                paste("Main dose is to be reduced by", input$reduction, "%")
                        }
                }
                )
                
                output$concentrationtext <-  renderText({
                        if(input$conc %in% c(0, NA)){
                                paste("No Liquid Concentration Given")}
                        else{
                                paste("Drug Concentration is", 
                                      input$conc, input$mass,"/", input$volu)
                        }
                }
                )
                
                
                #return a list of daily dose and divided dose
                output$dailydose <- renderText({
                        
                        x <- input$dose * input$weight
                        y <- ifelse(input$reduction ==0, x, x*(1-input$reduction/100))
                        
                        if(input$division == "day"){
                                y / (24/input$frequency)
                        }
                        else{
                                y
                        }
                })
                

                calcfreq <- function(){
                        x <- 24/input$frequency
                        paste("Every", 
                              input$frequency,
                              "hours",
                              ifelse(x%%1==0, paste("(", x, "Times Daily)"), ".")
                        )#end paste
                }
                output$freqtext2 <- renderText({
                        calcfreq()
                })
                        
                #conversions
                output$finalvol<- renderText({
                        x <- input$dose * input$weight
                        y <- ifelse(input$reduction ==0, x, x*(1-input$reduction/100))
                        if(!input$conc %in% c(0, NA)){
                                if(input$unit == input$mass){
                                        paste("Final Volume",
                                              round(y/input$conc, digits = 1),
                                              input$volu,
                                              calcfreq())
                                }
                        }
                        else{"No Liquid Concentration Given"}
                })
                        
                       
        }
        
        ) #server Bracket