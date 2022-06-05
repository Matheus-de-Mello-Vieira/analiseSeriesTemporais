donations <- data.table(
  amt=c(99, 100, 5, 15, 11, 1200),
  dt=as.Date(c("2019-2-27",  "2019-3-2", "2019-6-13", "2019-8-1", "2019-8-31", "2019-9-15"))
)

publicity <- data.table(
  identifier=c('q4q42', '4299hj', 'bbg2'),
  dt=as.Date(c("2019-1-1", "2019-4-1", "2019-7-1"))
)

setkey(publicity, "dt")
setkey(donations, "dt")

result <- publicity[donations, roll=TRUE]
result

all.days = seq(from = unemp $ DATE[1], to=tail(unemp$DATE, 1), by="days")
unemp[J(all.days), roll=TRUE]
