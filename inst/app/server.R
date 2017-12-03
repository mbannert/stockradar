library(shiny)
shinyServer(function(input,output){
  
  dta <- eventReactive(input$searchButton,{
    srch <- unlist(strsplit(input$searchText,","))
    smat <- get_stock_matrix(srch,
                             src = input$src,
                             start = input$start_date,
                             end = input$end_date,
                             metric = input$metric)
    if(input$idx) smat <- create_index(smat)
    smat
  })
  
  output$stockchart <- renderDygraph({
    if(is.null(dta())) return(NULL)
    dygraph(dta())
  })
  
  
    
})
