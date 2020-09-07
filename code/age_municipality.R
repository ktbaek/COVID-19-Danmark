library(tidyverse)
library(magrittr)
library(lubridate)

Sys.setlocale("LC_ALL", "da_DK.UTF-8")

today <- "2020-09-04"

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

ssi_filer_date <- ssi_filer$date

ssi_filer_date %<>% c(ssi_filer_date, "200903", "200904")


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

abs(diff(unique(age_df$Date))) #test


# AGE arrange weekly ------------------------------------------------------

week_df <- age_df %>%
  filter(wday(Date) == 4) #wednesday because it consistently appears throughout (e.g mondays can be holidays)

early_data <- read_csv2("../data/early_age_reports.csv")

week_df %<>% bind_rows(early_data) %>% arrange(Date)



# read and tidy MUNICIPALITY data -----------------------------------------

# read_muni_csv <- function(x) {
#   file <- read_csv2(paste0("../data/SSIdata_", x, "/Municipality_test_pos.csv"))
#   file %<>% mutate(date_of_file = x)   %>%
#     mutate(Date = paste0("2020-", str_sub(date_of_file,3,4), "-", str_sub(date_of_file,5,6)))
# 
#   return(file)
# 
# }
# 
# csv_list <- lapply(ssi_filer$date, read_muni_csv)
# 
# muni_df <- bind_rows(csv_list)
# 
# muni_df %<>%
#   mutate(Positive = ifelse(`Antal_bekræftede_COVID-19` == "<10", 10, `Antal_bekræftede_COVID-19`)) %>%
#   mutate(Positive = as.numeric(gsub("\\.", "", Positive))) %>%
#   mutate(Date = as.Date(Date)) %>%
#   select(-date_of_file) %>%
#   arrange(Date)
# 
# muni_df <- bind_cols(muni_df, data.frame("Dage_siden_sidst" = rep(c(0,abs(diff(unique(muni_df$Date)))), each = 99)))
# 
# muni_df %<>%
#   group_by(`Kommune_(id)`) %>%
#   mutate(Pos_diff = c(0,diff(Positive)),
#          Testede_diff = c(0,diff(Antal_testede))) %>%
#   ungroup()
# 
# 
# muni_df %>% write.csv2("../data/municipality_over_time_combined.csv")

today_string <- paste0(str_sub(today, 3, 4), str_sub(today, 6, 7), str_sub(today, 9, 10))

muni_pos <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_cases_time_series.csv"))
muni_tested <- read_csv2(paste0("../data/SSIdata_", today_string, "/Municipality_tested_persons_time_series.csv"))

muni_pos %<>%
  mutate(Date = as.Date(date_sample)) %>%
  select(-date_sample) %>%
  pivot_longer(cols = -(Date), names_to = "Kommune", values_to = "Positive") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_tested %<>%
  mutate(Date = as.Date(PrDate_adjusted)) %>%
  select(-PrDate_adjusted, -X101) %>%
  pivot_longer(cols = -(Date), names_to = "Kommune", values_to = "Tested") %>%
  mutate(Kommune = ifelse(Kommune == "Copenhagen", "København", Kommune))

muni_all <- muni_tested %>% full_join(muni_pos, by = c("Kommune", "Date")) %>%
  filter(Date > as.Date("2020-02-29"))

abs(diff(unique(muni_all$Date))) #test for daily continuity

#test that the numbers in 'test_pos_over_time' from SSI agree with the total for all municipalities in the municaplity files from SSI
tests_check <- tests %>% 
  select(Date, NewPositive, Tested)

muni_tests_check <- muni_all %>% 
  group_by(Date) %>%
  summarize(Pos_total = sum(Positive, na.rm = TRUE),
            Tested_total = sum(Tested, na.rm = TRUE)) %>%
  ungroup() %>%
  full_join(tests_check, by = "Date")

#Result: not 100% agree: numbers in the two datasets sometimes differ by a few cases. I don't know why, ask SSI. 


