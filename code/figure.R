#!/usr/bin/env Rscript

# How do we install these programmatically?
library(RSQLite)
library(ggplot2)

db <- dbConnect(dbDriver("SQLite"), dbname='scraperwiki.sqlite', loadable.extensions=TRUE)

fre <- dbGetQuery(db, "SELECT*FROM obs WHERE jaslid=='h175a' ORDER BY t")
sth <- dbGetQuery(db, "SELECT*FROM obs WHERE jaslid=='h292a' ORDER BY t")
bre <- dbGetQuery(db, "SELECT*FROM obs WHERE jaslid=='h822a' ORDER BY t")

# png('fre-hist.png')
# ggplot(fre) + geom_histogram(aes(x=z,y=..ncount..), binwidth=50) +
#   coord_flip() + xlab("height (mm)") +
#   ggtitle("Fremantle - hourly sea levels")
# dev.off()
# png('sth-hist.png')
# ggplot(sth) + geom_histogram(aes(x=z,y=..ncount..), binwidth=50) +
#   coord_flip() + xlab("height (mm)") +
#   ggtitle("St Helena - hourly sea levels")
# dev.off()
png('bre-hist.png')
ggplot(bre) + geom_histogram(aes(x=z,y=..ncount..), binwidth=100) +
  coord_flip() + xlab("height (mm)") +
  ggtitle("Brest - hourly sea levels")
dev.off()
png('fre3-hist.png')
ggplot(mapping=aes(x=z,y=..ncount..)) + geom_histogram(data=bre,
binwidth=100) + geom_histogram(data=sth, fill='purple',
binwidth=50) + geom_histogram(data=fre, fill='red', binwidth=50) +
  ggtitle("Brest, St Helena, Fremantle - hourly sea levels") +
  xlab("height (mm)") + ylab("Normalised count") +
  coord_flip()
dev.off()
png('sth2-hist.png')
ggplot(mapping=aes(x=z,y=..ncount..)) + geom_histogram(data=bre,
binwidth=100) + geom_histogram(data=sth, fill='purple',
binwidth=50) +
  ggtitle("Brest, St Helena - hourly sea levels") +
  xlab("height (mm)") + ylab("Normalised count") +
  coord_flip()
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

png('fre-ts.png', width=480, height=160)
ggplot(fre1M) + geom_line(aes(x=dt, y=z)) +
  ylab("height (mm)") + xlab("January 1999") +
  ggtitle("Fremantle")
dev.off()
png('sth-ts.png', width=480, height=160)
ggplot(sth1M) + geom_line(aes(x=dt, y=z)) +
  ylab("height (mm)") + xlab("January 1999") +
  ggtitle("St Helena")
dev.off()
png('bre-ts.png', width=480, height=160)
ggplot(bre1M) + geom_line(aes(x=dt, y=z)) +
  ylab("height (mm)") + xlab("January 1999") +
  ggtitle("Brest")
dev.off()
