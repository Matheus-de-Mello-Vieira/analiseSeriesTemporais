plot(EuStockMarkets)

frequency(EuStockMarkets)

start(EuStockMarkets)
end(EuStockMarkets)

window(EuStockMarkets, start=1997, end=1998)

plot(EuStockMarkets[,"SMI"])

hist(EuStockMarkets[,"SMI"], 30)

hist(diff(EuStockMarkets[,"SMI"]), 30)

plot(EuStockMarkets[,"SMI"], EuStockMarkets[,"DAX"])

plot(diff(EuStockMarkets[,"SMI"]), diff(EuStockMarkets[,"DAX"]))

plot(lag(diff(EuStockMarkets[,"SMI"]), 1),
         diff(EuStockMarkets[,"DAX"]))

## Janela rolante ===========
# Média móvel usando a base do R.
x <- rnorm(n=100, mean=0, sd=10) + 1:100
mn <- function(n) rep(1/n, n)

plot(x, type='l',               lwd=1)
lines(filter(x, mn( 5)), col=2, lwd=3, lty=2)
lines(filter(x, mn(50)), col=3, lwd=3, lty=3)

# funções customizadas não lineares
library(zoo)
f1 <- rollapply(zoo(x), 20, function(w) min(w), align="left", partial=TRUE)
f2 <- rollapply(zoo(x), 20, function(w) min(w), align="right", partial=TRUE)

plot(x, lwd=1, type='l')
lines(f1, col=2, lwd=3, lty=2)
lines(f2, col=2, lwd=3, lty=3)

plot(x, type='l', lwd=1)
lines(cummax(x), col = 2, lwd = 3, lty = 2)
lines(cumsum(x)/seq_along(x), col = 3, lwd = 3, lty = 3)

plot(x, type='l', lwd=1)
lines(rollapply(zoo(x), seq_along(x), function(w) max(w), partial=TRUE,
                align='right'),
      col=2, lwd=3, lty=3)
lines(rollapply(zoo(x), seq_along(x), function(w) mean(w), partial=TRUE,
                align='right'), col=2, lwd=3, lty=3)

## Função de autocorrelação ===============
library(data.table)
x <- 1:30
y <- sin(x * pi / 3)
plot(y, type='b')
acf(y)

# autocorrelação de séries estácionárias
white.noise = rnorm(100)
acf(white.noise)

cor(y, shift(y, 1), use="pairwise.complete.obs")
cor(y, shift(y, 2), use="pairwise.complete.obs")
cor(y, shift(y, pi), use="pairwise.complete.obs")

plot(y[1:30], type='b')
pacf(y)

y1 <- sin(x * pi / 3)
plot(y1, type='b')
acf(y1)
pacf(y1)

y2 <- sin(x * pi / 10)
plot(y2, type='b')
acf(y2)
pacf(y2)

y <- y1 + y2
plot(y, type="b")
acf(y)
pacf(y)

x <- 1:1000
plot(x)
acf(x, demean = FALSE)
pacf(x)

# Visualizações ===================
## 1D ==============
require(data.table)
require(timevis)
donations <- fread("ch2/data/donations.csv")
d <- donations[, .(min(timestamp), max(timestamp)), user]
names(d) <- c("content", "start", "end")
d <- d[start != end]
timevis(d[sample(1:nrow(d), 10)])

## 2D ==============
AirPassengers

### Gráfico sazonal
colors <- c("green", "red", "pink", "blue", "yellow", "lightsalmon",
            "black", "gray", "cyan", "lightblue", "maroon", "purple")
matplot(matrix(AirPassengers, nrow = 12, ncol = 12),
        type='l', col=colors, lty = 1, lwd = 2.5, cex=1,
        xaxt = 'n', ylab = "Passenger Count")
legend("topleft", legend=1949:1960, col=colors, lty=1, lwd=2.5, xpd=TRUE, cex=0.5)
axis(1, at=1:12, labels = c("Jan", "Feb", "Mar", "Apr",
                            "May", "Jun", "Jul", "Aug",
                            "Sep", "Oct", "Nov", "Dec"))
