## Import libraries
library(tidyverse)
library(quantmod)
library(tidyquant)
library(PerformanceAnalytics)

## Import Data
data_raw <- read.csv("daily crypto data UTC.csv")

## Store data in list

# Drop unnecessary rows
data_v1 <- data_raw %>% transmute(timestamp, name, symbol, close, volume, market_cap)

# Split data by symbol
data_split <- split(data_v1, data_raw$symbol)
data_split %>% length()

data_split[5] %>% names()

## Excluding coins by marketcap of starting date

# Count observations for each cryptocurrency
count_df <- data.frame(symbol = character(), count = numeric())
for (i in 1:length(data_split)) {
  name = names(data_split[i])
  number_of_observations = nrow(data_split[[i]])
  count_df = rbind(count_df, data.frame(symbol = name, count = number_of_observations))
}

count_df

# Select coins with not enough data
symbols_excluded <- count_df[count_df$count < 1095,]$symbol

# Check market cap for beginning period

first_non_zero_marketcap <- lapply(data_split, function(df) {
  # Find indices of non-zero marketcap
  non_zero_indices <- which(df$market_cap != 0)
  
  # Get the first non-zero marketcap, if available
  if (length(non_zero_indices) > 0) {
    first_non_zero <- df$market_cap[min(non_zero_indices)]
  } else {
    first_non_zero <- NA  # Assign NA if there are no non-zero values
  }
  
  return(first_non_zero)
})

# Optionally, to create a named vector
names(first_non_zero_marketcap) <- names(data_split)

# Output the results
first_non_zero_marketcap 

# Convert the list to a dataframe
market_cap_df <- data.frame(symbol = names(first_non_zero_marketcap), mktcap = unlist(first_non_zero_marketcap))
market_cap_df <- market_cap_df[market_cap_df$mktcap %>% order(),]
market_cap_df

# Exclude symbols with not enough data & exclude stable coins & SHIB
market_cap_df_processed <- market_cap_df[!market_cap_df$symbol %in% symbols_excluded,] 
stable_symb <- c("TUSD", "BUSD", "DAI", "USDT", "USDC", "SHIB")
marketcap_df_processed_v2 <- market_cap_df_processed[!market_cap_df_processed$symbol %in% stable_symb,]


# Threshold: More than 50 million USD 3 years ago 
marketcap_df_processed_v3 <- marketcap_df_processed_v2[marketcap_df_processed_v2$mktcap > 50000000,]
nrow(marketcap_df_processed_v3)

## Extract necessary symbol and price data from list
extract_symbols <- marketcap_df_processed_v3$symbol
data_split_processed <- data_split[extract_symbols]

## Change dataframe elements such that you have coin name for column name of closing price, then delete rest of columns

# Use map2 to iterate over both the list and the names of the list
data_split_processed_v2 <- map2(data_split_processed, names(data_split_processed), ~ {
  # Rename the 'close' column to the name of the data frame
  renamed_df <- .x %>% 
    rename(!! .y := close) %>%
    select(-name, -symbol, -volume, -market_cap)
  
  return(renamed_df)
})


## Unlist and then combine into one big dataframe
Price_dt <- reduce(data_split_processed_v2, function(x , y) {
  left_join(x, y, by = "timestamp")
})

Price_dt %>% tail()
Price_dt %>% str()

## Convert to xts object and then return series
price_dt_v2 <- Price_dt %>%
  mutate(Date = as.POSIXct(timestamp, format = "%Y-%m-%d %H:%M:%S"))

price_dt_v3 <- xts(x = price_dt_v2[,-1], order.by = price_dt_v2$Date)

# Change character value to numeric value 
price_matrix <- coredata(price_dt_v3) %>% as_tibble()
price_matrix <- price_matrix %>% mutate(across(everything(), as.numeric)) %>% select(-Date)
price_matrix %>% is.na %>% sum()

price_dt_v4 <- xts(x = price_matrix, order.by = index(price_dt_v3))
ret_dt <- price_dt_v4 %>% log() %>% diff() 
ret_dt <- ret_dt[-1,]
ret_dt %>% head()

ret_df <- ret_dt %>% as.tibble %>% mutate(Date = index(ret_dt)) %>% select(Date, everything())

# Save as csv file
write.csv(ret_df, "Crypto_Daily Return Series.csv")


