library(tidyverse)
library(magrittr)
library(lubridate)


# download SSI files -----------------------------------------------------------


ssi_filer <-  read_csv("../data/ssifiler.txt", col_names = FALSE) #liste over links til filer fra SSI


ssi_filer %<>% mutate(files = paste0(X1, ".zip"),
                     date = str_sub(X1, str_length(X1)-12, str_length(X1)-5),
                     date = paste0(20, str_sub(date, 3, 4), str_sub(date, 1, 2)),
                     date = ifelse(date == "2020-2", "200622", date),
                     date = ifelse(date == "203.f4", "200728", date),
                     date = ifelse(date == "205260", "200516", date),
                     date = ifelse(date == "20g.7j", "200727", date),
                     date = ifelse(date == "20t.3y", "200813", date),
                     date = ifelse(date == "202007", "200707", date))

# dl <- function(x, y) {
#   
#   try(download.file(x, paste0("../data/SSIdata_", y, ".zip"), mode="wb"))
#   
#   print(y)
#   
# }
#   
#   
#   
# 
# mapply(dl , ssi_filer$files, ssi_filer$date)
# unzip("../data/test.zip", "../data/test")


ssi_filer <- ssi_filer[!(ssi_filer$date=="200728"),] #indeholder ikke aldersgruppe data
ssi_filer <- ssi_filer[!(ssi_filer$date=="200622"),] #indeholder ikke aldersgruppe data


# read and tidy AGE data --------------------------------------------------


read_age_csv <- function(x) {
  file <- read_csv2(paste0("../data/SSIdata_", x, "/Cases_by_age.csv"))
  file %<>% mutate(date_of_file = x)   %>% 
    select(-Procent_positive) %>%
    mutate(Date = paste0("2020-", str_sub(date_of_file,3,4), "-", str_sub(date_of_file,5,6))) 
  
  return(file)
  
}

csv_list <- lapply(ssi_filer$date, read_age_csv)

age_df <- bind_rows(csv_list)



age_df %<>% 
  mutate(date_of_file = as.integer(date_of_file)) %>%
  rename(positive = `Antal_bekræftede_COVID-19`) %>%
  arrange(date_of_file) %>%
  mutate(Date = as.Date(Date))

abs(diff(unique(week_df$Date))) #test


# AGE arrange weekly ------------------------------------------------------

week_df <- age_df %>%
  filter(wday(Date) == 4) #wednesday because it consistently appears throughout (e.g mondays can be holidays)

early_data <- read_csv2("../data/early_age_reports.csv")

week_df %<>% bind_rows(early_data) %>% arrange(Date)



# read and tidy MUNICIPALITY data -----------------------------------------

read_muni_csv <- function(x) {
  file <- read_csv2(paste0("../data/SSIdata_", x, "/Municipality_test_pos.csv"))
  file %<>% mutate(date_of_file = x)   %>% 
    mutate(Date = paste0("2020-", str_sub(date_of_file,3,4), "-", str_sub(date_of_file,5,6))) 
  
  return(file)
  
}

csv_list <- lapply(ssi_filer$date, read_muni_csv)

muni_df <- bind_rows(csv_list)

muni_df %<>% 
  mutate(Positive = ifelse(`Antal_bekræftede_COVID-19` == "<10", 10, `Antal_bekræftede_COVID-19`)) %>%
  mutate(Positive = as.numeric(gsub("\\.", "", Positive))) %>%
  mutate(Date = as.Date(Date)) %>%
  select(-date_of_file) %>%
  arrange(Date)

muni_df <- bind_cols(muni_df, data.frame("Dage_siden_sidst" = rep(c(0,abs(diff(unique(muni_df$Date)))), each = 99)))

muni_df %<>%
  group_by(`Kommune_(id)`) %>%
  mutate(Pos_diff = c(0,diff(Positive)),
         Testede_diff = c(0,diff(Antal_testede))) %>%
  ungroup() 


muni_df %>% write.csv2("../data/municipality_over_time_combined.csv")


# MUNICIPALITY arrange weekly - monday for weeknumbers -----------------------------------------------------


muni_df_wk <- muni_df %>%
  filter(wday(Date) == 2) #mondays  consistently appears from july

abs(diff(unique(muni_df_wk$Date))) #test

muni_df_wk %<>%
  group_by(`Kommune_(id)`) %>%
  mutate(Pos_diff = c(0,diff(Positive)),
         Testede_diff = c(0,diff(Antal_testede))) %>%
  ungroup() 

