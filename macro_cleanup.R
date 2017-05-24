setwd("~/Kaggle/Sberbank")
macro <- read.csv("macro.csv", header = TRUE)

head(macro)
summary(macro)

# run VIF function over macro dataset to eliminate features that inflate variance and display high multicollinearity 
# https://www.kaggle.com/robertoruiz/dealing-with-multicollinearity
# best indepent set of features chosen:

my_macro_vars <- c('timestamp',
 'balance_trade',
 'balance_trade_growth',
 'eurrub',
 'average_provision_of_build_contract',
 'micex_rgbi_tr',
 'micex_cbi_tr',
 'deposits_rate',
 'mortgage_value',
 'mortgage_rate',
 'income_per_cap',
 'rent_price_4.room_bus',
 'museum_visitis_per_100_cap',
 'bandwidth_sports',
 'apartment_build'
)

macro_vars <- macro[,my_macro_vars]

summary(macro_vars)

#write.csv(macro_vars, file = "macro_vars.csv")

#explore csv to decide what to do with NA values. could use mean, median, or impute another value depending on nature of feature

#visualize the Missing Values using the Amelia package

library(Amelia)
missmap(macro_vars[-1], col=c('grey', 'steelblue'), y.cex=0.2, x.cex=0.5)

sort(sapply(macro_vars[-1], function(x) { sum(is.na(x)) }), decreasing=TRUE)

#use mice package to impute data values to NA 
library(mice)
imp.macro_vars <- mice(macro_vars, m=1, method='fastpmm', maxit = 3, printFlag=TRUE)

#??mice
# check performance 
