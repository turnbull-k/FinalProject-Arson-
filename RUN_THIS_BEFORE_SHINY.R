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
data_2007 <- read.dbf("NFIRS_2007_042309/arson.dbf")
data_2010 <- read.dbf("NFIRS_2010_100711/arson.dbf")
data_2013 <- read.table('NFIRS_2013_121514/arson.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
data_2015 <- read.table('NFIRS_FIRES_2015_20170215/arson.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

casualties <- read.dbf("NFIRS_2007_042309/civiliancasualty.dbf")
casualties10 <- read.dbf("NFIRS_2010_100711/civiliancasualty.dbf")
casualties13 <- read.table('NFIRS_2013_121514/civiliancasualty.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
casualties15 <- read.table('NFIRS_FIRES_2015_20170215/civiliancasualty.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

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
juv_sub <- read.dbf("NFIRS_2007_042309/arsonjuvsub.dbf")
juv_sub10 <- read.dbf("NFIRS_2010_100711/arsonjuvsub.dbf")
juv_sub13 <- read.table('NFIRS_2013_121514/arsonjuvsub.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
juv_sub15 <- read.table('NFIRS_FIRES_2015_20170215/arsonjuvsub.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)

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
code_lookup <- read.dbf("NFIRS_2007_042309/codelookup.DBF")

# load basic incident tables (these are large tables and could take a 
# minute) and add property type and property value to the data table
basicincident <- read.dbf("NFIRS_2007_042309/basicincident.dbf")
PropUseTable <- code_lookup[(code_lookup$FIELDID == "PROP_USE"),]
PropUseTable <- select(PropUseTable, CODE_VALUE, CODE_DESCR)
PropUseTable = PropUseTable[-1,]
colnames(PropUseTable) <- c("PROP_USE", "Value")
basicincident <- left_join(basicincident, PropUseTable, by="PROP_USE")
basicincident %<>% select(-`PROP_USE`)
colnames(basicincident)[41] = "PROP_USE"
basicincident %<>% select(STATE, FDID, INC_NO, PROP_USE, PROP_LOSS)
data_2007 <- left_join(data_2007, basicincident, by=c("STATE", "FDID", "INC_NO"))

basicincident10 <- read.dbf("NFIRS_2010_100711/basicincident.dbf")
basicincident10 <- left_join(basicincident10, PropUseTable, by="PROP_USE")
basicincident10 %<>% select(-`PROP_USE`)
colnames(basicincident10)[41] = "PROP_USE"
basicincident10 %<>% select(STATE, FDID, INC_NO, PROP_USE, PROP_LOSS)
data_2010 <- left_join(data_2010, basicincident10, by=c("STATE", "FDID", "INC_NO"))

basicincidents13 <- read.table('NFIRS_2013_121514/basicincident.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
basicincidents13 <- left_join(basicincidents13, PropUseTable, by="PROP_USE")
basicincidents13 %<>% select(-`PROP_USE`)
colnames(basicincidents13)[41] = "PROP_USE"
basicincidents13 %<>% select(STATE, FDID, INC_NO, PROP_USE, PROP_LOSS)
data_2013 <- left_join(data_2013, basicincidents13, by=c("STATE", "FDID", "INC_NO"))

basicincidents15 <- read.table('NFIRS_FIRES_2015_20170215/basicincident.txt', sep="^", header = TRUE, stringsAsFactors = FALSE)
basicincidents15 <- left_join(basicincidents15, PropUseTable, by="PROP_USE")
basicincidents15 %<>% select(-`PROP_USE`)
colnames(basicincidents15)[41] = "PROP_USE"
basicincidents15 %<>% select(STATE, FDID, INC_NO, PROP_USE, PROP_LOSS)
data_2015 <- left_join(data_2015, basicincidents15, by=c("STATE", "FDID", "INC_NO"))

# make a data table of data that I want to be used in the first Shiny app
table_for_shiny <- data.table(data_2007$CASUALTIES, data_2007$AGE, data_2007$PROP_USE, data_2007$PROP_LOSS, 
                              data_2010$CASUALTIES, data_2010$AGE, data_2010$PROP_USE, data_2010$PROP_LOSS, 
                              data_2013$CASUALTIES, data_2013$AGE, data_2013$PROP_USE, data_2013$PROP_LOSS, 
                              data_2015$CASUALTIES, data_2015$AGE, data_2015$PROP_USE, data_2015$PROP_LOSS)

# make the column titles easier to understand
colnames(table_for_shiny)[1] <- "NUM_CASUALTIES_2007"
colnames(table_for_shiny)[2] <- "AGE_OF_ARRESTED_2007"
colnames(table_for_shiny)[3] <- "PROPERTY_TYPE_2007"
colnames(table_for_shiny)[4] <- "VALUE_OF_PROPERTY_2007"
colnames(table_for_shiny)[5] <- "NUM_CASUALTIES_2010"
colnames(table_for_shiny)[6] <- "AGE_OF_ARRESTED_2010"
colnames(table_for_shiny)[7] <- "PROPERTY_TYPE_2010"
colnames(table_for_shiny)[8] <- "VALUE_OF_PROPERTY_2010"
colnames(table_for_shiny)[9] <- "NUM_CASUALTIES_2013"
colnames(table_for_shiny)[10] <- "AGE_OF_ARRESTED_2013"
colnames(table_for_shiny)[11] <- "PROPERTY_TYPE_2013"
colnames(table_for_shiny)[12] <- "VALUE_OF_PROPERTY_2013"
colnames(table_for_shiny)[13] <- "NUM_CASUALTIES_2015"
colnames(table_for_shiny)[14] <- "AGE_OF_ARRESTED_2015"
colnames(table_for_shiny)[15] <- "PROPERTY_TYPE_2015"
colnames(table_for_shiny)[16] <- "VALUE_OF_PROPERTY_2015"

# Now you can run the first shiny app!
