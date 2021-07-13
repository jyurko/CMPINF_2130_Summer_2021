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

    # make the scatter plot between the user selected inputs
    output$iris_scatter <- renderPlot({
        if(!input$species_color){
            g <- iris %>% 
                ggplot(mapping = aes_string(x = input$x_axis_var,
                                            y = input$y_axis_var)) +
                geom_point() +
                theme_bw()
        } else {
            g <- iris %>% 
                ggplot(mapping = aes_string(x = input$x_axis_var,
                                            y = input$y_axis_var)) +
                geom_point(mapping = aes(color = Species)) +
                ggthemes::scale_color_colorblind() +
                theme_bw() +
                theme(legend.position = "bottom")
        }
        
        g
    })

})
