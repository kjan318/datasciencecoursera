library(dplyr)
library(ggplot2)

setwd("S04/W4_Assignment/")

download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

## Loading data from .rds files

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# filter coal combustion-related sources from SCC 
coalcombustionSCC   <- filter(SCC, SCC.Level.One %like% "Combustion" & SCC.Level.Four %like% "Coal")

# NEI to Join data source with SCC id relates to coal combustion
coalcombustionNEI <- inner_join(NEI, coalcombustionSCC, by = "SCC") 


# creating .png file
png("plot4.png")


# creating a bar chart by using data with all combustion-related records from NEI
ggplot(coalcombustionNEI,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#7f3f70", width=0.8) +
  scale_fill_brewer(palette="Spectral") +
  theme_bw() + guides(fill=FALSE)+
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("1999-2008 : PM"[2.5]*" Coal Combustion Source Emissions Across US"))

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