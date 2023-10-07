# PURPOSE: Example script to get daily stock prices from yahoo finance
# https://business-science.github.io/tidyquant/reference/tq_get.html

# Access packages ---------------------------------------------------------

library(tidyverse)
library(tidyquant)
library(Quandl)



msft <- tq_get("MSFT", "stock.prices", from = "2023-09-01",to = "2023-10-02")










#grab a bunch of data. 
sp500 <- tq_index("SP500")
djia <- tq_index("DOW")
dowglobal <- tq_index("DOWGLOBAL")
sp400 <- tq_index("SP400")


combined <- rbind(sp500, djia, dowglobal, sp400)

rm(sp500, djia, dowglobal, sp400)

combined <- combined %>% distinct(symbol, company, identifier, sedol, sector, local_currency)


stocks.prices <- combined$symbol %>% 
  tq_get(get  = "stock.prices",from = "2023-09-01",to = "2023-10-02") %>%
  group_by(symbol)

financials.values <- combined$symbol %>% 
  tq_get(get  = "financials",from = "2000-01-01",to = "2023-10-02") %>%
  group_by(symbol)

key.ratios <- combined$symbol %>% 
  tq_get(get  = "key.ratios",from = "2000-01-01",to = "2023-10-02") %>%
  group_by(symbol)

dividends <- combined$symbol %>% 
  tq_get(get  = "dividends",from = "2000-01-01",to = "2023-10-02") %>%
  group_by(symbol)

write.csv(stocks.prices, "stock_prices.csv")
write.csv(financials.values, "financials.csv")
write.csv(key.ratios, "key_ratios.csv")