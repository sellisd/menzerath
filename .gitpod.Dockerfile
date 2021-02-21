FROM rocker/tidyverse
RUN R -e 'install.packages("generics")'
RUN R -e 'install.packages("glue")'

RUN R -e 'install.packages("knitr")'
RUN R -e 'install.packages("rmarkdown")'
RUN R -e 'install.packages("cowplot")'
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("kableExtra")'
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'install.packages("devtools")'

RUN R -e 'install.packages("Rcpp")'

RUN apt-get update \
  && apt-get install -y clang

RUN R -e 'devtools::install_github("sellisd/menzerath", type="source", upgrade="always")'

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
