#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

### server function for the yacht lm compare app

shinyServer(function(input, output, session) {

    ### display the variable overview table
    output$tbl_overview <- renderTable({
        var_overview
    },
    striped = TRUE, 
    bordered = TRUE,
    hover = TRUE
    )
    
    ### create the input to input scatter plot
    output$input_scatter_plot <- renderPlot({
        g <- yacht %>% 
            ggplot(mapping = aes_string(x = input$s_xa, y = input$s_xb))
        
        if(input$s_count_button){
            g <- g + geom_count()
        } else {
            g <- g + geom_point()
        }
        
        g + theme_bw() + 
            theme(legend.position = "bottom") +
            guides(size = guide_legend(nrow = 1))
    })
    
    ### use observe() to have the y-axis variable in the input 
    ### scatter plot depend on the selected x-axis variable!
    ### observe() does not create an object, it "watches" and
    ### provides "side-effects"
    ### we will update the choices to s_xb
    observe({
        a_select <- input$s_xa
        
        b_choices <- input_names[ input_names != a_select ]
        
        updateSelectInput(session,
                          "s_xb",
                          choices = b_choices,
                          selected = b_choices[1])
    })
    
    ### check the result of the radio button
    output$check_radio_button <- renderText({
        input$y_warp_radio %>% as.character()
    })
    
    ### to mutate the response we need a reactive variable!!!
    yacht_for_hist <- reactive({
        function_to_use <- output_transformations %>% 
            purrr::pluck( input$y_warp_radio )
        
        yacht %>% 
            mutate_at(output_name, function_to_use)
    })
    
    ### histogram for the output
    output$response_hist <- renderPlot({
        y_lab_use <- output_display_label %>% purrr::pluck( input$y_warp_radio )
        
        yacht_for_hist() %>% 
            ggplot(mapping = aes_string(x = output_name)) +
            geom_histogram(bins = 21) +
            labs(x = y_lab_use) +
            theme_bw()
    })
    
    ### mutate the response if needed for the output-to-input scatter
    yacht_for_scatter <- reactive({
        function_to_use <- output_transformations %>% 
            purrr::pluck( input$scatter_y_warp )
        
        yacht %>% 
            mutate_at(output_name, function_to_use)
    })
    
    ### output to input scatter plot
    output$viz_response_input_scatter <- renderPlot({
        y_lab_use2 <- output_display_label %>% purrr::pluck( input$scatter_y_warp )
        
        yacht_for_scatter() %>% 
            ggplot(mapping = aes_string(x = input$scatter_x, y = output_name)) +
            geom_point() +
            labs(y = y_lab_use2) +
            theme_bw()
    })
    
    ### print the variables names for the user to see
    output$print_varnames <- renderText({
        sprintf("%s,  ", c(input_names, output_name))
    })
    
    ### check the text for model 1's formula
    output$check_mod_formula_1 <- renderText({
        input$formula_1
    })
    
    ### make the data set for modeling with the transformed response
    yacht_for_models <- reactive({
        function_to_use <- output_transformations %>% 
            purrr::pluck( input$warp_output_radio )
        
        yacht %>% 
            mutate_at(output_name, function_to_use)
    })
    
    ### create the data set for training
    
    ### first, need to calculate the center and scales
    pre_pro <- reactive({
        
        if( input$stan_input_radio == 'yes' ){
            center_use <- input_centers
            scale_use <- input_scales
        } else {
            center_use <- rep(0, length(input_names))
            scale_use <- rep(1, length(input_names))
        }
        
        if( input$stan_output_radio == 'yes' ){
            # calculate the potentially transformed mean and sd
            yacht_response <- yacht_for_models() %>% 
                select(all_of(output_name)) %>% 
                pull()
            
            output_center <- yacht_response %>% mean()
            output_scale <- yacht_response %>% sd()
            
            center_use <- c( center_use, output_center )
            scale_use <- c( scale_use, output_scale )
        } else {
            # not standardizing the response
            center_use <- c( center_use, 0 )
            scale_use <- c( scale_use, 1 )
        }
        
        list(center = center_use, scale = scale_use)
    })
    
    ### preprocess the training set as required
    ready_df <- reactive({
        center_train <- pre_pro() %>% purrr::pluck("center")
        scale_train <- pre_pro() %>% purrr::pluck("scale")
        
        yacht_for_models() %>% 
            scale(center = center_train, scale = scale_train) %>% 
            as.data.frame() %>% tibble::as_tibble()
    })
    
    ### check the standardization has been correctly applied
    output$check_prepro_work <- renderPrint({
        ready_df() %>% summary()
    })
    
    ### fit each model with the prepared data set
    mod_1 <- eventReactive(input$go_models, {
        lm(as.formula(input$formula_1), data = ready_df())
    })
    
    mod_2 <- eventReactive(input$go_models, {
        lm(as.formula(input$formula_2), data = ready_df())
    })
    
    mod_3 <- eventReactive(input$go_models, {
        lm(as.formula(input$formula_3), data = ready_df())
    })
    
    ### coefplots for each model
    output$coefplot_1 <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        # model exists make the plot
        mod_1() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    output$coefplot_2 <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_2()) ){ return() }
        
        # model exists make the plot
        mod_2() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    output$coefplot_3 <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_3()) ){ return() }
        
        # model exists make the plot
        mod_3() %>% 
            coefplot() +
            theme_bw() +
            guides(color = 'none', linetype = 'none', shape='none')
    })
    
    ### instead show how to allow the user to dynamically select the plot!!!
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
    
    ### use multiplot to show all models together
    output$coefplot_multiplot <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        multiplot(mod_1(), mod_2(), mod_3(),
                  names = as.character(1:3)) + 
            theme_bw()
    })
    
    ### combine all models together to visualize residuals via facets
    train_result_df <- reactive({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        mod_1() %>% 
            my_train_augment(train_data = ready_df()) %>% 
            mutate(model_name = "Model 1") %>% 
            tibble::rowid_to_column() %>% 
            bind_rows(mod_2() %>% 
                          my_train_augment(train_data = ready_df()) %>% 
                          mutate(model_name = "Model 2") %>% 
                          tibble::rowid_to_column()) %>% 
            bind_rows(mod_3() %>% 
                          my_train_augment(train_data = ready_df()) %>% 
                          mutate(model_name = "Model 3") %>% 
                          tibble::rowid_to_column())
    })
    
    ### check the names of the columns in the agumented training set
    output$check_augment_train_df <- renderPrint({
        train_result_df() %>% glimpse()
    })
    
    ### visualize the residuals with respect to an input
    output$viz_resid_input_scatter <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        train_result_df() %>% 
            ggplot(mapping = aes_string(x = input$resid_x_view, y = ".resid")) +
            geom_point() +
            geom_hline(yintercept = 0, color = 'red', linetype='dashed') +
            facet_grid( . ~ model_name) +
            labs(y = "residual") +
            theme_bw()
    })
    
    ### visualize the predicted-vs-observed figure
    output$viz_pred_vs_obs <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        train_result_df() %>% 
            ggplot(mapping = aes_string(x = output_name)) +
            geom_linerange(mapping = aes(ymin = pred_lwr,
                                         ymax = pred_upr,
                                         group = interaction(model_name, rowid)),
                           color = 'darkorange',
                           size = 1.) +
            geom_linerange(mapping = aes(ymin = conf_lwr,
                                         ymax = conf_upr,
                                         group = interaction(model_name, rowid)),
                           color = 'grey50',
                           size = 1.1) +
            geom_point(mapping = aes(y = .fitted),
                       color = 'black') +
            geom_abline(slope = 1, intercept = 0,
                        color = 'red', linetype = 'dashed',
                        size = 1.15) +
            facet_grid( . ~ model_name) +
            labs(x = output_name, y = "model fitted values") +
            theme_bw()
    })
    
    ### use broom to get the training set performance metrics
    train_perform_metrics <- reactive({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        mod_1() %>% 
            broom::glance() %>% 
            mutate(model_name = "Model 1") %>% 
            bind_rows(mod_2() %>% 
                          broom::glance() %>% 
                          mutate(model_name = "Model 2")) %>% 
            bind_rows(mod_3() %>% 
                          broom::glance() %>% 
                          mutate(model_name = "Model 3"))
    })
    
    ### visualize the r-squared per model
    output$viz_r2_model <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        train_perform_metrics() %>% 
            ggplot(mapping = aes(x = model_name, y = r.squared)) +
            geom_point(size = 5.5) +
            labs(x = "", y = "R-squared") +
            theme_bw()
    })
    
    ### calculate the RMSE per model manually and visualize
    output$viz_rmse_model <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        train_result_df() %>% 
            mutate(sq_error = .resid^2) %>% 
            group_by(model_name) %>% 
            summarise(rmse = sqrt( mean( sq_error ) )) %>% 
            ungroup() %>% 
            ggplot(mapping = aes(x = model_name, y = rmse)) +
            geom_point(size = 5.5) +
            labs(x = "", y = "RMSE") +
            theme_bw()
    })
    
    ### visualize the AIC/BIC per model
    output$viz_aic_bic_model <- renderPlot({
        # make sure the model exists!
        if( is.null(mod_1()) ){ return() }
        
        train_perform_metrics() %>% 
            select(model_name, AIC, BIC) %>% 
            tibble::rowid_to_column() %>% 
            pivot_longer(!c("rowid", "model_name")) %>% 
            ggplot(mapping = aes(x = model_name, y = value)) +
            geom_point(size = 5.5) +
            facet_wrap(~name, scales = "free_y") +
            labs(x = "", y = "AIC/BIC") +
            theme_bw()
    })
    
    ### create the prediction input grid
    viz_grid <- reactive({
        purrr::map(input_names,
                   make_one_vector_for_grid,
                   x_var = input$viz_x_var,
                   facet_var = input$viz_facet_var,
                   num_facets = as.numeric(input$viz_num_facets),
                   quant_use = as.numeric(input$viz_quant_use)) %>% 
            expand.grid(KEEP.OUT.ATTRS = FALSE,
                        stringsAsFactors = FALSE) %>% 
            purrr::set_names(input_names) %>% 
            as.data.frame() %>% 
            tibble::as_tibble()
    })
    
    ### correctly preprocess the input prediction grid
    ready_viz_df <- reactive({
        # the output is the last element in the vectors
        center_train <- pre_pro() %>% purrr::pluck("center")
        scale_train <- pre_pro() %>% purrr::pluck("scale")
        
        center_train <- center_train[-length(center_train)]
        scale_train <- scale_train[-length(scale_train)]
        
        # standardize the prediction grid
        viz_grid() %>% 
            scale(center = center_train, scale = scale_train) %>% 
            as.data.frame() %>% tibble::as_tibble()
    })
    
    ### use observe() to make sure the prediction tab facet variable
    ### is NEVER the input grid variable
    observe({
        x_axis_select <- input$viz_x_var
        
        facet_choices <- input_names[ input_names != x_axis_select ]
        
        updateSelectInput(session,
                          "viz_facet_var",
                          choices = facet_choices,
                          selected = facet_choices[1])
    })
    
    ### make predictions using the default prediction grid
    viz_result_df <- reactive({
        # make sure the model exists!
        if( is.null(mod_1()) | is.null(mod_2()) | is.null(mod_3()) ){ return() }
        
        mod_1() %>% 
            my_viz_augment(viz_data = ready_viz_df()) %>% 
            mutate(Model = "1") %>% 
            select(Model, pred_value = .fitted, 
                   starts_with("conf_"),
                   starts_with("pred_")) %>% 
            tibble::rowid_to_column() %>% 
            bind_rows(mod_2() %>% 
                          my_viz_augment(viz_data = ready_viz_df()) %>% 
                          mutate(Model = "2") %>% 
                          select(Model, pred_value = .fitted, 
                                 starts_with("conf_"),
                                 starts_with("pred_")) %>% 
                          tibble::rowid_to_column()) %>% 
            bind_rows(mod_3() %>% 
                          my_viz_augment(viz_data = ready_viz_df()) %>% 
                          mutate(Model = "3") %>% 
                          select(Model, pred_value = .fitted, 
                                 starts_with("conf_"),
                                 starts_with("pred_")) %>% 
                          tibble::rowid_to_column()) %>% 
            left_join(viz_grid() %>% 
                          tibble::rowid_to_column(),
                      by = "rowid")
    })
    
    ### undo the standardization of the response predictions
    viz_result_ready_df <- reactive({
        # make sure the predictions exists!
        if( is.null(viz_result_df()) ){ return() }
        
        # the output is the last element in the vectors
        center_train <- pre_pro() %>% purrr::pluck("center")
        scale_train <- pre_pro() %>% purrr::pluck("scale")
        
        center_train <- center_train[length(center_train)]
        scale_train <- scale_train[length(scale_train)]
        
        viz_result_df() %>% 
            mutate_at(c("pred_value", 
                        "conf_lwr", "conf_upr",
                        "pred_lwr", "pred_upr"),
                      undo_stan,
                      m = center_train,
                      s = scale_train)
    })
    
    ### visualize the default prediction grid
    output$viz_default_pred <- renderPlot({
        if(is.null(viz_result_ready_df())){ return() }
        
        g4 <- viz_result_ready_df() %>% 
            ggplot(mapping = aes_string(x = input$viz_x_var)) +
            geom_ribbon(mapping = aes(ymin = pred_lwr,
                                      ymax = pred_upr),
                        fill = 'darkorange') +
            geom_ribbon(mapping = aes(ymin = conf_lwr,
                                      ymax = conf_upr),
                        fill = 'grey50') +
            geom_line(mapping = aes(y = pred_value),
                      color = 'black', size = 1.1) +
            facet_grid( as.formula(sprintf("%s ~ Model", input$viz_facet_var)), 
                        labeller = "label_both") +
            labs(y = "model prediction") +
            theme_bw()
        
        # add in the training set on top of the predictions
        if(input$viz_add_train_radio == 'yes'){
            g4 <- g4 + 
                geom_point(data = yacht_for_models() %>% 
                               select(all_of(c(input$viz_x_var, output_name))),
                           mapping = aes_string(x = input$viz_x_var, 
                                                y = output_name))
        }
        
        g4
    })
    

})
