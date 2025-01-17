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


#Order on X-axis
inter=interaction(df$competition_number, df$hill_code, df$year)

#Plot
ggplot(df, aes(
  x=inter,
  y=as.numeric(distance),
  fill=hill_code
))+
  geom_boxplot() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1) 
  )


#test
df_test <- df %>% 
  filter(hill_code=="lil")


