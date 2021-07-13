#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Our old faithful RShiny app using ggplot2"),

    # create the sidebar layout for the UI
    sidebarLayout(
        sidebarPanel(
            # add header text for the waiting variable
            h3("Waiting histogram"),
            
            # add in the slider input for the waiting bins
            sliderInput("wait_bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30,
                        step = 1),
            
            # should we include the kernel density estimate as well?
            checkboxInput("wait_kde", 
                          "Include kernel density estimate?",
                          value = FALSE),
            
            # add header text for the eruptions variable
            h4("Eruptions histogram"),
            
            # add in the slider input for the eruptions bins
            sliderInput("erupt_bins",
                        "Number of bins:",
                        min = 1, 
                        max = 35,
                        value = 21,
                        step = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            # set of tabs for different options
            tabsetPanel(type = 'tabs',
                        tabPanel("1D plots",
                                 plotOutput("waiting_hist"),
                                 plotOutput("eruptions_hist")),
                        tabPanel("2D plots",
                                 plotOutput("erupt_vs_wait"),
                                 sliderInput("scatter_marker_size",
                                             "Marker size:",
                                             min = 0.5,
                                             max = 7.5,
                                             step = 0.25,
                                             value = 2.5),
                                 sliderInput("scatter_marker_alpha",
                                             "Marker transparency:",
                                             min = 0.1,
                                             max = 1.0,
                                             step = 0.002,
                                             round = -2,
                                             value = 1.0),
                                 checkboxInput("scatter_add_kde",
                                               "Include 2D density estimate?",
                                               value = FALSE)))
        )
    )
))
