#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    # make the histogram for the waiting variable
    # assign the output plot to the output object
    output$waiting_hist <- renderPlot({
        # place the code to make the plot inside the curly braces
        g <- faithful %>% 
            ggplot(mapping = aes(x = waiting)) +
            geom_histogram(bins = input$wait_bins,
                           mapping = aes(y = stat(density)),
                           fill = 'grey50') +
            labs(title = "waiting histogram") +
            # coord_cartesian(ylim = c(0, 225)) +
            theme_bw()
        
        if(input$wait_kde){
            g <- g + geom_density(size = 1.55, color = 'navyblue')
        }
        
        g
    })
    
    # DO NOT ADD COMMAS between objects in the server script
    
    # make the eruptions histogram
    output$eruptions_hist <- renderPlot({
        faithful %>% 
            ggplot(mapping = aes(x = eruptions)) +
            geom_histogram(bins = input$erupt_bins,
                           fill = 'grey70') +
            labs(title = "eruptions histogram") +
            theme_bw()
    })
    
    # make a scatter plot between the two variables for the 2D plots tab
    output$erupt_vs_wait <- renderPlot({
        g2 <- faithful %>% 
            ggplot(mapping = aes(x = waiting, y = eruptions)) +
            geom_point(size = input$scatter_marker_size,
                       alpha = input$scatter_marker_alpha) +
            labs(title = "Eruptions vs Waiting") +
            theme_bw()
        
        if(input$scatter_add_kde){
            g2 <- g2 + geom_density_2d(size = 1.25, color = 'blue')
        }
        
        g2
    })
    

    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })

})
