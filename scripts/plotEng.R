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

#Filter data for plot
df <- df %>% 
  filter(hill_code=="eng")

#Order on X-axis
inter=interaction(df$competition_number, df$year)

#Plot
plot <- ggplot(df, aes(
  x=inter,
  y=as.numeric(distance),
))+
  geom_boxplot(fill = "orange") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1) 
  )+
  labs(
    title = "Rozkłady długości skoków w wybranych konkursach Pucharu Świata w Englebergu",
    x = "Konkurs (numer konkursu w roku, sezon)",
    y = "Długość skoku (m)",
  )


ggsave(filename = "../plots/plotEng.jpg", plot = plot, width = 10, height = 6, dpi = 300)


