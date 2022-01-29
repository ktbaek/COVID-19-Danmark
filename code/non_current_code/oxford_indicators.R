# library(tidyverse)
# library(magrittr)
# library(lubridate)
# library(scales)
# library(colorspace)

oxford_df <- read_csv("../data/blavatnik-stringency-index.csv") # covid-policy-tracker/data/OxCGRT_latest.csv

# Make a vector of the indicators that have flags
flags <- colnames(oxford_df)[str_detect(colnames(oxford_df), "Flag")] %>%
  str_sub(1, 2)

# Make a look-up table of indicator code ~ description
indicator_names <- as.tibble(colnames(oxford_df)[str_detect(colnames(oxford_df), "_") & !str_detect(colnames(oxford_df), "Flag")]) %>%
  separate(value, into = c("Indicator", "Description"), sep = "_")

# Make a look-up table of iso_alpha_3 codes ~ country names
country_names <- oxford_df %>%
  rename(
    Iso_a3 = CountryCode,
    Country = CountryName
  ) %>%
  select(Iso_a3, Country) %>%
  distinct()

# Make a look-up table of indicator code ~ N (number of steps on ordinal scale)
indicator_len <- tribble(
  ~Indicator, ~N,
  "C1", 3,
  "C2", 3,
  "C3", 2,
  "C4", 4,
  "C5", 2,
  "C6", 3,
  "C7", 2,
  "C8", 4,
  "E1", 2,
  "E2", 2,
  "H1", 2,
  "H2", 3,
  "H3", 2,
  "H6", 4,
  "H7", 5
)

# Make a long dataframe with indicator-code, value and whether the indicator has a flag
df_1 <- oxford_df %>%
  filter(Jurisdiction == "NAT_TOTAL") %>%
  rename(Iso_a3 = CountryCode) %>%
  mutate(Date = ymd(Date)) %>%
  select(Date, Iso_a3, "C1_School closing":H7_Flag) %>%
  select(!ends_with("Flag")) %>%
  rename_with(~ str_sub(.x, 1, 2), is.numeric) %>%
  pivot_longer(c(-Date, -Iso_a3), names_to = "Indicator", values_to = "Value") %>%
  mutate(Flag = ifelse(Indicator %in% flags, TRUE, FALSE))

# Make a long dataframe with indicator-code and flag-value
df_2 <- oxford_df %>%
  filter(Jurisdiction == "NAT_TOTAL") %>%
  rename(Iso_a3 = CountryCode) %>%
  mutate(Date = ymd(Date)) %>%
  select(Date, Iso_a3, "C1_School closing":H7_Flag) %>%
  select(Date, Iso_a3, ends_with("Flag")) %>%
  mutate(across(c(C1_Flag:H7_Flag), as.integer)) %>%
  rename_with(~ str_sub(.x, 1, 2), is.numeric) %>%
  pivot_longer(c(-Date, -Iso_a3), names_to = "Indicator", values_to = "Flag_value")

# Combine all variables and calculate sub-index score
df_3 <- df_1 %>%
  full_join(df_2, by = c("Date", "Iso_a3", "Indicator")) %>%
  filter(Indicator %in% indicator_len$Indicator) %>%
  full_join(indicator_len, by = "Indicator") %>%
  mutate(
    Flag_value = replace_na(Flag_value, 0),
    Value_na_zero = replace_na(Value, 0)
  ) %>%
  mutate(Score = ifelse(Value_na_zero == 0, 0, 100 * (Value_na_zero - 0.5 * (Flag - Flag_value)) / N))

# Make long dataframe with all sub-index scores and add indicator descriptions and country names
df_4_long <- df_3 %>%
  select(Date, Iso_a3, Indicator, Score) %>%
  full_join(country_names, by = "Iso_a3") %>%
  inner_join(indicator_names, by = "Indicator")

# Make wide dataframe with all sub-index scores and add country names
df_4_wide <- df_4_long %>%
  select(-Description) %>%
  pivot_wider(names_from = Indicator, values_from = Score)

# Test that my calculated stringency index (SI) arrives to the same values as Oxford Stringency Index:
# Calculate stringency index (SI) using the same indicators as Oxford Stringency Index
index_df <- df_4_wide %>%
  rowwise() %>%
  mutate(SI = round(mean(c(C1, C2, C3, C4, C5, C6, C7, C8, H1), na.rm = TRUE), 2))

# Make long dataframe with Oxford Stringency Index for convenience
OSI_df <- oxford_df %>%
  filter(Jurisdiction == "NAT_TOTAL") %>%
  rename(Iso_a3 = CountryCode) %>%
  mutate(Date = ymd(Date)) %>%
  select(Date, Iso_a3, StringencyIndex)

# If the following dataframe is empty, the two indices are identical, and my calculation is correct.
OSI_df %>%
  full_join(index_df, by = c("Date", "Iso_a3")) %>%
  mutate(test = SI == StringencyIndex) %>%
  filter(!test)

# Now that I have checked that the sub-index scores are calculated correctly (= formula correct), I recalculate the scores to fill in NAs with last non-NA value (to avoid dips to zero especially at the end).
df_4_long <- df_3 %>%
  mutate(Score = ifelse(Value == 0, 0, 100 * (Value - 0.5 * (Flag - Flag_value)) / N)) %>%
  group_by(Iso_a3, Indicator) %>%
  fill(Score, .direction = "down") %>%
  ungroup() %>%
  select(Date, Iso_a3, Indicator, Score) %>%
  full_join(country_names, by = "Iso_a3") %>%
  inner_join(indicator_names, by = "Indicator")

df_4_wide <- df_4_long %>%
  select(-Description) %>%
  pivot_wider(names_from = Indicator, values_from = Score)