# MUNICIPALITY arrange weekly - monday for weeknumbers -----------------------------------------------------

# muni_df_wk <- muni_df %>%
#   filter(wday(Date) == 2) #mondays  consistently appears from july
# 
# muni_df_wk %<>%
#   group_by(`Kommune_(id)`) %>%
#   mutate(Pos_diff = c(0,diff(Positive)),
#          Testede_diff = c(0,diff(Antal_testede))) %>%
#   ungroup() 

muni_all %<>%
  filter(Date < as.Date(today)- 1) #remove last two days

muni_wk <- muni_all %>%
  mutate(Week = isoweek(Date)) %>%
  mutate(Week_end_Date = ceiling_date(Date, unit = "week", getOption("lubridate.week.start", 0)))

muni_wk %<>%
  filter(Week < isoweek(as.Date(today))) %>% #remove current week
  group_by(Week, Kommune) %>%
  mutate(Positive_wk = sum(Positive, na.rm = TRUE),
            Tested_wk = sum(Tested, na.rm = TRUE)) %>%
  ungroup() %>%
  select(-Date, -Positive, -Tested) %>%
  distinct()

# Figur: Positiv vs testede - kommuner med over 10 smittede fra juli, ugenumre------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  group_by(Kommune) %>%
  filter(max(Positive_wk) > 10) %>%
  ungroup() %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  facet_wrap(~Kommune, scales = "free") +
  scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~./100, name="Positive"),
    limits = c(0,NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Nye positive og testede per uge for kommuner med flest positive per uge") +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        legend.text=element_text(size=12, family="lato"),
        plot.title=element_text(face="bold"),
        strip.text = element_text(face ="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
ggsave("../figures/muni_10_pos_vs_test_july.png", width = 30, height = 20, units = "cm", dpi = 300)

# Figur: Positiv vs testede - alle kommuner, ugenumre------------------

plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
  mutate(Positive_wk = Positive_wk * 100) %>%
  pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")

ggplot(plot_data, aes(Week, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  facet_wrap(~Kommune, scales = "free") +
  scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~./100, name="Positive"),
    limits = c(0,NA)
  ) +
  labs(y = "Positive : Testede", x = "Uge", title = "Nye positive og testede per uge for alle kommuner") +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        legend.text=element_text(size=12, family="lato"),
        plot.title=element_text(size=14, face="bold"),
        strip.text = element_text(face ="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/muni_all_pos_vs_test_july.png", width = 54, height = 36, units = "cm", dpi = 300)

# Figur: Procent - kommuner med over 10 smittede fra juli, ugenumre --------

  plot_data <- muni_wk %>%
  filter(Week_end_Date > as.Date("2020-07-07")) %>%
    group_by(Kommune) %>%
    filter(max(Positive_wk) > 10) %>%
    ungroup() %>%
    mutate(Ratio = Positive_wk/Tested_wk * 100) 
  
  
  ggplot(plot_data, aes(Week, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~Kommune, scales = "free") +
    scale_y_continuous(
      limits = c(0,5)
    ) +
    labs(y = "Procent positive", x = "Uge", title = "Procent positive per uge for kommuner med flest positive per uge") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          strip.text = element_text(face ="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/muni_10_pct_july.png", width = 27, height = 20, units = "cm", dpi = 300)
  
  # Figur: Procent - alle kommuner fra juli, ugenumre --------
  
  plot_data <- muni_wk %>%
    filter(Week_end_Date > as.Date("2020-07-07")) %>%
    mutate(Ratio = Positive_wk/Tested_wk * 100)  
  
  
  ggplot(plot_data, aes(Week, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~Kommune, scales = "free") +
    scale_y_continuous(
      limits = c(0,5)
    ) +
    labs(y = "Procent positive", x = "Uge", title = "Procent positive per uge for alle kommuner") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(size = 14, face="bold"),
          strip.text = element_text(face ="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/muni_all_pct_july.png", width = 46, height = 34, units = "cm", dpi = 300)

  
   # Figur: Positiv vs testede - kommuner med over 10 smittede fra april, datoer ------------------
  
  plot_data <- muni_wk %>%
    filter(Week_end_Date > as.Date("2020-04-07")) %>%
    group_by(Kommune) %>%
    filter(max(Positive_wk) > 10) %>%
    ungroup() %>%
    mutate(Positive_wk = Positive_wk * 100) %>%
    pivot_longer(cols = c(Positive_wk, Tested_wk), names_to = "variable", values_to = "value")
  
  ggplot(plot_data, aes(Week_end_Date, value)) + 
    geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
    facet_wrap(~Kommune, scales = "free") +
    scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
    scale_y_continuous(
      name = "Testede",
      sec.axis = sec_axis(~./100, name="Positive"),
      limits = c(0,NA)
    ) +
    labs(y = "Positive : Testede", x = "Dato", title = "Nye positive og testede per uge for kommuner med flest positive per uge") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          strip.text = element_text(face ="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))
  
  ggsave("../figures/muni_10_pos_vs_test_april.png", width = 42, height = 27, units = "cm", dpi = 300)

  # Figur: Procent - kommuner med over 10 smittede fra april, datoer --------


  plot_data <- muni_wk %>%
    filter(Week_end_Date > as.Date("2020-04-07")) %>%
    group_by(Kommune) %>%
    filter(max(Positive_wk) > 10) %>%
    ungroup() %>%
    mutate(Ratio = Positive_wk/Tested_wk * 100) 
  
  
  ggplot(plot_data, aes(Week_end_Date, Ratio)) + 
    geom_bar(stat = "identity", position = "stack", fill = "#FF6666") + 
    facet_wrap(~Kommune, scales = "free") +
    scale_y_continuous(
      limits = c(0,20)
    ) +
    labs(y = "Procent positive", x = "Dato", title = "Procent positive per uge for kommuner med flest positive per uge") +
    theme_minimal() + 
    theme(text = element_text(size=9, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          plot.title=element_text(face="bold"),
          strip.text = element_text(face ="bold"),
          axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
          axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
          axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0))) 
  
  ggsave("../figures/muni_10_pct_april.png", width = 32, height = 24, units = "cm", dpi = 300)
  
# Figur: Procent - alle kommuner, heatmap ----------

  
  plot_data <- muni_wk %>%
    filter(Week_end_Date > as.Date("2020-04-07")) %>%
    mutate(Ratio = Positive_wk/Tested_wk * 100) %>%
    mutate(Kommune=factor(Kommune,levels=rev(sort(unique(Kommune)))))
  
  
  ggplot(plot_data, aes(Week_end_Date, Kommune, fill = Ratio)) + 
    geom_tile(colour="white",size=0.25) + 
    coord_fixed(ratio = 7) +
    labs(x="",y="", title="Procent positive tests per udførte tests") +
    scale_fill_continuous(name = "Procent",low =  "#00AFBB", high = "#FC4E07", na.value = "White") +
    theme_light() + 
    theme(plot.background=element_blank(),
          panel.border=element_blank(),
          axis.ticks = element_blank(),
          plot.title=element_text(size = 14, hjust=0.5, face="bold"),
          text = element_text(size=13, family="lato"),
          legend.text=element_text(size=12, family="lato"),
          axis.title.y = element_text(size=12, family="lato"),
          axis.title.x = element_text(size=12, family="lato"))
  
  ggsave("../figures/all_muni_weekly_pos_pct_tile.png",width = 16, height = 50, units = "cm", dpi = 300)
 

# Figur: Incidens - alle kommuner, heatmap ---------------------------------

  
  # plot_data <- muni_wk %>%
  #   filter(Week_end_Date > as.Date("2020-04-07")) %>%
  #   mutate(Ratio = Pos_diff/Befolkningstal * 100000) %>%
  #   mutate(`Kommune_(navn)`=factor(`Kommune_(navn)`,levels=rev(sort(unique(`Kommune_(navn)`)))))
  # 
  # ggplot(plot_data, aes(Date, `Kommune_(navn)`, fill = Ratio)) + 
  #   geom_tile(colour="white",size=0.25) + 
  #   coord_fixed(ratio = 7) +
  #   labs(x="",y="", title="Antal positive tests per 100.000 indbyggere") +
  #   scale_fill_continuous(name = "Antal/100.000",low =  "#00AFBB", high = "#FC4E07") +
  #   theme_light() + 
  #   theme(plot.background=element_blank(),
  #         panel.border=element_blank(),
  #         axis.ticks = element_blank(),
  #         plot.title=element_text(size = 14, hjust=0.5, face="bold"),
  #         text = element_text(size=13, family="lato"),
  #         legend.text=element_text(size=12, family="lato"),
  #         axis.title.y = element_text(size=12, family="lato"),
  #         axis.title.x = element_text(size=12, family="lato"))
  # 
  # 
  # ggsave("../figures/all_muni_weekly_incidens_tile.png",width = 17, height = 50, units = "cm", dpi = 300)

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
        plot.title=element_text(face="bold", hjust = 0.5),
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
        plot.title=element_text(face="bold", hjust = 0.5),
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
        plot.title=element_text(face="bold", hjust = 0.5),
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
        plot.title=element_text(face="bold", hjust = 0.5),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_group_fill.png", width = 17, height = 12, units = "cm", dpi = 300)

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0,diff(value))) %>%
  mutate(value = ifelse(variable == "positive", value * 100, value))

ggplot(plot_data, aes(Date, value)) + 
  geom_line(stat = "identity", position = "identity", size = 2, aes(color = variable)) + 
  facet_wrap(~Aldersgruppe, scales = "free") +
  scale_color_discrete(name = "", labels = c("Positive", "Testede")) +
  scale_y_continuous(
    name = "Testede",
    sec.axis = sec_axis(~./100, name="Positive"),
    limits = c(0,50000)
  ) +
  labs(y = "Positive : Testede", x = "Dato", title = "Positive og testede per uge for hver aldersgruppe") +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        legend.text=element_text(size=12, family="lato"),
        plot.title=element_text(size=12, face="bold"),
        strip.text = element_text(face ="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_groups_pos_tested.png", width = 30, height = 15, units = "cm", dpi = 300)

plot_data <- week_df %>%
  select(-date_of_file) %>%
  filter(!Aldersgruppe == "I alt") %>%
  rename(Testede = Antal_testede) %>%
  pivot_longer(cols = c(positive, Testede), names_to = "variable", values_to = "value") %>%
  group_by(Aldersgruppe, variable) %>%
  mutate(value = c(0,diff(value))) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(Ratio = positive/Testede * 100) 

ggplot(plot_data, aes(Date, Ratio)) + 
  geom_bar(stat = "identity", position = "stack", fill = "#FF6666") +
  facet_wrap(~Aldersgruppe, scales = "free")  +
  labs(y = "Procent", x = "Dato", title = "Procent positive per uge for hver aldersgruppe") +
  scale_y_continuous(
    limits = c(0,17)
  ) +
  theme_minimal() + 
  theme(text = element_text(size=9, family="lato"),
        plot.title=element_text(size=12, face="bold"),
        strip.text = element_text(face ="bold"),
        axis.title.y = element_text(size=12, family="lato", margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.y.right = element_text(size=12, family="lato", margin = margin(t = 0, r = 0, b = 0, l = 20)),
        axis.title.x = element_text(size=12, family="lato", margin = margin(t = 20, r = 0, b = 0, l = 0)))

ggsave("../figures/age_groups_pct.png", width = 22, height = 14, units = "cm", dpi = 300)


