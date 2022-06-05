library(tidyverse)
y <- c(1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0)

make.ema0 <- function(r) {
  s <- 0
  list(
    update=function(x){
      s <<- r*s + (1-r)*x
    }
  )
}

make.ema1 <- function(r) {
  started <- FALSE
  s <- NULL
  list(
    update=function(x){
      if(!started){
        started <<- TRUE
        s <<- x
      }else {
        s <<- r*s + (1-r) * x
      }
    }
  )
}

m0 <- make.ema0(0.7)
m1 <- make.ema1(0.7)

y0 <- y %>%
  map(m0$update) %>%
  unlist()

y1 <- y %>%
  map(m1$update) %>%
  unlist()

plot(y, type='b')
lines(y0, type='b', col=rgb(0, 0, 1, alpha = .5))
lines(y1, type='b', col=rgb(0, 0, 1, alpha = .5))
