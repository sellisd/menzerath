library(generics)

#' @importFrom generics fit
#' @export
generics::fit

#' Return parameters of the Menzerath-Altmann law.
#'
#'  The parameters of equation \eqn{y = a \cdot x^b \cdot e^{-cx}} are
#'  estimated after taking logs
#'  \eqn{log(y) = log(a) + b \cdot log(x) - c \cdot x}}
#'
#' @param x An object with class lm
#'
#' @return named list with a, b and c
#' @export
#'
get_parameters <- function(x){
  if(!is(x,"lm")){
    stop("Expecting an lm fit")
  }
  list(a = exp(summary(x)$coefficients[1]),
       b = summary(x)$coefficients[2],
       c = -summary(x)$coefficients[3])
}

#' @export
fit.menzerath <- function(object, ...){
  fit <- lm(log(object$y) ~ log(object$x) + object$x, as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...)
}


#' @export
predict.menzerath <- function(object, ...){
  predict(fit.menzerath(object), interval = "confidence", ...)
}


#' @export
print.menzerath <- function(x, ...){
  glue::glue('Observations: {length(x$x)}\n',
       'y: {paste(head(x$y), collapse=",")}...\n',
       'x: {paste(head(x$x), collapse=",")}...')
}

#' @export
plot.menzerath <- function(x, fit = NULL, ...){
  p <- (ggplot2::ggplot(data = x, ggplot2::aes(x=log(x), y=log(y))) +
          ggplot2::geom_point(...))
  if(is.null(fit)){
    # no prediction plot raw data
    p
  }else if(isTRUE(fit)){
    # fit and then plot
    predict_fit <- predict.menzerath(x)
    p + ggplot2::geom_ribbon(ggplot2::aes(ymin=predict_fit[,"lwr"], ymax=predict_fit[,"upr"]), alpha=0.1, fill="blue") +
      ggplot2::geom_line(ggplot2::aes(y=predict_fit[,"fit"]))
    p + ggplot2::geom_ribbon(ggplot2::aes(ymin=predict_fit[,"lwr"], ymax=predict_fit[,"upr"]), alpha=0.1, fill="blue") +
      ggplot2::geom_line(ggplot2::aes(y=predict_fit[,"fit"]))
  }else{
    p
  }
}


#' @export
menzerath <- function(tb=tibble(), x = "x", y = "y"){
  # A class to data following the Menzerath-Altman law
  if(!tibble::is_tibble(tb)){
    stop("Constructor expects a tibble")
  }
  m <- tb[c(x, y)]
  names(m) <- c("x","y")
  structure(m,
            x_name = x,
            y_name = y,
            class = c("menzerath", class(m)))
}

