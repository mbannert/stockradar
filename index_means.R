library(quantmod)

m <- get_stock_matrix(c("TSLA","MSFT","GOOG"))

head(m)





dp <- as_data_frame(d)
out <- dp %>% 
  group_by(month,day) %>% 
  arrange(month,day) %>% 
  summarise_if(is.numeric,mean) 

l <- lapply(out,function(x) na.omit(ma(x,30)))
dygraph(do.call("cbind",l[-c(1:2)]))


plot(l$TSLA.Close)
lines(l$MSFT.Close,col="blue",lty="dashed")

tstools::tsplot(l[-c(1:2)])



# CRAP LINE
# 
# 
# plot(as.xts(ll$`2015`),col = c("black","blue"))
# plot(as.xts(ll$`2016`),col = c("black","blue"))
# 
# dygraph(as.xts(ll$`2015`))
# dygraph(as.xts(ll$`2016`))
# dygraph(as.xts(ll$`2017`))
# 
# 
# head(as.xts(ll$`2015`))
# head(as.xts(ll$`2016`))
# head(as.xts(ll$`2017`))
# 
# 
# 
# 
# plot(ll$`2015`)
# plot(l$`2016`)
# plot(l$`2017`)
