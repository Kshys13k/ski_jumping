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
  mutate(Skocznia = full_name) %>% 
  filter(series_number==1) %>% 
  mutate(hill_class = ifelse(k>=200, "fly", "lar"))

#Normalization
df <- df %>% 
  mutate(distance_N = (distance-k)/(hs-k))

#Order on X-axis
inter=interaction(df$competition_number, df$year, df$hill_code)

#Plot
plot <- ggplot(df, aes(
  x=inter,
  y=as.numeric(distance_N),
  fill=Skocznia,
  color = hill_class
))+
  geom_hline(aes(yintercept = 0, color = "K"), size = 1, color = "blue", show.legend = TRUE) +
  geom_hline(aes(yintercept = 1, color = "HS"), size = 1, color = "#BF0000", show.legend = TRUE) +
  scale_linetype_manual(
    values = c("K" = "solid", "HS" = "dashed"),  
    labels = c("K" = "K - Punkt Konstrukcyjny", "HS" = "HS - Rozmiar Skoczni")
  ) +
  geom_boxplot() +
  scale_color_manual(
    values = c("lar" = "black", "fly" = "red"),
    labels = c("lar" = "Skocznia Duża", "fly" = "Skocznia Mamucia")
  )+
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1) 
  )+
  labs(
    title = "Normalizowane długości skoków w wybranych konkursach Pucharu Świata w sezonach 2022/23 - 2024/25",
    subtitle = "Pierwsze serie konkursowe, (grupowanie skoczniami), \n 0 - punkt K, 1 - HS",
    x = "Konkurs (numer, sezon, skocznia)",
    y = "Długość skoku",
    color = "Typ skoczni",
    linetype = "Parametry skoczni"
  )


ggsave(filename = "../plots/plotNormalizedHills.jpg", plot = plot, width = 10, height = 6, dpi = 300)


