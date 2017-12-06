library(quantmod)

m <- get_stock_matrix(c("TSLA","MSFT"))


d <- as.data.frame(m)
d$year <- format(as.Date(rownames(d)),"%Y")
by_year <- split(d,f = d$year)
l <- lapply(by_year, function(x) as.matrix(as.xts(x[,-3])))
ll <- lapply(l,create_index)
tt <- do.call("rbind",ll)




d <- as.data.frame(tt)
d$year <- format(as.Date(rownames(d)),"%Y")
d$month <- as.numeric(format(as.Date(rownames(d)),"%m"))
d$day <- as.numeric(format(as.Date(rownames(d)),"%d"))

library(dplyr)

dp <- as_data_frame(d)

out <- dp %>% 
  select(-TSLA.Close) %>% 
  group_by(month,day) %>% 
  summarise(MSFT.mean = mean(MSFT.Close)) %>% 
  arrange(month,day)

plot(out$MSFT.mean,type="l")

head(ll$`2015`)
head(ll$`2016`)
head(ll$`2017`)





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
