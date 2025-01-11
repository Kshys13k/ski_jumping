#this script gets data from 'data/worldCupGC' and converts them into '../data/GCplots.csv'
# - a file that contains all data necessary to do plots about historical GC results od Poland

#TODO: clear second parts off surnames in points column. make variables: % points of GC winner, % of all gc points

library(rstudioapi)
library(stringr)
library(readr)
library(dplyr)

#Set script path as working directory
current_script_path <- rstudioapi::getActiveDocumentContext()$path

current_script_dir <- dirname(current_script_path)

setwd(current_script_dir)

getwd()

#Create df for ploting
df <- data.frame(
  Position= character(), 
  Competitor = character(), 
  Country = character(), 
  Points = character(), 
  Gap = character(), 
  Year= character(),
  YearCode=character()
)

#clean data and add them to final df for every file
path <- "../data/worldCupGC/"
files <- list.files(path, pattern = "\\.csv$", full.names = TRUE)

for(i in 1:length(files)){
  file <- files[i]
  
  #Extract information about year from file name
  year<-str_remove(file, "^.*season")
  year<-str_extract(year, "^\\d{4}")
  year_int <- as.integer(year)
  year_int2 <- year_int + 1
  year<-as.character(year_int)
  year_2<- as.character(year_int2)
  year<- str_extract(year, "..$")
  year_2<- str_extract(year_2, "..$")
  year<- paste0(year, "/", year_2)
  
  #Read file
  df1 <- read_csv(
    file,
    col_names = TRUE,             
    locale = locale(encoding = "UTF-8"),  
    progress = FALSE                
  )
  
  #Add to df data about all seasons for only polish ski jumpers
  df_pol <- df1 %>% 
    filter(Country == "polska")
  
  df_pol$Year <- year
  df_pol$YearCode <- i
  
  df <- rbind(df, df_pol)
}

write.csv(df, file = "../data/GCplots.csv", row.names = TRUE)

