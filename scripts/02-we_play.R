library(tidyverse)
library(bernr)
library(here)
library(gtsummary)



# Custom functions --------------------------------------------------------

# Read files directly from "processed" folder
pro_read <- function(file) {
  read_rds(here("processed", file))
  # read_rds(paste0("processed/", x))
}




# Read data ---------------------------------------------------------------
pat <- pro_read("pat.rds")
lab <- pro_read("lab.rds")
tail <- pro_read("tail.rds")




# Find HCV positives ------------------------------------------------------

hcv_pos <- lab %>% 
  select(id, hcv_rna, hcv_rna_date) %>% 
  filter(!is.na(hcv_rna_date)) %>% 
  group_by(id) %>%
  summarise(any_hcv_rna = any(hcv_rna >= 50, na.rm = TRUE)) %>% 
  filter(any_hcv_rna == TRUE)





# Add demographics --------------------------------------------------------
demographics <- tail %>% 
  select(id, sex, born, riskgroup)


full <- hcv_pos %>% 
  left_join(demographics)



full %>% 
  select(-id) %>% 
  mutate(age = 2022 - born) %>% 
  select(-born) %>% 
  tbl_summary(by = sex, missing = "always") %>% 
  add_overall()



  

# Write data --------------------------------------------------------------

write_rds(full, here("processed", "02-study_population.rds"))





  
  
