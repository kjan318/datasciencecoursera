library(dplyr)
library(ggplot2)


download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")


## Loading data from .rds files
setwd("S04/W4_Assignment/")

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


# filter motor vehicle sources from SCC 
motorV_SCC <- filter(SCC, SCC.Level.Three %like% "Motor Vehicle" | SCC.Level.Two %like% "Vehicle") %>%
              select(SCC)


# filter Baltimore City from NEI 
baltimoreNEI <- filter(NEI, fips == '24510') 

# to Join Baltimore City data source with SCC id relates to motor vehicle sources
baltimoreSCC <- inner_join(motorV_SCC, baltimoreNEI, by = "SCC")

# calculate total motor vehicle sources Emission of Baltimore City by different year (1999 to 2008)
NEIbaltimore_motorV <- select(baltimoreSCC, c(year, Emissions)) %>%
                       group_by(year) %>%
                       summarize(year, Total_Emissions=sum(Emissions, na.rm = TRUE)) %>%
                       unique()
# creating .png file
png("plot5.png")


# creating a bar chart by using data "NEIbaltimore_motorV"
ggplot(NEIbaltimore_motorV,aes(x = factor(year),y = Total_Emissions)) +
  geom_bar(stat="identity", fill ="#7f3f70", width=0.8) +
  scale_fill_brewer(palette="Spectral") +
  theme_bw() + guides(fill=FALSE)+
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("1999-2008 : PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore"))

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