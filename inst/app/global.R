library(shiny)
library(shinydashboard)
library(quantmod)
library(dygraphs)


# Function definitions ###################
get_stock_matrix <- function(ti_symbols = c("AAPL",
                                            "MSFT",
                                            "GOOG"),
                             src = "yahoo",
                             start = "2015-01-01",
                             end = Sys.Date(),
                             metric = ".Close"){
  stock_env <- new.env()
  start <- as.Date(start)
  end <- as.Date(end)
  
  
  
  getSymbols(ti_symbols, src = src,
             from = start, to = end,
             env = stock_env)
  
  stock_l <- as.list(stock_env)
  stock_l <- lapply(ti_symbols, function(x){
    sel_metric <- paste0(x,metric)
    stock_l[[x]][,sel_metric]
  })
  
  # return a matrix of stocks
  # which can easily be converted to xts
  as.matrix(as.xts(do.call("cbind",stock_l)))
}



create_index <- function(xts_mat,base_period = 1,
                         times = 100){
  out <- t(t(xts_mat) / xts_mat[base_period,])
  if(!is.null(times)) out <- out * times
  out
}
