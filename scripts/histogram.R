library(rstudioapi)
library(ggplot2)
library(readr)
library(dplyr)

#Set script path as working directory
current_script_path <- rstudioapi::getActiveDocumentContext()$path

current_script_dir <- dirname(current_script_path)

setwd(current_script_dir)

getwd()

#Read file
df <- read_csv(
  "../data/cleanDataCompetitions.csv",
  col_names = TRUE,             
  locale = locale(encoding = "UTF-8"),  
  progress = FALSE                
)

#Filter data
df <- df %>% 
  filter(hill_code == "lah" & year == "2023" & competition_number == "1")

#Plot
plot <- ggplot(df, aes(x=as.numeric(distance)))+
geom_histogram(bins = 7, fill = "skyblue", color = "black")+
 theme_minimal() +
  labs(
    title = "Rozkład długości skoków w pierwszym konkursie Pucharu Świata w Lahti w sezonie 2023/24",
    x = "Długość skoku",
    y = "Liczba skoków"
  )
  
shapiro.test(df$distance)


ggsave(filename = "../plots/histogram.jpg", plot = plot, width = 10, height = 6, dpi = 300)


