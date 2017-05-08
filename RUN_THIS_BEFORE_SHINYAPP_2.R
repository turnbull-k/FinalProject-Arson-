# RUN THIS BEFORE SHINYAPP_2

# load libraries if you have not already loaded them
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

# make tables for the number of arson events in each state 
# make table of latitude/longitude of each state, using geocode
state_incident_table10 <- as.data.table(table(data_2010$STATE))
state_latlon_table <- as.data.table(state_incident_table10$V1)
state_latlons <- apply(state_latlon_table, 2, geocode)
state_ll <- as.data.table(state_latlons)
state_ll$STATE <- state_latlon_table$V1

state_incident_table <- as.data.table(table(data_2007$STATE))
state_incident_table13 <- as.data.table(table(data_2013$STATE))
state_incident_table15 <- as.data.table(table(data_2015$STATE))

# remove "NA" as a state option
state_incident_table <- state_incident_table[ state_incident_table$V1 != "NA", ]
state_incident_table10 <- state_incident_table10[ state_incident_table10$V1 != "NA", ]
state_incident_table13 <- state_incident_table13[ state_incident_table13$V1 != "NA", ]
state_incident_table15 <- state_incident_table15[ state_incident_table15$V1 != "NA", ]

# correct for missing values in tables
state_incident_table <- rbind(state_incident_table, data.table(V1 = "OR", N=0))
state_incident_table13 <- rbind(state_incident_table13, data.table(V1 = "WY", N=0))

# Now you can run ShinyApp_2!
