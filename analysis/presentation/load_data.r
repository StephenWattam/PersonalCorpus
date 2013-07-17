

# LIBRARY: loads data from prelim3 and normalises format
#
#


# Load data from CSV
dat <- read.csv("../../data/prelim3/codes.csv", header=T)

# Extract a fortnight's worth of data for further analysis
dat.lte19   <- which(dat$day <= 19)
dat.gte5    <- which(dat$day >= 5)
fn          <- dat[intersect(dat.lte19, dat.gte5),]

# Extract subsets
#
# Spoken and written
fn.s <- fn[which(fn$mode == 's'),]
fn.w <- fn[which(fn$mode == 'w'),]



# Summarise
summary(fn)




