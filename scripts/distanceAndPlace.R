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

#Calculate distance needed for each place
places <- quantile(df$distance_N, probs = seq(0, 1, length.out = 51))
places <- places[-c(1, length(places))]
vector <- 49:1

df <- data.frame(
  place = vector,        
  distance_N = places  
)

#Load data about hills
df_hills <- read_csv(
  "../data/hills.csv",
  col_names = TRUE,             
  locale = locale(encoding = "UTF-8"),  
  progress = FALSE                
)

#Make table with disctances and predicted place
lah_k = df_hills$k[df_hills$hill_code == "lah"]
lah_hs = df_hills$hs[df_hills$hill_code == "lah"]
ruk_k = df_hills$k[df_hills$hill_code == "ruk"]
ruk_hs = df_hills$hs[df_hills$hill_code == "ruk"]
vik_k = df_hills$k[df_hills$hill_code == "vik"]
vik_hs = df_hills$hs[df_hills$hill_code == "vik"]
wis_k = df_hills$k[df_hills$hill_code == "wis"]
wis_hs = df_hills$hs[df_hills$hill_code == "wis"]
zak_k = df_hills$k[df_hills$hill_code == "zak"]
zak_hs = df_hills$hs[df_hills$hill_code == "zak"]

df_table_distance_and_place <- df %>% 
  mutate(lah = (distance_N * (lah_hs-lah_k))+lah_k) %>% 
  mutate(ruk = (distance_N * (ruk_hs-ruk_k))+ruk_k) %>% 
  mutate(vik = (distance_N * (vik_hs-vik_k))+vik_k) %>% 
  mutate(wis = (distance_N * (wis_hs-wis_k))+wis_k) %>% 
  mutate(zak = (distance_N * (zak_hs-zak_k))+zak_k) 


