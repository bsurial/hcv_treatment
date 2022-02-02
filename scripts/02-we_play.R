library(tidyverse)
library(bernr)
library(here)



# Custom functions --------------------------------------------------------

# Read files directly from "processed" folder
pro_read <- function(file) {
  read_rds(here("processed", file))
  # read_rds(paste0("processed/", x))
}




# Read data ---------------------------------------------------------------
pat <- pro_read("pat.rds")
lab <- pro_read("lab.rds")





# Find HCV positives ------------------------------------------------------

hcv_pos <- lab %>% 
  select(id, hcv_rna, hcv_rna_date) %>% 
  filter(!is.na(hcv_rna_date)) %>% 
  group_by(id) %>%
  summarise(any_hcv_rna = any(hcv_rna >= 50, na.rm = TRUE)) %>% 
  filter(any_hcv_rna == TRUE)


  
  
