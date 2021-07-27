#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

### ui function for the yacht lm compare app

shinyUI(
    
    navbarPage("Fit linear models to the Yacht Hydrodynamics Data set",
               tabPanel("Welcome!",
                        includeMarkdown("yacht_welcome.md"),
                        tableOutput('tbl_overview')),
               tabPanel("Explore inputs",
                        sidebarLayout(
                            sidebarPanel(
                                h3("Input-to-input scatter plot"),
                                selectInput("s_xa", 
                                            "Select input 1:",
                                            selected = input_names[1],
                                            choices = input_names),
                                selectInput("s_xb",
                                            "Select input 2:",
                                            selected = input_names[2],
                                            choices = input_names),
                                checkboxInput("s_count_button",
                                              "Show counts?",
                                              value = FALSE)
                            ),
                            mainPanel(
                                plotOutput("input_scatter_plot")
                            )
                        )),
               tabPanel("Explore output",
                        tabsetPanel(type = 'tabs',
                                    tabPanel("Output histogram",
                                             plotOutput("response_hist"),
                                             h3("Apply transformation to output?"),
                                             # use radio buttons to ask about a transformation
                                             radioButtons(inputId = "y_warp_radio",
                                                          label = "Select transformation type:",
                                                          choices = c("no transformation" = "none",
                                                                      "natural log" = 'log',
                                                                      "square root" = "sqrt",
                                                                      "inverse" = "inverse"),
                                                          inline = TRUE)
                                             # ,textOutput("check_radio_button")
                                             ),
                                    tabPanel("Output-to-input scatter plot",
                                             sidebarLayout(
                                               sidebarPanel(
                                                 selectInput("scatter_x",
                                                             "Select input:",
                                                             choices = input_names,
                                                             selected = input_names[1]),
                                                 radioButtons(inputId = "scatter_y_warp",
                                                              label = "Transform output?",
                                                              choices = c("no transformation" = "none",
                                                                          "natural log" = 'log',
                                                                          "square root" = "sqrt",
                                                                          "inverse" = "inverse"))
                                               ),
                                               mainPanel(
                                                 plotOutput("viz_response_input_scatter")
                                               )
                                             ))
                                    )
                        ),
               tabPanel("Models",
                        tabsetPanel(type = 'tabs',
                                    tabPanel("Overview",
                                             includeMarkdown("yacht_models_overview.md")),
                                    tabPanel("Fit",
                                             h3("Variable names:"),
                                             textOutput("print_varnames"),
                                             h3("Type the formulas for each model below."),
                                             textInput("formula_1",
                                                       "Formula for Model 1:"),
                                             # textOutput("check_mod_formula_1")
                                             textInput("formula_2",
                                                       "Formula for Model 2:"),
                                             textInput("formula_3",
                                                       "Formula for Model 3:"),
                                             radioButtons(inputId = "warp_output_radio",
                                                          label = "Do you want to transform the response?",
                                                          choices = c("no transformation" = "none",
                                                                      "natural log" = 'log',
                                                                      "square root" = 'sqrt'),
                                                          inline = TRUE),
                                             h4("Note: the response will be transformed for all 3 models."),
                                             h3("Pre-processing"),
                                             radioButtons(inputId = "stan_input_radio",
                                                          label = "Do you want to standardize the inputs first?",
                                                          choices = c("yes" = "yes",
                                                                      "no" = "no"),
                                                          inline = TRUE),
                                             radioButtons(inputId = "stan_output_radio",
                                                          label = "Do you want to standardize the response?",
                                                          choices = c("yes" = "yes",
                                                                      "no" = "no"),
                                                          inline = TRUE),
                                             h4("Note: if the response is transformed, the transformed response is standardized"),
                                             h3("Ready to fit models?"),
                                             actionButton("go_models", "Fit models!!!")
                                             ),
                                    tabPanel("Coefficients",
                                             tabsetPanel(type = 'tabs',
                                                         tabPanel("individual models",
                                                                  # verbatimTextOutput("check_prepro_work"),
                                                                  # plotOutput("coefplot_1"),
                                                                  # plotOutput("coefplot_2"),
                                                                  # plotOutput("coefplot_3"),
                                                                  uiOutput("coefplot_dynamic"),
                                                                  selectInput("show_coefplot",
                                                                              "Select the model to show:",
                                                                              choices = c("Model 1", "Model 2", "Model 3"),
                                                                              selected = "Model 1")
                                                                  ),
                                                         tabPanel("all models together",
                                                                  h4("Note: the multi-plot works best when similar features are used across models."),
                                                                  plotOutput("coefplot_multiplot", height = "500px")))),
                                    tabPanel("Residuals",
                                             h4("Visualize the residual with respect to an input"),
                                             # verbatimTextOutput("check_augment_train_df"),
                                             plotOutput("viz_resid_input_scatter"),
                                             selectInput("resid_x_view",
                                                         "Select input for x-axis:",
                                                         choices = input_names,
                                                         selected = input_names[1])
                                             ),
                                    tabPanel("Performance metrics",
                                             tabsetPanel(type = 'tabs',
                                                         tabPanel("predicted-vs-observed figure",
                                                                  plotOutput("viz_pred_vs_obs")),
                                                         tabPanel("R-squared",
                                                                  plotOutput("viz_r2_model")),
                                                         tabPanel("RMSE",
                                                                  plotOutput("viz_rmse_model")),
                                                         tabPanel("AIC/BIC",
                                                                  plotOutput("viz_aic_bic_model")))),
                                    tabPanel("Visualize prediction trends",
                                             sidebarLayout(
                                               sidebarPanel(
                                                 selectInput("viz_x_var",
                                                             "Select x-axis variable:",
                                                             choices = input_names,
                                                             selected = input_names[length(input_names)]),
                                                 selectInput("viz_facet_var",
                                                             "Select facet variable:",
                                                             choices = input_names,
                                                             selected = input_names[2]),
                                                 selectInput("viz_num_facets",
                                                             "Select number of facet levels:",
                                                             choices = 1:5,
                                                             selected = 3),
                                                 selectInput("viz_quant_use",
                                                             "Select quantile for remaining inputs:",
                                                             choices = c(0.25, 0.5, 0.75),
                                                             selected = 0.5),
                                                 radioButtons("viz_add_train_radio",
                                                              "Include training set?",
                                                              choices = c("yes" = "yes", 
                                                                          "no" = "no"),
                                                              selected = "no",
                                                              inline = TRUE)
                                               ),
                                               mainPanel(
                                                 plotOutput("viz_default_pred", height = "750px")
                                               )
                                             )
                                             )
                                    )
                        )
               )

)
