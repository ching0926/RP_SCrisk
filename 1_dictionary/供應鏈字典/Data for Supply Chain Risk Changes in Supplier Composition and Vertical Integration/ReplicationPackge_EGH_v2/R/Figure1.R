

######################################################################################
######################################################################################
#Figure 1. Supply chain risk topics
######################################################################################
######################################################################################


setwd("~/ReplicationPackge_JIE/R")


# Install
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")



#Climate Risk and Pandemics

data <- read.csv("~/ReplicationPackge_JIE/R/climate_risk.csv")

pdf(file="~/ReplicationPackge_JIE/R/climate_risk.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()



#Investment and Acquisitions
data <- read.csv("~/ReplicationPackge_JIE/R/acquisition.csv")

pdf(file="~/ReplicationPackge_JIE/R/acquisition.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()


#Technology and Cyberattack Risk
data <- read.csv("~/ReplicationPackge_JIE/R/tech.csv")

pdf(file="~/ReplicationPackge_JIE/R/tech.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()


#Liquidity 
data <- read.csv("~/ReplicationPackge_JIE/R/liquidity.csv")

pdf(file="~/ReplicationPackge_JIE/R/liquidity.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()


#Costs and commodity price risk
data <- read.csv("~/ReplicationPackge_JIE/R/costs.csv")

pdf(file="~/ReplicationPackge_JIE/R/costs.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()


#Market Uncertainty and Regions
data <- read.csv("~/ReplicationPackge_JIE/R/market_uncertainty.csv")

pdf(file="~/ReplicationPackge_JIE/R/market_uncertainty.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()



#Analysts and Financial Issues 
data <- read.csv("~/ReplicationPackge_JIE/R/analyst.csv")

pdf(file="~/ReplicationPackge_JIE/R/analyst.pdf", width=10, height=10)

wordcloud(words = data$word, freq = data$freq,
          max.words=30, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2") )
dev.off()



