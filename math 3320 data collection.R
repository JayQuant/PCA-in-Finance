## Install package
install.packages("crypto2")

## load library
library(crypto2)
library(tidyverse)
library(httr)
library(RSelenium)

## Test

# List all active coins
coins <- crypto_list(only_active = TRUE)
coins_top <- subset(coins, rank <53)
coins_top <- coins_top[order(coins_top$rank, decreasing = FALSE),]

# Retrieve info 
coin_info <- crypto_info(coins_top, finalWait=FALSE)

# Retrieve historical data
coin_hist <- crypto_history(coin_info, start_date = "20201117", end_date = "20231117", fin)


### Beware codes are all failures ...

## scraping coinmarketcap webpage
library(rvest)
library(tidyverse)

url <- "https://coinmarketcap.com/"
webpage <- read_html(url)
table <- webpage %>% html_element("table.cmc-table") %>% html_table()

library(rvest)
library(dplyr)

url <- "https://coinmarketcap.com/"
webpage <- read_html(url)

# Extracting each column
rank_column <- webpage %>% html_nodes("p.sc-4984dd93-0.iWSjWE") %>% html_text()
name_column <- webpage %>% html_nodes("div.sc-aef7b723-0.sc-adbfcfff-1.klolJt p") %>% html_text()
price_column <- webpage %>% html_nodes("div.sc-a0353bbc-0.gDrtaY") %>% html_text()

# Combine into a dataframe
data <- data.frame(Rank = rank_column, Name = name_column, Price = price_column)

# Viewing the first few rows of the dataframe
head(data)

library(rvest)
library(dplyr)

url <- "https://coinmarketcap.com/"
webpage <- read_html(url)

# Extracting the market cap data
market_cap_nodes <- webpage %>% html_nodes("p.sc-4984dd93-0.jZrMxO")
market_cap_text <- market_cap_nodes %>% html_text()

# Extracting detailed market cap values
detailed_market_cap <- market_cap_nodes %>% 
  html_nodes("span.sc-7bc56c81-1.bCdPBp") %>%
  html_text()

# Create a dataframe (if you want to combine it with other data)
data <- data.frame(MarketCap = market_cap_text, DetailedMarketCap = detailed_market_cap)

# Viewing the first few rows of the dataframe
head(data)

## Using R selenium
url<- "https://coinmarketcap.com/currencies/bitcoin/historical-data/"

# RSelenium with Firefox
rD <- rsDriver(browser="chrome", port=4545L, chromever = NULL)
remDr <- rD[["client"]]
remDr$navigate(url)
Sys.sleep(4)

# get the page source
web <- remDr$getPageSource()
web <- xml2::read_html(web[[1]])

table <- html_table(web) %>%
  as.data.frame()

# close RSelenium
remDr$close()
gc()
rD$server$stop()
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


## Coingecko
url2 <- "https://api.coingecko.com/api/v3/coins/bitcoin/tickers"
Exchanges <- GET(url)
araw_data <- fromJSON(content(Exchanges, as = "text",encoding = "UTF-8"))
araw_data$tickers$market %>% select(name) %>% pull

## Coinmarketcapr
install.packages("coinmarketcapr")
library(coinmarketcapr)
latest_marketcap <- get_global_marketcap('USD')
all_coins <- get_marketcap_ticker_all()
all_coins
