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

#Prepare data for plot
df <- df %>% 
  mutate(Skocznia = hill_code) %>% 
  filter(series_number==1)

#Normalization
df <- df %>% 
  mutate(distance_N = (distance-k)/(hs-k))

#Plot
b <- ceiling(sqrt(nrow(df)))
plot <- ggplot(df, aes(x=as.numeric(distance_N)))+
  geom_histogram(bins = b, fill = "skyblue", color = "black")+
  geom_vline(aes(xintercept = 0, color = "punkt K"), linetype = "solid", size = 1) +
  geom_vline(aes(xintercept = 1, color = "HS"), linetype = "dashed", size = 1) +
  scale_color_manual(
    values = c("punkt K" = "blue", "HS" = "red"),
    labels = c("punkt K" = "Punkt K", "HS" = "HS - Rozmiar Skoczni")
  ) +
  theme_minimal() +
  labs(
    title = "Rozkład długości normalizowanych skoków w konkursach Pucharu Świata",
    subtitle = "(Tylko pierwsze serie)",
    x = "Długość skoku",
    y = "Liczba skoków",
    color = "Parametry Skoczni"
  )

ggsave(filename = "../plots/histogramWC.jpg", plot = plot, width = 10, height = 6, dpi = 300)


