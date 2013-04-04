#!/usr/bin/env Rscript

# How do we install these programmatically?
library(RSQLite)
library(ggplot2)

db <- dbConnect(dbDriver("SQLite"), dbname='scraperwiki.sqlite', loadable.extensions=TRUE)

fre <- dbGetQuery(db, "select*from obs where jaslid=='h175a' order by t")
sth <- dbGetQuery(db, "select*from obs where jaslid=='h292a' order by t")
bre <- dbGetQuery(db, "select*from obs where jaslid=='h822a' order by t")

png('fre-hist.png')
ggplot(fre) + geom_histogram(aes(x=z), binwidth=50)
dev.off()
png('sth-hist.png')
ggplot(sth) + geom_histogram(aes(x=z), binwidth=50)
dev.off()
png('bre-hist.png')
ggplot(bre) + geom_histogram(aes(x=z), binwidth=100)
dev.off()

fre$dt <- as.POSIXct(fre[,]$t, format="%Y%m%dT%H%M", tz="GMT")
sth$dt <- as.POSIXct(sth[,]$t, format="%Y%m%dT%H%M", tz="GMT")
bre$dt <- as.POSIXct(bre[,]$t, format="%Y%m%dT%H%M", tz="GMT")

# month beginning and end
beg = as.POSIXct("1999-01-01", tz="GMT")
end = as.POSIXct("1999-02-01", tz="GMT")
fre1M = fre[beg <= fre$dt & fre$dt < end,]
sth1M = sth[beg <= sth$dt & sth$dt < end,]
bre1M = bre[beg <= bre$dt & bre$dt < end,]

png('fre-ts.png', width=480, height=120)
ggplot(fre1M) + geom_line(aes(x=dt, y=z))
dev.off()
png('sth-ts.png', width=480, height=120)
ggplot(sth1M) + geom_line(aes(x=dt, y=z))
dev.off()
png('bre-ts.png', width=480, height=120)
ggplot(bre1M) + geom_line(aes(x=dt, y=z))
dev.off()
