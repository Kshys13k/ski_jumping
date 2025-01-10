#This script clears all csv files from "data/competitions/" and saves it into '/data/competitionsCleaned/".
#CSVs in "data/competitions/" have to have format: "tabula-[HILL_CODE][YEAR]_[NUMBER_OF_COMETITION].csv",
#for example: "tabula-wis24_1.csv", "tabula-gap23.csv".
#It is possible to generate new csv files:
#1. Downoload pdf with official results from fis website:
# https://www.fis-ski.com/DB/ski-jumping/calendar-results.html?noselection=true&mi=menu-calendar
#2. Use Tabula software to generate csv from pdf.
# IMPORTANT: use Lattice method to convert pdf to csv!
#3. Place csv file in "data/competitions/" folder and name it corretly.
#4. Run this script

library(rstudioapi)
library(stringr)
library(readr)

#Set script path as working directory
current_script_path <- rstudioapi::getActiveDocumentContext()$path

current_script_dir <- dirname(current_script_path)

setwd(current_script_dir)

getwd()

#Final data frame with all jumps
#
#name, country, birthday, starting_number, speed, distance,
#distance_points, mark_A, mark_B, mark_C, mark_D, mark_E, 
#style_points, gate, gate_points, wind_speed, wind_points,
#total_points, rank, total_points_all_jumps
df <- data.frame(
  name = character(), 
  country = character(), 
  birthday = character(), 
  starting_number = character(), 
  speed = character(), 
  distance = character(),
  distance_points = character(), 
  mark_A = character(), 
  mark_B = character(), 
  mark_C = character(), 
  mark_D = character(), 
  mark_E = character(), 
  style_points = character(), 
  gate = character(), 
  gate_points = character(), 
  wind_speed = character(), 
  wind_points = character(),
  total_points = character(), 
  rank = character(), 
  series_number = integer(),
  total_points_all_jumps = character(),
  competition_code = character(),
  hill_code = character(),
  year = character(),
  competition_number = character()
)

#clean data and add them to final df for every file
path <- "../data/competitions/"
files <- list.files(path, pattern = "\\.csv$", full.names = TRUE)

