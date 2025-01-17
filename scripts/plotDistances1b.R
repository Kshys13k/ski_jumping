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
  mutate(Skocznia = hill_code)

#Order on X-axis
inter=interaction(df$competition_number, df$year, df$hill_code)

#Plot
plot <- ggplot(df, aes(
  x=inter,
  y=as.numeric(distance),
  fill=Skocznia
))+
  geom_boxplot() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1) 
  )+
  labs(
    title = "Rozkłady długości skoków w wybranych konkursach Pucharu Świata w sezonach 2022/23 - 2024/25",
    subtitle = "(Grupowanie sezonami)",
    x = "Konkurs (numer, skocznia, sezon)",
    y = "Długość skoku (m)",
    color = "Skocznia"
  )


ggsave(filename = "../plots/plotDistances1b.jpg", plot = plot, width = 10, height = 6, dpi = 300)


