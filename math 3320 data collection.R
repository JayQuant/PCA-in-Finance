## Install package
install.packages("crypto2")

## load library
library(crypto2)


# List all active coins
coins <- crypto_list(only_active = TRUE)
coins_top <- subset(coins, rank <53)
coins_top <- coins_top[order(coins_top$rank, decreasing = FALSE),]

# Retrieve info 
coin_info <- crypto_info(coins_top, finalWait=FALSE)

# Retrieve historical data
coin_hist <- crypto_history(coin_info, start_date = "20201117", end_date = "20231117", fin)


