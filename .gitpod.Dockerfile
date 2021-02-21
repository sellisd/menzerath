FROM rocker/tidyverse
RUN R -e 'install.packages("generics")'
RUN R -e 'install.packages("glue")'

RUN R -e 'install.packages("knitr")'
RUN R -e 'install.packages("rmarkdown")'
RUN R -e 'install.packages("cowplot")'
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("kableExtra")'
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'install.packages("biomaRt")'
RUN R -e 'install.packages("devtools")'

RUN R -e 'install.packages("Rcpp")'

RUN apt-get update \
  && apt-get install -y clang

RUN R -e 'install.packages("devtools")'
RUN R -r 'devtools::install_github("sellisd/menzerath", type="source")'
