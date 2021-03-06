% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{process_text}
\alias{process_text}
\title{Process annotated text}
\usage{
process_text(
  text,
  construct_delimiter,
  constituent_delimiter,
  subconstituent_delimiter,
  discontinued_constituent_delimiter_begin,
  discontinued_constituent_delimiter_end
)
}
\arguments{
\item{text}{string}

\item{construct_delimiter}{char}

\item{constituent_delimiter}{char}

\item{subconstituent_delimiter}{char}

\item{discontinued_constituent_delimiter_begin}{char}

\item{discontinued_constituent_delimiter_end}{char}
}
\value{
data.frame A data.frame with three columns: constituents, subconstituents and constructs
}
\description{
Process annotated text
}
\examples{
annotated_text <- paste0("Greece* {which* is* the* most* beau*ti*ful* coun*try*",
                        " +I* know* +}was* the* first* place* +we* vi*si*ted* in*",
                        "Eu*ro*pe* +.")
 counts_df <- process_text(annotated_text, "+", " ", "*", "{", "}")
}
