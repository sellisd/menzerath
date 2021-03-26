test_that("process annotated text", {
  text <- "Greece* {which* is* the* most* beau*ti*ful* coun*try* +I* know* +}was* the* first* place* +we* vi*si*ted* in* Eu*ro*pe* +."
  construct_delimiter <- '+'
  constituent_delimiter <- ' '
  subconstituent_delimiter <- '*'
  discontinued_constituent_delimiter_begin <- '{'
  discontinued_constituent_delimiter_end <- '}'
  expect_identical(data.frame("constituents"=as.integer(c(6,2,5,4)),
                              "subconstituents"=as.integer(c(9,2,5,8))),
                   process_text(text, construct_delimiter, constituent_delimiter, subconstituent_delimiter,
                                discontinued_constituent_delimiter_begin,
                                discontinued_constituent_delimiter_end)[,1:2])
})

test_that("validate unbalanced discontinued constituent delimiters in annotated text", {
  text <- "]["
  construct_delimiter <- '+'
  constituent_delimiter <- ' '
  subconstituent_delimiter <- '*'
  discontinued_constituent_delimiter_begin <- '['
  discontinued_constituent_delimiter_end <- ']'
  expect_identical(data.frame("Errors"=as.integer(c(1))),
                   process_text(text, construct_delimiter, constituent_delimiter, subconstituent_delimiter,
                                discontinued_constituent_delimiter_begin,
                                discontinued_constituent_delimiter_end))
})

test_that("process annotated text", {
  text <- "Greece* {which* is* the* most* beau*ti*ful* coun*try*+I* know* +}was* the* first* place* +we* vi*si*ted* in* Eu*ro*pe* +."
  construct_delimiter <- '+'
  constituent_delimiter <- ' '
  subconstituent_delimiter <- '*'
  discontinued_constituent_delimiter_begin <- '{'
  discontinued_constituent_delimiter_end <- '}'
  expect_identical(data.frame("Errors"=as.integer(c(2))),
                   process_text(text, construct_delimiter, constituent_delimiter, subconstituent_delimiter,
                                discontinued_constituent_delimiter_begin,
                                discontinued_constituent_delimiter_end))
})

test_that("process annotated text", {
  text <- "Greece* {which* is* the* most beau*ti*ful* coun*try* +I* know* +}was* the* first* place* +we* vi*si*ted* in* Eu*ro*pe* +."
  construct_delimiter <- '+'
  constituent_delimiter <- ' '
  subconstituent_delimiter <- '*'
  discontinued_constituent_delimiter_begin <- '{'
  discontinued_constituent_delimiter_end <- '}'
  expect_identical(data.frame("Errors"=as.integer(c(3))),
                   process_text(text, construct_delimiter, constituent_delimiter, subconstituent_delimiter,
                                discontinued_constituent_delimiter_begin,
                                discontinued_constituent_delimiter_end))
})
