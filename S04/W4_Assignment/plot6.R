library(dplyr)
library(ggplot2)


## Loading data from .rds files
setwd("S04/W4_Assignment/")

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


# filter motor vehicle sources from SCC 
motorV_SCC <- filter(SCC, SCC.Level.Three %like% "Motor Vehicle" | SCC.Level.Two %like% "Vehicle") %>%
  select(SCC)


# filter Baltimore City from NEI & Los Angeles County
baltimoreNEI <- filter(NEI, fips == '24510') %>%
                mutate(city="Baltimore")

LANEI <- filter(NEI, fips == '06037') %>%
         mutate(city="Los Angeles")

LA_baltimoreNEI <- rbind(baltimoreNEI,LANEI)

table(LA_baltimoreNEI$city)


# to Join Baltimore City & LA data source with SCC id relates to motor vehicle sources
LA_baltimoreSCC <- inner_join(motorV_SCC, LA_baltimoreNEI, by = "SCC")

# calculate total motor vehicle sources Emission of Baltimore City & LA by different year (1999 to 2008)
NEIbaltimore_LA_motorV <- select(LA_baltimoreSCC, c(year,city,Emissions)) %>%
  group_by(year,city) %>%
  summarize(year, city, Total_Emissions=sum(Emissions, na.rm = TRUE)) %>%
  unique()


# creating .png file
png("plot6.png")

ggplot(NEIbaltimore_LA_motorV,aes(x = factor(year),y = Total_Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(.~city,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("1999 to 2008 : PM"[2.5]*" Emissions, Baltimore VS LA Motor Vehicle Source"))


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