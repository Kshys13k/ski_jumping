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
  mutate(Skocznia = full_name)

#Filter data for plot
df <- df %>% 
  filter(hill_code == "pla" | hill_code == "vik")

#Plot
ggplot(df, aes(
  x=hill_code,
  y=as.numeric(distance),
  fill=Skocznia
))+
  geom_hline(aes(yintercept = 200, color = "K"), size = 1) +
  geom_hline(aes(yintercept = 240, color = "HS"), size = 1) +
  scale_color_manual(
    values = c("K" = "blue", "HS" = "red"),
    labels = c("K" = "K - Punkt Konstrukcyjny", "HS" = "HS - Rozmiar Skoczni")
  )+
  geom_boxplot() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1) 
  )+
  labs(
    title = "Porównanie rozkładów długości skoków na skoczniach mamucich",
    x = "Skocznia",
    y = "Długość skoku (m)",
    colour = "Parametry skoczni"
  )


ggsave(filename = "../plots/plotComparisonSkiFlyingHills.jpg", plot = plot, width = 10, height = 6, dpi = 300)


