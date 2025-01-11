library(rstudioapi)
library(ggplot2)
library(readr)
library(dplyr)
library(forcats)

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

#Prepare data for ploting
df_sorted <- df %>%
  group_by(YearCode) %>%
  arrange(-Points) %>%  
  mutate(Competitor = factor(Competitor, levels = Competitor)) %>%  
  ungroup()

#Plot
ggplot(df_sorted, aes(
  x = factor(YearCode),
  y = Points,
  fill = fct_inorder(Competitor)  
)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = competitor_colors) +  
  labs(
    title = "Punkty zawodników w różnych latach",
    x = "Rok",
    y = "Punkty",
    fill = "Zawodnik"
  ) +
  theme_minimal()



