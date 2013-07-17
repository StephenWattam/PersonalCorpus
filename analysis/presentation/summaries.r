
# Load data into 'dat' and sanitise
source('load_data.r');

# Load graph building libs
source('graphs.r')



# 
# Words distribution
library('xtable')
quantiles = as.table(quantile(fn$computed_words, c(.05, .10, .20, .50, .70, .90, .95)))
xtable(t(quantiles))


# =================================================================================================
# Graph day-by-day counts as a bar chart
daysums.index       = seq(5,19)
daysums             = c()
daysums.spoken      = c()
daysums.written     = c()
daysums.produced     = c()
daysums.consumed     = c()
daysums.interactive     = c()

for(i in unique(fn$day)){
    daysums[i]          = sum(fn[which(fn$day == i),]$computed_words)
    daysums.spoken[i]   = sum(fn[which(fn$day == i),]$computed_words_spoken)
    daysums.written[i]  = sum(fn[which(fn$day == i),]$computed_words_written)
    daysums.produced[i]  = sum(fn[which(fn$day == i),]$computed_words_produced)
    daysums.consumed[i]  = sum(fn[which(fn$day == i),]$computed_words_consumed)
    daysums.interactive[i]  = sum(fn[which(fn$day == i),]$computed_words_interactive)
}

# Composite them for the bar chart
daysums.composite.matrix = matrix(c(daysums.index, daysums.spoken[seq(5,19)], daysums.written[seq(5,19)]), nrow = length(daysums.index))
daysums.composite = t(daysums.composite.matrix)

# Open graphics device
grout('cbyday')

# Plot the plot of doom
barplot(daysums.composite, 
        col     = c('darkblue', 'red'),
        names   = seq(5,19),
        main    = paste("Word count by day (m=", round(mean(na.omit(daysums))), ", sd=", round(sd(na.omit(daysums))), ")", sep=''),
        xlab    = "day",
        ylab    = "words"
        )
legend("topleft", c("Spoken", "Written"), text.col=c('darkblue', 'red'), box.col='white')

# Close device
groff();





# =================================================================================================


events.table = table(fn$medium)
events.table = as.table(sort(events.table, decreasing=T))
xtable(events.table)





# =================================================================================================
# Graph production/consumption

# Composite them for the bar chart
daysums.composite.matrix = matrix(c(daysums.index, 
                                    daysums.produced[seq(5,19)], 
                                    daysums.consumed[seq(5,19)], 
                                    daysums.interactive[seq(5,19)]), 
                                  nrow = length(daysums.index))
daysums.composite = t(daysums.composite.matrix)

# Open graphics device
grout('prodbyday')

# Plot the plot of doom
barplot(daysums.composite, 
        col     = c('darkblue', 'lightblue', 'blue'),
        names   = seq(5,19),
        main    = paste("Text consumption and Production"),
        xlab    = "day",
        ylab    = "words"
        )
legend("topleft", 
       c("Interactive", "Consumed", "Produced"), 
       text.col=c('darkblue', 'blue', 'lightblue'), 
       box.col='white')

# Close device
groff();




# =================================================================================================
# Media Distribution plot
#



grout('distraw', h=2,w=7)
par(mar=c(0,0,0,0))

# Plot of media
plot(log(sort(events.table, decreasing=T)), type='l',
     
     yaxt='n',
     xaxt='n',
     ann=F)
     
    


# Plot of all events
# plot(density(log(na.omit(fn$computed_words))),
#      yaxt='n',
#      xaxt='n',
#      ann=F)
groff();






# =================================================================================================
#
# Genre
#
events.table = table(fn$computed_informal_genre)
events.table = as.table(sort(events.table, decreasing=T))
xtable(events.table)



# =================================================================================================
# Genre Distribution plot
#



grout('gdistraw', h=2,w=7)
par(mar=c(0,0,0,0))

# Plot of media
plot(log(sort(events.table, decreasing=T)), type='l',
     yaxt='n',
     xaxt='n',
     ann=F)
    
groff();



# =================================================================================================
# Mean Genre sizes
#


genres.mean     = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), mean)
genres.median   = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), median)
genres.sum      = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), sum)
genres.sd       = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), sd)
genres.min      = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), min)
genres.max      = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), max)
genres.count    = aggregate(fn$computed_words, list(factor(fn$computed_informal_genre)), count)

# Raw (all)
# print them out
xtable(as.table(as.matrix(genres.median[with(genres.median, order(-genres.median$x)),] )))
xtable(as.table(as.matrix(genres.mean[with(genres.mean, order(-genres.mean$x)),] )))


# Only those with over 5 occurrences
genres.over_5 = genres.count[which(genres.count$x > 5),]
genres.means_over_5 = genres.mean[which(genres.mean$Group.1 %in% genres.over_5$Group.1),]

means_over_5_table = as.table(as.matrix(genres.means_over_5[with(genres.means_over_5, order(-genres.means_over_5$x)),] ))
xtable(means_over_5_table)



# =================================================================================================
# Genre mean distribution
#
#
#
grout('gmdistraw', h=2,w=7)
par(mar=c(0,0,0,0))

# Plot of media
plot(log(sort(genres.means_over_5$x, decreasing=T)), type='l',
     yaxt='n',
     xaxt='n',
     ann=F)
    
groff();



#
#
#


# 
# barplot(daysums[seq(5, 19)],
#         xlab = seq(5, 19));
# #, ylim=c(0,max(na.omit(daysums)))
#genres.mean[which(genres.mean$Group.1 %in% genres.over_5),] 
