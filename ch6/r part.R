library(here)
library(data.table)

# AR
## simulação

simulate_ar <-function(theta0, theta, n = 100){
  result <- vector("double", n)
  mu <-  theta0 / (1 - sum(theta))
  p <- length(theta)
  
  for(i in seq_len(p)){
    result[[i]] <- mu
  }
  
  for(i in seq_len(n - p) + p){
    result[[i]] <- theta0 + sum(result[(i - p):(i - 1)] * theta) + rnorm(1)
  }
  
  result
}

simulated_ar <- simulate_ar(1, c(.5, .4, -.3, .2), n=100)
plot(simulated_ar, type='l')

acf(simulated_ar)
pacf(simulated_ar)

simulate_ma <-function(mu, theta, n = 100){
  result <- vector("double", n)
  errors <- runif(n,-1,1)
  p <- length(theta)
  
  result[0:p] <- errors[0:p] + mu
  
  for(i in seq_len(n - p) + p){
    result[[i]] <- sum(errors[(i - p):(i - 1)] * theta) + errors[i] + mu
  }
  
  result
}

simulated_ma <- simulate_ma(1, c(.5), n=100)
plot(simulated_ma, type='l')

acf(simulated_ma)
pacf(simulated_ma)

## dados reais
path <- here("ch6", "data", "Daily_Demand_Forecasting_Orders.csv")

demand <- fread(path)

plot(demand[['Banking orders (2)']], type='l')

pacf(demand[['Banking orders (2)']])

fit <- ar(demand[['Banking orders (2)']], method='mle')
fit


est <- arima(x=demand[['Banking orders (2)']],
             order = c(3,0,0))
est

est.1 <- arima(x=demand[['Banking orders (2)']],
               order = c(3,0,0),
               fixed = c(0, NA, NA, NA),
               transform.pars = FALSE)
est.1

acf(est.1 $ residuals)

Box.test(est.1 $ residuals, lag = 10, type="Ljung", fitdf = 3)

### Previsão
require(forecast)
plot(x=demand[['Banking orders (2)']], type='l')
preds = fitted(est.1)
lines(preds, col=3, lwd=1, lty = 2)

cor(demand[['Banking orders (2)']], preds)

plot(demand[['Banking orders (2)']], preds)

plot(diff(demand[['Banking orders (2)']]), diff(preds))

fitted(est.1, h=3)

## MA
acf(demand[['Banking orders (2)']])

ma.est = arima(x = demand[['Banking orders (2)']],
               order = c(0,0,9),
               fixed = c(0,0,NA,rep(0, 5), NA, NA))

ma.est

acf(ma.est $ residuals)

fitted(ma.est, h=1)

est = auto.arima(demand[['Banking orders (2)']],
                 stepwise = FALSE,
                 max.p = 3, max.q = 9)
est

plot(demand[['Banking orders (2)']], type='l')
lines(fitted(est.1, h=1))

acf(est $ residuals)
pacf(est $ residuals)

## VAR
library(vars)

VARselect(demand[, 11:12, with=FALSE], lag.max=4, type='const')

est.var <- VAR(demand[, 11:12, with=FALSE], p=3, type='const')
est.var

par(mfrow=c(2,1))
plot(demand[['Banking orders (2)']], type='l', ylab="dado 1")
lines(fitted(est.var)[,1], col=2)
plot(demand[['Banking orders (3)']], type='l', ylab="dado 2")
lines(fitted(est.var)[,2], col=2)

par(mfrow=c(2,1))
acf(demand[['Banking orders (2)']] - fitted(est.var)[,1])
acf(demand[['Banking orders (3)']] - fitted(est.var)[,2])

serial.test(est.var, lags.pt=8, type="PT.asymptotic")
