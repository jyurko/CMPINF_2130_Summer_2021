#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    ### display the variable overview table to the user
    output$tbl_overview <- renderTable({
        var_overview
    },
    striped = TRUE,
    bordered = TRUE,
    hover = TRUE
    )
    
    ### create a scatter plot between user specified inputs
    output$input_scatter_plot <- renderPlot({
        yacht %>% 
            ggplot(mapping = aes_string(x = input$s_xa,
                                        y = input$s_xb)) +
            geom_point() +
            theme_bw()
    })
    
    ### create reactivity with the observe() via side-effects
    observe({
        a_select <- input$s_xa
        
        b_choices <- input_names[ input_names != a_select ]
        
        updateSelectInput(session,
                          "s_xb",
                          choices = b_choices,
                          selected = b_choices[1])
    })
    
    ### create a reactive variable with the reactive() function
    yacht_for_hist <- reactive({
        function_to_use <- output_transformations %>% 
            purrr::pluck( input$y_warp_radio )
        
        yacht %>% 
            mutate_at(output_names, function_to_use)
    })
    
    ### check to make sure the reactivity works
    output$check_output_transformation <- renderText({
        yacht_for_hist() %>% select(all_of(output_names)) %>% summary()
    })
    
    ### histogram of the response using a user specified transformation
    ### if desired
    output$response_hist <- renderPlot({
        yacht_for_hist() %>% 
            ggplot(mapping = aes_string(x = output_names)) +
            geom_histogram(bins = 21) +
            theme_bw()
    })
    
    ### reactive dataframe for the transformed response for the models
    yacht_for_models <- reactive({
        function_to_use <- output_transformations %>% 
            purrr::pluck( input$warp_output_radio )
        
        yacht %>% 
            mutate_at(output_names, function_to_use)
    })
    
    ### reactively preprocess all variables
    pre_pro <- reactive({
        # input centers and scales
        if( input$stan_input_radio == 'yes' ){
            center_use <- input_centers
            scale_use <- input_scales
        } else {
            center_use <- rep(0, length(input_names))
            scale_use <- rep(1, length(input_names))
        }
        
        # response center and scale
        if( input$stan_output_radio == 'yes' ){
            # pull the potentially transformed response
            yacht_response <- yacht_for_models() %>% 
                select(all_of(output_names)) %>% 
                pull()
            
            output_center <- yacht_response %>% mean()
            output_scale <- yacht_response %>% sd()
        } else {
            output_center <- 0
            output_scale <- 1
        }
        
        center_use <- c( center_use, output_center )
        scale_use <- c( scale_use, output_scale )
        
        list(center = center_use, scale = scale_use )
    })
    
    ### apply the preprocessing to the data
    ready_df <- reactive({
        center_train <- pre_pro() %>% purrr::pluck( 'center' )
        scale_train <- pre_pro() %>% purrr::pluck( 'scale' )
        
        yacht_for_models() %>% 
            scale(center = center_train, scale = scale_train) %>% 
            as.data.frame() %>% tibble::as_tibble()
    })
    
    ### check that the preprocessing works
    output$check_prepro_work <- renderPrint({
        ready_df() %>% summary()
    })
    
    ## fit each model using the prepared data set
    mod_1 <- eventReactive(input$go_models, {
        lm( as.formula(input$formula_1), data = ready_df() )
    })
    
    mod_2 <- eventReactive(input$go_models, {
        lm( as.formula(input$formula_2), data = ready_df() )
    })
    
    mod_3 <- eventReactive(input$go_models, {
        lm( as.formula(input$formula_3), data = ready_df() )
    })
    
    ### visualize the coefficient plot for the 3 models
    output$coefplot_1 <- renderPlot({
        # make sure the model exists
        if( is.null(mod_1()) ){ return() }
        
        # model exists make the plot
        mod_1() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    output$coefplot_2 <- renderPlot({
        # make sure the model exists
        if( is.null(mod_2()) ){ return() }
        
        # model exists make the plot
        mod_2() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    output$coefplot_3 <- renderPlot({
        # make sure the model exists
        if( is.null(mod_3()) ){ return() }
        
        # model exists make the plot
        mod_3() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    ### allow the user to dynamically select the model coefplot to show
    coefplot_to_show <- reactive({
        if(input$show_coefplot == "Model 1") {
            plotOutput("coefplot_1")
        } else if (input$show_coefplot == "Model 2") {
            plotOutput("coefplot_2")
        } else {
            plotOutput("coefplot_3")
        }
    })
    
    output$coefplot_dynamic <- renderUI({
        coefplot_to_show()
    })
    

})
