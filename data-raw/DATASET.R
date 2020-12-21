library(tidyverse)
library(glue)
library(reticulate)
#source_python("data-raw/extract.py")
metadata <- read_csv("data-raw/metadata.csv")

for(row in 1:nrow(metadata)){
  file_name = paste0("data-raw/",pull(metadata[row,"file"]))
  dataset_name = pull(metadata[row,"name"])
  if(file.exists(file_name)){
    data_title = pull(metadata[row,"description_short"])
    description = pull(metadata[row,"description_long"])
    itemX = pull(metadata[row,"x"])
    itemX_units = pull(metadata[row,"x_units"])
    itemY = pull(metadata[row,"y"])
    itemY_units = pull(metadata[row,"y_units"])
    key = pull(metadata[row,"key"])
    print(dataset_name)
    assign(dataset_name,read_csv(file_name))
    # Update data documentation
    data_documentation <- glue( '#\' [data_title]\n#\'\n',
                                '#\' [description]\n#\'\n',
                                '#\' @format A data frame with [nrow(get(dataset_name))] rows and 2 variables:\n',
                                '#\' \\describe{\n',
                                '#\'   \\item{[itemX]}{[itemX], in [itemX_units]}\n',
                                '#\'   \\item{[itemY]}{[itemY], in [itemY_units]}\n',
                                '#\' }\n',
                                '#\' @source [key]\n',
                                '"[dataset_name]"',
                                .open="[", .close="]")
    docr_file <- file(glue("R/{dataset_name}.R"), "w")
    writeLines(data_documentation, con = docr_file)
    close(docr_file)
    save(dataset_name, file = glue("data/{dataset_name}.rda"))
    usethis::use_data(dataset_name, overwrite = TRUE)
  }
}

