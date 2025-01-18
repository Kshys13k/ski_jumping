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
  filter(hill_code == "lah" & year == "2023" & competition_number == "1" & series_number=="1")


#Plot
plot <- ggplot(df, aes(
  x = distance,
  y = rank,
  size = style_points,  
  color = wind_points   
)) +
  geom_point(alpha = 0.7) + 
  scale_y_reverse(name = "Miejsce", limits = c(50, 1)) + 
  scale_size_continuous(name = "Punkty Stylu") +  
  scale_color_viridis_c(name = "Punkty Wiatru", option = "C") +  
  labs(
    title = "Wpływ różnych not na ostateczne miejsce w zawodach",
    subtitle = "Pierwszy konkurs w Lahti w sezonie 2023/24, pierwsza seria",
    x = "Dystans (m)"
  ) +
  theme_minimal()




ggsave(filename = "../plots/multiDimPlot.jpg", plot = plot, width = 10, height = 6, dpi = 300)


