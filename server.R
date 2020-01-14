library(shiny)
library(ggplot2)
library(plotly)
shinyServer(
        function(input, output) {
                output$weight <- renderText({input$weight})
                output$dose <- renderText({input$dose})
                output$unit <- renderText({input$unit})
                output$unit2 <- renderText({input$unit})
                output$division <- renderText({input$division})
                output$frequency <- renderText({input$frequency})
                output$suspvol <- renderText({input$suspvol})
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
                                      input$conc, input$mass,"/", input$suspvol,  input$volu)
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
                        if(!input$conc %in% c(0, NA)){
                                x <- input$dose * input$weight
                                y <- ifelse(input$reduction ==0, x, x*(1-input$reduction/100))
                                # No conversion
                                if(input$unit == input$mass){
                                        paste("Final Volume",
                                              round((y)*input$suspvol/input$conc, digits = 1),
                                              input$volu,
                                              calcfreq())
                                }
                                # Conversion
                                else{
                                        # mg to mcg
                                        if(input$unit == "mg" && input$mass == "mcg"){
                                                paste("Final Volume",
                                                      round((y*1000)*input$suspvol/input$conc, digits = 1),
                                              input$volu,
                                              calcfreq())       
                                        }
                                        # mg to g
                                        else if(input$unit == "mg" && input$mass == "g"){
                                                paste("Final Volume",
                                                      round((y/1000)*input$suspvol/input$conc, digits = 1),
                                                      input$volu,
                                                      calcfreq()) 
                                                
                                        }
                                        # # mcg to mg
                                        else if(input$unit == "mcg" && input$mass == "mg"){
                                                paste("Final Volume",
                                                      round((y/1000)*input$suspvol/input$conc, digits = 1),
                                                      input$volu,
                                                      calcfreq())  
                                                
                                        }
                                        # # mcg to g
                                        else if(input$unit == "mcg" && input$mass == "g"){
                                                paste("Final Volume",
                                                      round((y/10^6)*input$suspvol/input$conc, digits = 1),
                                                      input$volu,
                                                      calcfreq())  
                                        }
                                        # # g to mg
                                        else if(input$unit == "g" && input$mass == "mg"){
                                                paste("Final Volume",
                                                      round((y*10^3)*input$suspvol/input$conc, digits = 1),
                                                      input$volu,
                                                      calcfreq())  
                                        }
                                        # # g to mcg
                                        else if(input$unit == "g" && input$mass == "mcg"){
                                                paste("Final Volume",
                                                      round((y*10^6)*input$suspvol/input$conc, digits = 1),
                                                      input$volu,
                                                      calcfreq())  
                                        }
                                        
                                }
                                
   
                        }
                        else{"No Liquid Concentration Given"}
                }) #finalvol
                
                output$dosechart <- renderPlotly({
                        if(input$reduction == 0){
                                tit <- ifelse(input$division == "dose", 
                                            paste(" Dose of", input$dose,input$unit,
                                                  "/ Kg/", input$division
                                                  ,"\n","Delivered Every", input$frequency, "Hours"),
                                            paste(" Dose of", input$dose,input$unit ,"/ Kg/",
                                                  input$division,
                                                  "\n","to be Divided Every", input$frequency, "Hours")
                                            )
                                weight <- 0.5:100
                                dose <- weight*input$dose
                                p <- ggplot(mapping = aes(x = weight, y = dose)) +
                                        geom_smooth() + 
                                        ggtitle(label = tit) + 
                                        ylab(paste("Dose in ", 
                                                   input$unit,
                                                   "/Kg/", 
                                                   input$division )) +
                                        xlab("Weight in Kgs") +
                                        theme(plot.title = element_text(hjust = 0.5, vjust= 0.5, size = 12))
                                ggplotly(p, tooltip= c("weight"))
                }
                })
      
                        
                       
        }
        
        ) #server Bracket