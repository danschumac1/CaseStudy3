rm(list = ls())

library(tidyverse)
library(lubridate)

df = read_csv("./data/Texas_COVID_data.csv")
str(df)

y = df$`Cumulative
Cases`

day = seq(from = 1, to = dim(df)[1], by = 1)
df = cbind(day, df)

#make a time-series plot
plot(y, ylab = "Number of COVID-19 cases in Texas", 
xlab = "Days since March 3, 2020", pch = ".")

#build a trend model
m1 = lm(y ~ day - 1)
summary(m1)
preds = predict(m1, type = "response")

#make a plot with actual and predicted data
plot(y, ylab = "Number of COVID-19 cases in Texas", xlab = "Days since March 3, 2020", pch = ".")
points(preds, col="red", pch=".")

#make multiple lagged plots to see correlation
lag.plot(y, pch = ".", set.lags = 1:4)

m2 = lm(y ~ lag(y, n = 1) - 1)
summary(m2)
preds_ar = predict(m2, type = "response")
#make a plot with actual and predicted data
plot(y, ylab = "Number of COVID-19 cases in Texas", xlab = "Days since March 4, 2020", pch = ".")
points(preds, col="red", pch=".")
points(preds_ar, col="blue", pch=".")

#Measures
ydat = cbind(y[3:length(y)], preds_ar[2:length(preds_ar)]) #making two columns: actual y and predicted y. 
# Starts from day 3 (non-zero)

#compute MSE, ME, MAE, MAPE
mse = mean((ydat[,1] - ydat[,2])^2)
mae = mean(abs(ydat[,1] - ydat[,2]))
me = mean(ydat[,1] - ydat[,2])
mape = mean(abs(ydat[,1] - ydat[,2])*100/ydat[,1])

#compute moving average
k_minus1 = 4
moving = mean(y[(length(y)-k_minus1):(length(y))])

#computing exponential smoothing forecast using alpha  = 0.3
moving_pre = mean(y[(length(y)-1-k_minus1):(length(y)-1)])
expo = 0.3*y[length(y)] + 0.7*moving_pre

#computing exponential smoothing forecast using alpha  = 0.7
expo = 0.7*y[length(y)] + 0.3*moving_pre
