library(rstudioapi)
library(ggplot2)
library(readr)
library(dplyr)
library(forcats)
library(tidyr)

competitor_colors <- c(
  "Adam Małysz" = "#FB0038", "Wojciech Skupień" = "#0DFB16", "Marek Gwóźdź" = "#005355",
  "Robert Mateja" = "#F4CECD", "Krystian Długopolski" = "#F116CE", "Łukasz Kruczek" = "#3BCFFE",
  "Tomasz Pochwała" = "#834F0D", "Marcin Bachleda" = "#F0850D", "Tomisław Tajner" = "#0DB681",
  "Mateusz Rutkowski" = "#6E2A82", "Wojciech Tajner" = "#AC2658", "Kamil Stoch" = "#4016F4",
  "Piotr Żyła" = "#E9E116", "Stefan Hula" = "#D55CFE", "Rafał Śliż" = "#FE9BE1",
  "Łukasz Rutkowski" = "#FD008C", "Krzysztof Miętus" = "#A19FFB", "Grzegorz Miętus" = "#98A65A",
  "Tomasz Byrt" = "#B7ECEE", "Maciej Kot" = "#99EE70", "Aleksander Zniszczoł" = "#F7C478",
  "Klemens Murańka" = "#A698BF", "Dawid Kubacki" = "#F76260", "Jan Ziobro" = "#FDA19B",
  "Krzysztof Biegun" = "#0D6A9B", "Andrzej Stękała" = "#AA657F", "Jakub Wolny" = "#22F1E6",
  "Tomasz Pilch" = "#A70D8A", "Paweł Wąsek" = "#0091FB", "Jan Habdas" = "#FC5FB9",
  "Kacper Juroszek" = "#7A2EBB"
)


#Set script path as working directory
current_script_path <- rstudioapi::getActiveDocumentContext()$path

current_script_dir <- dirname(current_script_path)

setwd(current_script_dir)

getwd()

#Read file
df <- read_csv(
  "../data/GCplots.csv",
  col_names = TRUE,             
  locale = locale(encoding = "UTF-8"),  
  progress = FALSE                
)

# Modify data so missing values for Competitors in some Years will become 0's
df_complete <- df_sorted %>%
  complete(Year, Competitor, fill = list(Points = 0))


# Messing with factors
df_sorted <- df_complete %>%
  arrange(YearCode)
df_sorted$Year <- factor(df_sorted$Year, levels = unique(df_sorted$Year))

#Plot
plot <- ggplot(df_sorted, aes(
  x = factor(Year),
  y = Points,
  colour = Competitor,
  group = Competitor
)) +
  geom_line(size=1) +
  scale_colour_manual(values = competitor_colors) +
  theme_minimal() +
  labs(
    title = "Punkty polskich skoczków w Pucharze Świata w latach 1994-2025",
    x = "Sezon",
    y = "Liczba punktów"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1) 
  )



ggsave(filename = "../plots/plot2GC.jpg", plot = plot, width = 10, height = 6, dpi = 300)

