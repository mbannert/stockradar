library(shiny)
library(shinydashboard)
library(quantmod)
library(dygraphs)
library(dplyr)


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

ma <- function(x,n=5){stats::filter(x,rep(1/n,n), sides=2)}

create_ma_comp <- function(mat,wdw){
  d <- as.data.frame(mat)
  d$year <- format(as.Date(rownames(d)),"%Y")
  by_year <- split(d,f = d$year)
  l <- lapply(by_year, function(x){
    y_pos <- grep("year",names(by_year[[1]]))
    as.matrix(as.xts(x[,-y_pos]))
  })
  ll <- lapply(l,create_index)
  tt <- do.call("rbind",ll)
  
  d <- as.data.frame(tt)
  d$year <- format(as.Date(rownames(d)),"%Y")
  d$month <- as.numeric(format(as.Date(rownames(d)),"%m"))
  d$day <- as.numeric(format(as.Date(rownames(d)),"%d"))
  
  dp <- as_data_frame(d)
  out <- dp %>% 
    group_by(month,day) %>% 
    arrange(month,day) %>% 
    summarise_if(is.numeric,mean) 
  
  l <- lapply(out,function(x) na.omit(ma(x,wdw)))
  do.call("cbind",l[-c(1:2)])
}




