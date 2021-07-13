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
    titlePanel("Explore iris with scatter plots"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("x_axis_var",
                        "Select the x-axis variable:",
                        choices = iris_numeric_names,
                        selected = iris_numeric_names[1]),
            selectInput("y_axis_var",
                        "Select the y-axis variable:",
                        choices = iris_numeric_names,
                        selected = iris_numeric_names[2]),
            checkboxInput("species_color",
                          "Color by Species?",
                          value = FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("iris_scatter")
        )
    )
))
