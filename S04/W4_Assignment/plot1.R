library(dplyr)

setwd("S04/W4_Assignment/")

download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

## Loading data from .rds files

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


# sum value of column "Emissions" by different year and assign to 'totalNEIbyYear' variable for plotting later

totalNEIbyYear <- select(NEI, c(year, Emissions)) %>%
                  group_by(year) %>%
                  summarize(year, Total_Emissions=sum(Emissions, na.rm = TRUE)) %>%
                  unique()


# creating .png file
png(filename='plot1.png')

# Making a plot to present the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.


barplot(totalNEIbyYear$Total_Emissions
        , names = totalNEIbyYear$year
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions of United States from 1999 to 2008")

dev.off()


# CLEAN UP #################################################

# Clear data
rm(list = ls())  # Removes all objects from environment

# Clear packages
detach("package:datasets", unload = T)  # For base packages
p_unload(all)  # Remove all contributed packages

# Clear plots
graphics.off()  # Clears plots, closes all graphics devices

# Clear console
cat("\014")  # Mimics ctrl+L

# Clear mind :)