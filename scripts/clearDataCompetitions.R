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

#Set script path as working directory
current_script_path <- rstudioapi::getActiveDocumentContext()$path

current_script_dir <- dirname(current_script_path)

setwd(current_script_dir)

getwd()

#Load and clear data
library(readr)

df1 <- read_csv(
 # "../data/competitions/tabula-wis24_1.csv",
  "../data/competitions/tabula-gap23.csv",
  skip = 3,                      # Pomiń pierwsze 3 wiersze
  col_names = FALSE,             # Brak nagłówków
  locale = locale(encoding = "UTF-8"),  # Kodowanie UTF-8
  progress = TRUE                # Pokazuje postęp wczytywania
)

df1 <- df1[,-1]


#Get clean dfs; df2_1 - 1st and 2nd round, df2_2 - only 1st round
pattern <- "^[A-Z]{3}.*\\d{4}$"

df1$X3_trimmed <- trimws(df1$X3)
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

df3 <- rbind(df2_1, df2_2)

row <- df3[1,]
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
library(stringr)

pattern_code <- "(?<![A-Z])[A-Z]{3}(?![A-Z])"
country_code <- str_extract(long_string, pattern_code)

pattern_code <- "[A-Z]{2,} [A-Z][a-z]+"
name <- str_extract(long_string, pattern_code)

pattern_code <- "\\d{1,2} [A-Z]{3} \\d{4}"
date <- str_extract(long_string, pattern_code)

shorter_string <- str_remove(long_string, date)
shorter_string <- str_remove(shorter_string, name)
shorter_string <- str_remove(shorter_string, country_code)
shorter_string <- str_squish(shorter_string)

cat("String po usunięciu znalezionych elementów:\n", shorter_string, "\n")

pattern_code <- "(?<!\\d)\\d{1,2}(?!\\d)"
starting_number <- str_extract(shorter_string, pattern_code)

cat("Znaleziony trójznakowy kod:", country_code, "\n")
cat("Znaleziony łańcuch:", name, "\n")
cat("Znaleziono datę:", date, "\n\n")
cat("Znaleziono numer:", starting_number, "\n\n")

