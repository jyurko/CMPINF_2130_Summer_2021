#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(
    
    navbarPage("Title",
               tabPanel("Welcome!",
                        includeMarkdown("yacht_welcome.md"),
                        tableOutput("tbl_overview")),
               tabPanel("Explore inputs",
                        sidebarLayout(
                            sidebarPanel(
                                h3("Input-to-input scatter plot"),
                                selectInput("s_xa",
                                            "Select input 1:",
                                            choices = input_names,
                                            selected = input_names[1]),
                                selectInput("s_xb",
                                            "Select input 2:",
                                            choices = input_names,
                                            selected = input_names[2])
                            ),
                            mainPanel(
                                plotOutput("input_scatter_plot")
                            )
                        )),
               tabPanel("Explore output",
                        tabsetPanel(type = 'tabs',
                                    tabPanel('Output histogram',
                                             plotOutput("response_hist"),
                                             # verbatimTextOutput("check_output_transformation"),
                                             h3("Apply transformation to output?"),
                                             radioButtons("y_warp_radio",
                                                          "Select transformation type:",
                                                          choices = c("no transformation" = 'none',
                                                                      "natural log" = 'log',
                                                                      "square root" = 'sqrt',
                                                                      'inverse' = 'inverse'),
                                                          inline = TRUE)),
                                    tabPanel('sub tab 2',
                                             sidebarLayout(
                                                 sidebarPanel(),
                                                 mainPanel()
                                             )))
                        ),
               tabPanel("Models",
                        tabsetPanel(type = 'tabs',
                                    tabPanel('Overview'),
                                    tabPanel('Fit',
                                             h3("Type the formulas for each model below."),
                                             verbatimTextOutput("check_prepro_work"),
                                             textInput("formula_1",
                                                       "Formula for Model 1:"),
                                             textInput("formula_2",
                                                       "Formula for Model 2:"),
                                             textInput("formula_3",
                                                       "Formula for Model 3:"),
                                             radioButtons("warp_output_radio",
                                                          "Do you want to transform the response?",
                                                          choices = c("no transformation" = 'none',
                                                                      "natural log" = 'log',
                                                                      "square root" = 'sqrt',
                                                                      'inverse' = 'inverse'),
                                                          inline = TRUE),
                                             h3("pre-processing"),
                                             radioButtons("stan_input_radio",
                                                          "Do you want to standardize the inputs first?",
                                                          choices = c("yes" = "yes",
                                                                      "no" = "no"),
                                                          selected = "yes",
                                                          inline = TRUE),
                                             radioButtons("stan_output_radio",
                                                          "Do you want to standardize the response?",
                                                          choices = c("yes" = "yes",
                                                                      "no" = "no"),
                                                          selected = "yes",
                                                          inline = TRUE),
                                             h3("Ready to fit the models?"),
                                             actionButton("go_models", 
                                                          "Fit Models!!!!!!!!")
                                             ),
                                    tabPanel('Coefficients',
                                             tabsetPanel(
                                                 tabPanel('Individual models',
                                                          # plotOutput("coefplot_1"),
                                                          # plotOutput("coefplot_2"),
                                                          # plotOutput("coefplot_3"),
                                                          uiOutput("coefplot_dynamic"),
                                                          selectInput("show_coefplot",
                                                                      "Select the model to show:",
                                                                      choices = c("Model 1", 
                                                                                  "Model 2",
                                                                                  "Model 3"),
                                                                      selected = "Model 1")
                                                          ),
                                                 tabPanel('2')
                                             )),
                                    tabPanel('Residuals'),
                                    tabPanel('Performance metrics',
                                             tabsetPanel(
                                                 tabPanel('1'),
                                                 tabPanel('2'),
                                                 tabPanel('3'),
                                                 tabPanel('4')
                                             )),
                                    tabPanel('Visualize prediction trends')
                                    ))
               )

)
