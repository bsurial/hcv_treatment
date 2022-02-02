library(tidyverse)
library(haven)

# current shcs download
dir <- "data/2103stata/"

# Reading stata files and zip off all attributes
clean_dta <- function(df) {
  df %>% 
    sjlabelled::remove_label() %>% # remove labels
    zap_formats() %>% 
    mutate_if(is.character, na_if, "") # "" to NA in character columns
}

# Read from processed folder
pro_read <- function(file) {
  read_rds(here::here("processed", file))
}


# Get all files in SHCS folder
files <- list.files(path = dir)
files_full <- str_c(dir, files)
names <- str_remove(files, ".dta")

# Read them into a list
all <- map(files_full, read_dta, encoding = "latin1")

# Set names to dta names
names(all) <-  names

# Zipp off all attributes using own function
all <- map(all, clean_dta)

# Write into processed folder
walk2(all, names, ~write_rds(.x, str_c("processed/", .y, ".rds")))

