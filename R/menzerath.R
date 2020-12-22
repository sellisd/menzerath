library(ggplot2)
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
  predict(fit(object), interval = "confidence", ...)
}


#' @export
print.menzerath <- function(x, ...){
  glue('Observations: {length(x$x)}\n',
       'y: {paste(head(x$y), collapse=",")}...\n',
       'x: {paste(head(x$x), collapse=",")}...')
}

#' @export
plot.menzerath <- function(x, fit = NULL, ...){
  p <- (ggplot(data = x, aes(x=log(x), y=log(y))) +
          geom_point(alpha=0.1))
  if(is.null(fit)){
    # no prediction plot raw data
    p
  }else if(isTRUE(fit)){
    # fit and then plot
    predict_fit <- predict(x)
    p + geom_ribbon(aes(ymin=predict_fit[,"lwr"], ymax=predict_fit[,"upr"]), alpha=0.1, color="red") +
      geom_line(aes(y=predict_fit[,"fit"]))
    p + geom_ribbon(aes(ymin=fit[,"lwr"], ymax=fit[,"upr"]), alpha=0.1, color="red") +
      geom_line(aes(y=fit[,"fit"]))
  }
}


#' @export
menzerath <- function(tb=tibble(), x = "x", y = "y"){
  # A class to data following the Menzerath-Altman law
  if(!is_tibble(tb)){
    stop("Constructor expects a tibble")
  }
  m <- tb[c(x, y)]
  names(m) <- c("x","y")
  structure(m,
            x_name = x,
            y_name = y,
            class = c("menzerath", class(m)))
}