# Figur: Positiv vs testede - kommuner med over 10 smittede fra juli, ugenumre------------------

plot_data <- muni_df_wk %>%
  filter(Date > as.Date("2020-07-01")) %>%
  group_by(`Kommune_(id)`) %>%
  filter(max(Pos_diff) > 10) %>%
  ungroup() %>%
  mutate(Pos_diff = Pos_diff * 100) %>%
  pivot_longer(cols = c(Pos_diff, Testede_diff), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(epiweek(Date) - 1, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  facet_wrap(~`Kommune_(navn)`, scales = "free") +
  scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~./100, name="Positive"),
    limits = c(0,NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Positive og testede per uge for kommuner med over 10 ugentligt positive") +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        legend.text=element_text(size=12, family="lato"),
        plot.title=element_text(face="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
ggsave("../figures/muni_10_pos_vs_test_july.png", width = 30, height = 20, units = "cm", dpi = 300)

# Figur: Positiv vs testede - alle kommuner, ugenumre------------------

plot_data <- muni_df_wk %>%
  filter(Date > as.Date("2020-07-01")) %>%
  mutate(Pos_diff = Pos_diff * 100) %>%
  pivot_longer(cols = c(Pos_diff, Testede_diff), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(epiweek(Date) - 1, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  facet_wrap(~`Kommune_(navn)`, scales = "free") +
  scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~./100, name="Positive"),
    limits = c(0,NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Positive og testede per uge for alle kommuner") +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        legend.text=element_text(size=12, family="lato"),
        plot.title=element_text(size=14, face="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/muni_all_pos_vs_test_july.png", width = 54, height = 36, units = "cm", dpi = 300)

# Figur: Procent - kommuner med over 10 smittede fra juli, ugenumre --------

  plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-07-01")) %>%
    group_by(`Kommune_(id)`) %>%
    filter(max(Pos_diff) > 10) %>%
    ungroup() %>%
      mutate(Ratio = Pos_diff/Testede_diff * 100) 
  
  
  ggplot(plot_data, aes(epiweek(Date) - 1, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~`Kommune_(navn)`, scales = "free") +
    scale_y_continuous(
      limits = c(0,8)
    ) +
    labs(y = "Procent positive", x = "Uge", title = "Procent positive per uge for kommuner med over 10 ugentligt positive") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/muni_10_pct_july.png", width = 27, height = 20, units = "cm", dpi = 300)
  
  # Figur: Procent - alle kommuner fra juli, ugenumre --------
  
  plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-07-01")) %>%
    mutate(Ratio = Pos_diff/Testede_diff * 100) 
  
  
  ggplot(plot_data, aes(epiweek(Date) - 1, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~`Kommune_(navn)`, scales = "free") +
    scale_y_continuous(
      limits = c(0,8)
    ) +
    labs(y = "Procent positive", x = "Uge", title = "Procent positive per uge for alle kommuner") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(size = 14, face="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/muni_all_pct_july.png", width = 46, height = 34, units = "cm", dpi = 300)
 
 
  # MUNICIPALITY arrange weekly - wednesday for dates from may -----------------------------------------------------
  
  
  muni_df_wk <- muni_df %>%
    filter(wday(Date) == 4) #wed consistently appears from may
  
  abs(diff(unique(muni_df_wk$Date))) #test
  
  muni_df_wk %<>%
    group_by(`Kommune_(id)`) %>%
    mutate(Pos_diff = c(0,diff(Positive)),
           Testede_diff = c(0,diff(Antal_testede))) %>%
    ungroup()  
  
  
   # Figur: Positiv vs testede - kommuner med over 10 smittede fra maj, datoer ------------------
  
  plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-05-10")) %>%
    group_by(`Kommune_(id)`) %>%
    filter(max(Pos_diff) > 10) %>%
    ungroup() %>%
    mutate(Pos_diff = Pos_diff * 100) %>%
    pivot_longer(cols = c(Pos_diff, Testede_diff), names_to = "variable", values_to = "value")
  
  ggplot(plot_data, aes(Date, value)) + 
    geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
    facet_wrap(~`Kommune_(navn)`, scales = "free") +
    scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
    scale_y_continuous(
      name = "Testede",
      sec.axis = sec_axis(~./100, name="Positive"),
      limits = c(0,NA)
    ) +
    labs(y = "Positive : Testede", x = "Dato", title = "Positive og testede per uge for kommuner med over 10 ugentligt positive") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/all_muni_pos_vs_test_may.png", width = 36, height = 24, units = "cm", dpi = 300)

  # Figur: Procent - kommuner med over 10 smittede fra maj, datoer --------


  plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-05-10")) %>%
    group_by(`Kommune_(id)`) %>%
    filter(max(Pos_diff) > 10) %>%
    ungroup() %>%
    mutate(Ratio = Pos_diff/Testede_diff * 100) 
  
  
  ggplot(plot_data, aes(Date, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~`Kommune_(navn)`, scales = "free") +
    scale_y_continuous(
      limits = c(0,8)
    ) +
    labs(y = "Procent positive", x = "Dato", title = "Procent positive per uge for kommuner med over 10 ugentligt positive") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0))) 
  
  ggsave("../figures/all_muni_pct_may.png", width = 32, height = 24, units = "cm", dpi = 300)
  
# Figur: Procent - alle kommuner, heatmap ----------

  
    plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-05-10")) %>%
    mutate(Pos_diff = ifelse(Pos_diff < 0, 0, Pos_diff)) %>%
    mutate(Ratio = Pos_diff/Testede_diff * 100) %>%
   mutate(`Kommune_(navn)`=factor(`Kommune_(navn)`,levels=rev(sort(unique(`Kommune_(navn)`)))))
  
  ggplot(plot_data, aes(Date, `Kommune_(navn)`, fill = Ratio)) + 
    geom_tile(colour="white",size=0.25) + 
    coord_fixed(ratio = 7) +
    labs(x="",y="", title="Procent positive tests per udførte tests") +
    scale_fill_continuous(name = "Procent",low =  "#00AFBB", high = "#FC4E07") +
    theme_light() + 
    theme(plot.background=element_blank(),
          panel.border=element_blank(),
          axis.ticks = element_blank(),
          plot.title=element_text(size = 14, hjust=0,face="bold"),
          text = element_text(size=13, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          axis.title.y = element_text(size=12, family="lato"),
          axis.title.x = element_text(size=12, family="lato"))
  
  ggsave("../figures/all_muni_weekly_pos_pct_tile.png",width = 16, height = 50, units = "cm", dpi = 300)
 

# Figur: Incidens - alle kommuner, heatmap ---------------------------------

  
  plot_data <- muni_df_wk %>%
    filter(Date > as.Date("2020-05-10")) %>%
    mutate(Pos_diff = ifelse(Pos_diff < 0, 0, Pos_diff)) %>%
    mutate(Ratio = Pos_diff/Befolkningstal * 100000) %>%
    mutate(`Kommune_(navn)`=factor(`Kommune_(navn)`,levels=rev(sort(unique(`Kommune_(navn)`)))))
  
  ggplot(plot_data, aes(Date, `Kommune_(navn)`, fill = Ratio)) + 
    geom_tile(colour="white",size=0.25) + 
    coord_fixed(ratio = 7) +
    labs(x="",y="", title="Antal positive tests per 100.000 indbyggere") +
    scale_fill_continuous(name = "Antal/100.000",low =  "#00AFBB", high = "#FC4E07") +
    theme_light() + 
    theme(plot.background=element_blank(),
          panel.border=element_blank(),
          axis.ticks = element_blank(),
          plot.title=element_text(size = 14, hjust=0,face="bold"),
          text = element_text(size=13, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          axis.title.y = element_text(size=12, family="lato"),
          axis.title.x = element_text(size=12, family="lato"))
  

  ggsave("../figures/all_muni_weekly_incidens_tile.png",width = 17, height = 50, units = "cm", dpi = 300)

# read and tidy ADMITTED data --------------------------------------------------

admitted <- read_csv2("../data/SSIdata_200903/Newly_admitted_over_time.csv")

admitted %<>%
  mutate(Date = as.Date(Dato)) %>%
  select(Date, Total)

date_week <- admitted %>% mutate(week = epiweek(Date - 4)) %>%
 mutate(wed = wday(Date) == 4) %>%
 filter(Date > as.Date("2020-03-11")) %>%
  filter(wed) %>%
  select(Date, week)

week_admitted <- admitted %>% mutate(week = epiweek(Date - 4)) %>%
  filter(Date > as.Date("2020-03-11")) %>%
  select(-Date) %>%
  full_join(date_week, by = "week") %>%
  group_by(Date) %>%
  summarise(value = sum(Total)) %>%
  ungroup() %>%
  mutate(variable = "admitted") %>%
  filter(!Date == "2020-03-18")


# Combine AGE, ADMITTED and group into old and young --------------------------------


young_group <- c("0-9", "10-19", "20-29", "30-39", "40-49")#, "50-59", "60-69")

wk_df_group <- week_df %>%
  filter(!Aldersgruppe == "I alt") %>%
  mutate(less_than = ifelse(Aldersgruppe %in% young_group, TRUE, FALSE)) %>% 
  select(-Aldersgruppe) %>%
  group_by(less_than, Date) %>%
  summarise_all(sum) %>%
  mutate(variable = ifelse(less_than, "young", "old")) %>%
  ungroup() %>%
  select(-less_than, -date_of_file)

wk_df_group %<>%
  group_by(variable) %>%
  mutate(value = c(0,diff(positive))) %>%
  ungroup() %>%
  select(-positive, -Antal_testede) 

data <- bind_rows(week_admitted, wk_df_group)


# Figur: Pos over 50 vs nyindlagte, fra marts -----------------------------------------------------


plot_data <- data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("old", "z_admitted")) 

ggplot(plot_data, aes(Date, value)) + 
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) + 
  scale_fill_discrete(name = "", labels = c("Pos over 50 år", "Nyindlagte")) + 
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive testede ældre vs. total nyindlagte") + 
  scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() + 
  theme(text = element_text(size=11, family="lato"),
        plot.title=element_text(face="bold"),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_admitted_pos_old.png", width = 17, height = 12, units = "cm", dpi = 300)


# Figur: Pos under 50 vs nyindlagte, fra marts -----------------------------------

plot_data <- data %>%
  mutate(value = ifelse(variable == "admitted", -value, value)) %>%
  mutate(variable = ifelse(variable == "admitted", "z_admitted", variable)) %>%
  filter(variable %in% c("young", "z_admitted")) 

ggplot(plot_data, aes(Date, value)) + 
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) + 
  scale_fill_discrete(name = "", labels = c("Pos under 50 år", "Nyindlagte")) + 
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive testede yngre vs. total nyindlagte") + 
  scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() + 
  theme(text = element_text(size=11, family="lato"),
        plot.title=element_text(face="bold"),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_admitted_pos_young.png", width = 17, height = 12, units = "cm", dpi = 300)

# Figur: Andel ung vs gammel stack, fra marts ----------------------------

plot_data <- data %>%
  filter(variable %in% c("young", "old")) 

ggplot(plot_data, aes(Date, value)) + 
  geom_bar(stat = "identity", position = "stack", aes(fill = variable)) + 
  scale_fill_discrete(name = "Alder", labels = c("Over 50 år", "Under 50 år")) + 
  labs(y = "Antal", x = "Dato", title = "Ugentligt antal positive tests for ældre og yngre") + 
  #scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() + 
  theme(text = element_text(size=11, family="lato"),
        plot.title=element_text(face="bold"),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_stack.png", width = 17, height = 12, units = "cm", dpi = 300)

# Figur: Andel ung vs gammel fill, fra marts ----------------------------

plot_data <- data %>%
  filter(variable %in% c("young", "old")) 

ggplot(plot_data, aes(Date, value)) + 
  geom_bar(stat = "identity", position = "fill", aes(fill = variable)) + 
  scale_fill_discrete(name = "Alder", labels = c("Over 50 år", "Under 50 år")) + 
  labs(y = "Andel", x = "Dato", title = "Ugentlig fordeling af positive tests mellem ældre og yngre") + 
  #scale_y_continuous(breaks = c(-500,0, 500, 1000),labels=as.character(c("500","0", "500", "1000"))) +
  theme_minimal() + 
  theme(text = element_text(size=11, family="lato"),
        plot.title=element_text(face="bold"),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_fill.png", width = 17, height = 12, units = "cm", dpi = 300)


# Figur: Pct nyindlagt per positive, fra marts -----------------------------------

plot_data <- data %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(ratio_young = admitted/young,
         ratio_old = admitted/old) %>%
  select(-admitted, -old, - young) %>%
  pivot_longer(cols = c(ratio_young, ratio_old), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Date, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  scale_color_discrete(name = "Alder", labels = c("Over 50 år", "Under 50 år")) + 
  labs(y = "Nyindlagte : positive", x = "Dato") + 
  theme_minimal() + 
  theme(text = element_text(size=11, family="lato"),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_pos_ratio_admitted.png", width = 17, height = 12, units = "cm", dpi = 300)