### Grafico mensal
require(forecast)
seasonplot(AirPassengers)

months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
matplot(t(matrix(AirPassengers, nrow = 12, ncol = 12)),
        type='l', col=colors, lty=1, lwd=2.5)
legend('topleft', legend = months, col=colors,
       lty=1, lwd=2.5, cex=0.5)


monthplot(AirPassengers)

### histograma bidimensional =============
binsValues <- function(data, nbins.y) {
  ## Fazemos ybins com espaçamento uniforme
  ## para incluir pontos mínimos e máximos
  ymin = min(data)
  ymax = max(data) * 1.0001
  ## Saída lazy para evitar a preocupação com inclusão/exclusão
  
  seq(from = ymin, to = ymax, length.out = nbins.y + 1)
}


hist2d <- function(data, ybins) {
  hist.matrix = matrix(0, nrow = length(ybins) - 1, ncol = ncol(data))
  
  for(i in 1:nrow(data)){
    ts = findInterval(data[i,], ybins)
    for(j in 1:ncol(data)){
      hist.matrix[ts[j], j] = hist.matrix[ts[j], j] + 1
    }
  }
  
  hist.matrix
}

transposed.AirPassengers <-  t(matrix(AirPassengers, nrow = 12, ncol = 12))
ybins <-binsValues(transposed.AirPassengers, 5)
h = hist2d(transposed.AirPassengers, ybins)
image(1:ncol(h), 1:nrow(h), t(h[rev(seq_len(5)),]), col=heat.colors(5),
      axes=FALSE, xlab="Time", ylab="Passenger Count")
axis(1, at=1:12, labels=1949:1960, las=2, tick = FALSE, pos=0.9)
axis(2, at=0:5 + .5, labels=round(ybins), las=1)


require(data.table)
words <- fread("ch3/data/50words_TEST.csv")

w1 <- words[V1==1]

matplot(w1, type='l', ylab = '')

ybins <-binsValues(w1, 25)
h = hist2d(w1, ybins)

colors <- gray.colors(20, start = 1, end= .5)
par(mfrow = c(1,2))
image(1:ncol(h), 1:nrow(h), t(h),
      col = colors, axes=FALSE, xlab="Time", ylab = "Projection Value")
image(1:ncol(h), 1:nrow(h), t(log(h)),
      col = colors, axes=FALSE, xlab="Time", ylab = "Projection Value")

require(hexbin)
w1 <- words[V1==1]
names(w1) <- c("type", 1:270)
w1 <- melt(w1, id.vars = "type")
w1 <- w1[, -1]
plot(hexbin(w1))

## Visualização 3d =======================
require(plotly)
require(data.table)

months = 1:12
ap = data.table(matrix(AirPassengers, nrow=12, ncol=12))
names(ap) = as.character(1949:1960)
ap[,month := months]
ap = melt(ap, id.vars='month')
names(ap) = c("month", "year", "count")

p <- plot_ly(ap, x=~month, y=~year, z=~count,
             color=~as.factor(month)) %>%
  add_markers() %>%
  layout(scene=list(xaxis = list(title='Month'),
                    yaxis = list(title='Year'),
                    zaxis = list(title='PassengerCount')))


random_vectors <- function(n) {
  MASS::mvrnorm(n = n, c(0,0), matrix(c(1,0,0,1), ncol=2))
} 

random.walk <- MASS::mvrnorm(n = 20, c(0,0), matrix(c(1,0.5,0.5,1), ncol=2)) %>%
  data.table()
random.walk[,':='(x=cumsum(V1), y=cumsum(V2), z=seq_len(.N))][,c('x', 'y', 'z')]
plot_ly(random.walk, x=~x, y=~y, z=~z, mode = 'lines')

z <- 1:60
x <- sin(z * pi / 5) + rnorm(30)
y <- cos(z * pi / 5) + rnorm(30)
random.seasonal <- data.frame(x=x, y=y, z=z)
plot_ly(random.seasonal, x=~x, y=~y, z=~z, mode = 'lines')
