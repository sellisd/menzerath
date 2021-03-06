% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/menzerath.R
\name{menzerath}
\alias{menzerath}
\title{A class to describe and plot data following the Menzerath-Altman law}
\usage{
menzerath(tb = tibble(), x = "x", y = "y")
}
\arguments{
\item{tb}{data.frame or tibble, A table with the data}

\item{x}{String, The column name containing the construct size}

\item{y}{String, The column name containing the average constituent size}
}
\description{
To initialize the menzerath object we need a data.frame or a tibble with at
least two columns:
- Size of construct (L_n) measured in units of
  its direct constituents
- Average size of constituents (L_{n-1}) measured in units of its direct
  subconstituents
}
