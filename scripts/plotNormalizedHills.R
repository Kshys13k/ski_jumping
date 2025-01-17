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
df <- df %>% 
  mutate(Skocznia = hill_code) %>% 
  filter(series_number==1)

#Normalization
df <- df %>% 
  mutate(distance_N = (distance-k)/(hs-k))

#Order on X-axis
inter=interaction(df$competition_number, df$year, df$hill_code)

#Plot
ggplot(df, aes(
  x=inter,
  y=as.numeric(distance_N),
  fill=Skocznia
))+
  geom_boxplot() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1) 
  )+
  labs(
    title = "Normalizowane długości skoków w wybranych konkursach Pucharu Świata w sezonach 2022/23 - 2024/25",
    subtitle = "W pierwszych seriach, (grupowanie skoczniami)",
    x = "Konkurs (numer, skocznia, sezon)",
    y = "Długość skoku (m)",
    color = "Skocznia"
  )


ggsave(filename = "../plots/plotNorDist1.jpg", plot = plot, width = 10, height = 6, dpi = 300)


