FROM rocker/tidyverse
RUN R -e 'install.packages("generics")'
RUN R -e 'install.packages("glue")'
RUN R -e 'install.packages("tibble")'
RUN R -e 'install.packages("stats")'
RUN R -e 'install.packages("methods")'
RUN R -e 'install.packages("ggplot")'

RUN R -e 'install.packages("knitr")'
RUN R -e 'install.packages("rmarkdown")'
RUN R -e 'install.packages("cowplot")'
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("kableExtra")'
RUN R -e 'install.packages("biomaR")'
