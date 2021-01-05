library(tidyverse)
library(glue)
library(magrittr)
library(reticulate)
#source_python("data-raw/extract.py")

# Save .rds objects
metadata <- read_csv("data-raw/metadata.csv")
datasets_list <- lapply(paste0("data-raw/",metadata$file), read_csv)

for(i in 1:length(datasets_list)){
  assign(metadata$name[i], datasets_list[[i]])
  save(list = metadata$name[i], file = paste0("data/",metadata$name[i],".rda"))
}

# Create object documentation
metadata$rows  <- sapply(datasets_list, nrow)
metadata %<>%
  mutate(data_documentation = glue('#\' [description_short]\n#\'\n',
                                      '#\' [description_long]\n#\'\n',
                                      '#\' @format A data frame with [rows] rows and 2 variables:\n',
                                      '#\' \\describe{\n',
                                      '#\'   \\item{x}{[x], in [x_units]}\n',
                                      '#\'   \\item{y}{[y], in [y_units]}\n',
                                      '#\' }\n',
                                      '#\' @source [key]\n',
                                      '"[name]"\n\n',
                                      .open="[", .close="]"))
mapply(cat, metadata$data_documentation, file = paste0("R/", metadata$name, ".R"))

