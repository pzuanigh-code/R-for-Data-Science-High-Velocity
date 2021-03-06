# Copyright Mark Niemann-Ross, 2018
# Author: Mark Niemann-Ross. mark.niemannross@gmail.com
# LinkedIn: https://www.linkedin.com/in/markniemannross/
# Github: https://github.com/mnr
# More Learning: http://niemannross.com/link/mnratlil
# Description: R Programming in Data Science: High Velocity Data 

# learning about Rprof for profiling


# Setup -------------------------------------------------------------------
library(lubridate)

# start data simulator ----------------------------------------------------
# start HighVelocitySimulator.R in separate R instance

HighVelSimTxt <- "../HighVelocitySimulation.txt" # set this to the pathname of the simulation file

# setwd to chapter 3

# collectOneSecond with rbind and data frames acquire ------------------------------------------------------
collectOneSecond_df <- function() {
  oneSecData <- data.frame("V1" = NA,
                           "V2" = NA,
                           "V3" = NA)
  
  amountOfRunTime <- now() + seconds(1)
  
  while (amountOfRunTime > now()) {
    newData <- read.table(HighVelSimTxt)
    oneSecData <- rbind(oneSecData, newData)
  }
  
  return(oneSecData)
}

NonOptimizedResults <- collectOneSecond_df()

# how many observations in NonOptimizedResults?

# Optimized collectOneSecond ----------------------------------------------

collectOneSecond_opt <- function() {
  #  oneSecData <- data.frame("V1" = NA, "V2" = NA, "V3" = NA)
  # pre-allocating a list is faster than copying each time through the loop
  oneSecData <- vector(mode = "list", 10000)
  
  amountOfRunTime <- now() + seconds(1)
  
  dataIDX <- 1
  
  while (amountOfRunTime > now()) {
    newData <- read.table(HighVelSimTxt)
    oneSecData[[dataIDX]] <- newData
    dataIDX <- dataIDX + 1
  }
  allGoodData <- oneSecData[!sapply(oneSecData, is.null)]
  
  return(allGoodData)
}

optimizedResults <- collectOneSecond_opt()

# Compare # of observations in optimizedResults vs NonOptimizedResults

# use Rprof to generate profiles ----------------------------------------------------------------------

Rprof("profileW_df") ; collectOneSecond_df() ; Rprof(NULL)
Rprof("profileWOUT_df") ; collectOneSecond_opt() ; Rprof(NULL)

# examine results of Rprof ---------------------------------------------------------

summaryRprof("profileW_df")
summaryRprof("profileWOUT_df")