for(k in 1:length(files)){
  file <- files[k]
  
  #Extract information from file name
  competition <- gsub("(^.*tabula-)|(\\.csv$)", "", file)
  cat("\n\n",competition , "\n\n")
  
  pattern <- "^[A-Za-z]{3}"
  hill_code <- str_extract(competition, pattern)
  competition <- str_remove(competition, pattern)
  
  pattern <- "^\\d{2}"
  year <- paste0("20", str_extract(competition, pattern))
  competition_number <- str_remove(competition, pattern)
  
  if(nchar(competition_number) == 0){
    competition_number <- 0
  } else{
    competition_number <- str_remove(competition_number, "_")
  }
  
  ##############################################
  
  #Load and clear data
  df1 <- read_csv(
    file,
    col_names = FALSE,             
    locale = locale(encoding = "UTF-8"),  
    progress = FALSE                
  )
  
  df1 <- df1[,-1]
  
  #Get clean dfs; df2_1 - 1st and 2nd round, df2_2 - only 1st round
  pattern <- "^[A-Z]{3}.*\\d{4}$"
  
  df1$X3_trimmed <- trimws(df1$X3)
  
  #If first char is "*" delete it (in 4 Hills "*" codes lucky losers)
  df1$X3_trimmed <- sub("^\\*", "", df1$X3_trimmed)
  
  df2_1 <- df1[grepl(pattern, df1$X3_trimmed),]
  df2_1$X3_trimmed <- NULL
  df2_1$X2 <- NULL
  df1$X3_trimmed <- NULL
  
  df1$X2_trimmed <- trimws(df1$X2)
  df2_2 <- df1[grepl(pattern, df1$X2_trimmed),]
  df2_2$X2_trimmed <- NULL
  df2_2$X13 <- NULL
  
  #Concat df2_1 and df2_2
  reset_colnames <- function(df) {
    colnames(df) <- paste0("X", seq_len(ncol(df)))
    return(df)
  }
  
  df2_1 <- reset_colnames(df2_1)
  df2_2 <- reset_colnames(df2_2)
  
  if (ncol(df2_1) != ncol(df2_2)) {
    stop("Df's have different number of columns.")
  }
  
  #One row- one competitor
  df3 <- rbind(df2_1, df2_2)
  
  #For every row in df3 add to final df data about all jumps of this competitor
  for(j in 1:nrow(df3)){
    row <- df3[j,]
    
    long_string <- row[1]
    speed <- row[2]
    distance <- row[3]
    distance_points <- row[4]
    judges_marks <- row[5]
    style_points <- row[6]
    gate <- row[7]
    wind <-row[8]
    total_points <- row[9]
    rank <- row[10]
    total_points_all_jumps <- row[11]
    
    
    # Exstract data from long_string
    pattern <- "(?<![A-Z])[A-Z]{3}(?![A-Z])"
    country_code <- str_extract(long_string, pattern)
    
    pattern <- "[A-Z]{2,} [A-Z][a-z]+"
    name <- str_extract(long_string, pattern)
    
    pattern <- "\\d{1,2} [A-Z]{3} \\d{4}"
    date <- str_extract(long_string, pattern)
    
    #Remove from long_string information that is already found
    shorter_string <- str_remove(long_string, date)
    shorter_string <- str_remove(shorter_string, name)
    shorter_string <- str_remove(shorter_string, country_code)
    shorter_string <- str_squish(shorter_string)
    
    pattern <- "(?<!\\d)\\d{1,2}(?!\\d)"
    starting_number <- str_extract(shorter_string, pattern)
    
    # Split data for every jump
    speed_array <- str_split(speed, pattern = "\r", simplify = TRUE)
    distance_array <- str_split(distance, pattern = "\r", simplify = TRUE)
    distance_points_array  <- str_split(distance_points, pattern = "\r", simplify = TRUE)
    judges_marks_array  <- str_split(judges_marks, pattern = "\r", simplify = TRUE)
    style_points_array  <- str_split(style_points, pattern = "\r", simplify = TRUE)
    gate_array  <- str_split(gate, pattern = "\r", simplify = TRUE)
    wind_array  <-str_split(wind , pattern = "\r", simplify = TRUE)
    total_points_array  <- str_split(total_points, pattern = "\r", simplify = TRUE)
    rank_array  <- str_split(rank, pattern = "\r", simplify = TRUE)
    
    #For all jumps of current competitor:
    for (i in 1:length(speed_array)){
      
      # extract data about judges marks and wind
      marks <- str_extract_all(judges_marks_array[i], ".{1,4}")[[1]]
      markA <- marks[1]
      markB <- marks[2]
      markC <- marks[3]
      markD <- marks[4]
      markE <- marks[5]
      
      pattern <- "^.+\\.\\d{2}" #ERROR
      wind_speed <- str_extract(wind_array[i], pattern)
      wind_points <- str_remove(wind_array[i], pattern)
      
      #gate
      gate_n  <- substr(gate_array[i], 1, 2)
      gate_points <- substr(gate_array[i], 3, nchar(gate_array[i]))
      
      #name, country, birthday, starting_number, speed, distance, distance_points, mark_A, mark_B, mark_C, mark_D, mark_E, style_points, gate, gate_points, wind_speed, wind_points, total_points, rank, series_number, total_points_all_jumps, competition_code, hill_code, year, competition_number 
      series <- c(name, country_code, date, starting_number, speed_array[i], distance_array[i], distance_points_array[i], markA, markB, markC, markD, markE, style_points_array[i], gate_n, gate_points, wind_speed, wind_points, total_points_array[i], rank_array[i], i, total_points_all_jumps, k, hill_code, year, competition_number)
      new_row <- data.frame(t(series), stringsAsFactors = FALSE)
      colnames(new_row) <- c(
        "name", "country", "birthday", "starting_number", "speed", "distance", "distance_points", 
        "mark_A", "mark_B", "mark_C", "mark_D", "mark_E", "style_points", "gate", "gate_points", 
        "wind_speed", "wind_points", "total_points", "rank", "series_number", 
        "total_points_all_jumps", "competition_code", "hill_code", "year", "competition_number" 
      )
      
      #append new row to the df
      df <- rbind(df, new_row)
    }
  }
  
}

df

#Covert df columns to strings so write.csv will work
df_converted <- data.frame(
  lapply(df, function(col) {
    if (is.list(col)) {
      sapply(col, toString)
    } else {
      as.character(col)
    }
  }),
  stringsAsFactors = FALSE
)



write.csv(df_converted, file = "../data/cleanDataCompetitions/test.csv", row.names = TRUE)
