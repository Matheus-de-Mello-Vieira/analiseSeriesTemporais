# required packages:
# Here
# zoo

library(here)
library(zoo)
library(data.table)

path <- here("ch2", "data", "UNRATE.csv")

unemp <- fread(path)
unemp[, DATE := as.Date(DATE)]
setkey(unemp, DATE)

## Gera um conjunto de dados onde os dados estão aleatoriamente ausentes
rand.unemp.idx <- sample(1:nrow(unemp), .1*nrow(unemp))
rand.unemp <- unemp[-rand.unemp.idx]

# Gera um conjunto de dados onde os dados possuem maior probabilidade de
# ausência quando o desemprego é alto.
high.unemp.idx <- which(unemp$UNRATE > 8)
num.to.select <- .2 * length(high.unemp.idx)
high.unemp.idx <- sample(high.unemp.idx,)
bias.unemp <- unemp[-high.unemp.idx]

all.dates <- seq(from=unemp$DATE[1], to=tail(unemp$DATE, 1), by="months")
rand.unemp = rand.unemp[J(all.dates), roll=0]
bias.unemp = bias.unemp[J(all.dates), roll=0]
rand.unemp[, rpt := is.na(UNRATE)]

rand.unemp[, impute.ff := na.locf(UNRATE, na.rm=FALSE)]
bias.unemp[, impute.ff := na.locf(UNRATE, na.rm=FALSE)]

## Para plotar um gráfico de amostra que mostra as partes achatadas
unemp[350:400, plot(DATE, UNRATE, col=1, lwd=2, type='b')]
rand.unemp[350:400, lines(DATE, impute.ff, col=2, lwd=2, lty=2)]
rand.unemp[350:400][rpt==TRUE, points(DATE, impute.ff, col=2, pch=6, cex=2)]

## média móvel sem lookahead
rand.unemp[, impute.rm.nolookahead := rollapply(c(NA, NA, UNRATE), 3,
                                                function(x) {
                                                  if (!is.na(x[3])) x[3] else mean(x, na.rm=TRUE)
                                                })]
bias.unemp[, impute.rm.nolookahead := rollapply(c(NA, NA, UNRATE), 3,
                                                function(x) {
                                                  if (!is.na(x[3])) x[3] else mean(x, na.rm=TRUE)
                                                })]

# média móvel com lookahead
impute_with_windown_mean_with_lookahead <- function(target.datatable){
  target.datatable[, impute.rm.lookahead := rollapply(c(NA, UNRATE, NA), 3, 
    function(x) {
      if(is.na(x[2]))
        mean(x, na.rm=TRUE)
      else
        x[2]
    })]
}

impute_with_windown_mean_with_lookahead(rand.unemp)
impute_with_windown_mean_with_lookahead(bias.unemp)

## Interpolação linear
rand.unemp[, impute.li := na.approx(UNRATE)]
bias.unemp[, impute.li := na.approx(UNRATE)]

## Interpoção polinomial
rand.unemp[, impute.sp := na.spline(UNRATE)]
bias.unemp[, impute.sp := na.spline(UNRATE)]

use.idx = 90:120
unemp[use.idx, plot(DATE, UNRATE, col=1, type='b')]
rand.unemp[use.idx, lines(DATE, impute.li, col = 2, lwd = 2, lty=2)]
bias.unemp[use.idx, lines(DATE, impute.sp, col = 3, lwd = 2, lty=3)]

result_comparate <- function(target) {
  sort(target[, lapply(.SD, function(x) mean((x - unemp$UNRATE)^2, na.rm=TRUE)),
       .SDcols = c("impute.ff", "impute.rm.lookahead", "impute.rm.nolookahead",
                   "impute.li", "impute.sp")]);
}

result_comparate(rand.unemp)
result_comparate(bias.unemp)

# sampling ==================
unemp[seq.int(from=1, to=nrow(unemp), by=12)]
unemp[, mean(UNRATE), by=format(DATE, "%Y")]

## dados sanzonais =================
AirPassengers

plot(AirPassengers, type='p')
plot(AirPassengers, type='l')


plot(stl(AirPassengers, "periodic"))
