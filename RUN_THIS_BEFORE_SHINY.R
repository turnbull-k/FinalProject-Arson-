# RUN THIS BEFORE RUNNING SHINY APP

# load libraries
library(foreign)
library(data.table)
library(dplyr)
library(magrittr)
library(tidyr)
library(plyr)
library(ggplot2)
library(plotly)
library(ggmap)
library(lubridate)

# load data
data_2007 <- read.csv("arson2007.csv")
data_2010 <- read.csv("arson2010.csv")
data_2013 <- read.table('arson2013.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
data_2015 <- read.table('arson2015.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

casualties <- read.dbf("civiliancasualty2007.dbf")
casualties10 <- read.dbf("civiliancasualty2010.dbf")
casualties13 <- read.table('civiliancasualty2013.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
casualties15 <- read.table('civiliancasualty2015.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

# add civilian casualties to the data tables
death <- table(casualties$INC_NO)
d = as.data.table(death)
colnames(d) <- c("INC_NO", "CASUALTIES")
data_2007 <- left_join(data_2007, d, by="INC_NO")

death10 <- table(casualties10$INC_NO)
d10 = as.data.table(death10)
colnames(d10) <- c("INC_NO", "CASUALTIES")
data_2010 <- left_join(data_2010, d10, by="INC_NO")

death13 <- table(casualties13$INC_NO)
d13 = as.data.table(death13)
colnames(d13) <- c("INC_NO", "CASUALTIES")
data_2013 <- left_join(data_2013, d13, by="INC_NO")

death15 <- table(casualties15$INC_NO)
d15 = as.data.table(death15)
colnames(d15) <- c("INC_NO", "CASUALTIES")
data_2015 <- left_join(data_2015, d15, by="INC_NO")

# read in more data to look at the age of the arrested person
juv_sub <- read.dbf("juvsub2007.dbf")
juv_sub10 <- read.dbf("juvsub2010.dbf")
juv_sub13 <- read.table('juvsub2013.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
juv_sub15 <- read.table('juvsub2015.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

# add age of arrested person to data table
juv_sub %<>% select(STATE, FDID, INC_NO, AGE)
data_2007 <- left_join(data_2007, juv_sub, by=c("STATE", "FDID", "INC_NO"))

juv_sub10 %<>% select(STATE, FDID, INC_NO, AGE)
data_2010 <- left_join(data_2010, juv_sub10, by=c("STATE", "FDID", "INC_NO"))

juv_sub13 %<>% select(STATE, FDID, INC_NO, AGE)
data_2013 <- left_join(data_2013, juv_sub13, by=c("STATE", "FDID", "INC_NO"))

juv_sub15 %<>% select(STATE, FDID, INC_NO, AGE)
data_2015 <- left_join(data_2015, juv_sub15, by=c("STATE", "FDID", "INC_NO"))

# load code lookup table
code_lookup <- read.dbf("codelookup.DBF")

# make a data table of data that I want to be used in the first Shiny app
table_for_shiny <- data.table(data_2007$STATE, data_2007$CASUALTIES, data_2007$AGE,  
                              data_2010$STATE, data_2010$CASUALTIES, data_2010$AGE,  
                              data_2013$STATE, data_2013$CASUALTIES, data_2013$AGE,  
                              data_2015$STATE, data_2015$CASUALTIES, data_2015$AGE)

# make the column titles easier to understand
colnames(table_for_shiny)[1] <- "STATE_2007"
colnames(table_for_shiny)[2] <- "NUM_CASUALTIES_2007"
colnames(table_for_shiny)[3] <- "AGE_OF_ARRESTED_2007"
colnames(table_for_shiny)[4] <- "STATE_2010"
colnames(table_for_shiny)[5] <- "NUM_CASUALTIES_2010"
colnames(table_for_shiny)[6] <- "AGE_OF_ARRESTED_2010"
colnames(table_for_shiny)[7] <- "STATE_2013"
colnames(table_for_shiny)[8] <- "NUM_CASUALTIES_2013"
colnames(table_for_shiny)[9] <- "AGE_OF_ARRESTED_2013"
colnames(table_for_shiny)[10] <- "STATE_2015"
colnames(table_for_shiny)[11] <- "NUM_CASUALTIES_2015"
colnames(table_for_shiny)[12] <- "AGE_OF_ARRESTED_2015"

# Now you can run the first shiny app!
