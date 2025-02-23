# PCA-in-Finance
This is a repository of codes exploring the application of PCA in Finance, specifically cryptos.

In this repository, we will be dealing with two main ideas:

1. [Basic analysis of eigenportfolios using R](https://htmlpreview.github.io/?https://github.com/JayQuant/PCA-in-Finance/blob/main/Eigenportfolios_Crypto.html)
2. [Pairs Trading by constructing mean-reverting residuals](https://github.com/JayQuant/PCA-in-Finance/blob/main/PCA_Statarb_IQ.pdf)

In 1., we provide a very basic peek into the concept of eigenportfolios, or eigenfactors, which are statistical factor constructed by applying PCA to the correlation matrix of the returns.

In 2., we will provide a comprehensive, in-depth analysis in dynamic eigenportfolios, constructing mean-reverting residuals by subtracting systematic factors from individual asset returns, and then constructing signals to trade these mean-reverting series. We will be closely replicating the paper written by Avellaneda (2008), but focusing on the practical side.

## Statistical Arbitrage Using PCA
In the `notebooks` directory, `PCA_EDA.ipynb` and `PCA_Backtesting.ipynb` are the notebook files that contain all the work supporting the paper [PCA_statarb](https://github.com/JayQuant/PCA-in-Finance/blob/main/PCA_Statarb_IQ.pdf). While all the required data to run the codes within the notebook are contained in the `data` directory, it is worth mentioning that the two most important data files are:

1. **target_dict.json** : This contains the trading universe based on the date (keyed by dates, values are list of string values). If we want to conduct PCA today to generate signals to trade tomorrow, then we select the trading universe by extracting the appropriate coin list from the `target_dict.json' file.

2. **parent_df.pkl** : Python dataframe saved in pickle format. Easy to load as pandas dataframe object using pickle module. Basically, this contains the price data for *all* coins throughout the *entire* data collection period.

The analysis is divided into 8 sections:

1. PCA and Eigenportfolios
2. Construct Mean Reverting Series
3. Analysis of Mean Reversion Property
4. Generate Signal Lines
5. Backtesting
6. Optimization
7. Results
8. Bonus Strategy

The first notebook `PCA_EDA.ipynb` consists of sections 1 ~ 4, and the second notebook `PCA_Backtesting.ipynb` consists of sections 5 ~ 8. 
