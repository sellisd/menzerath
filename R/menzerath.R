#' @importFrom glue glue
#' @importFrom tibble is_tibble tibble
#' @importFrom stats lm predict
#' @importFrom methods is
#' @importFrom generics fit
#' @export
generics::fit

#' Density function for Menzerath-Altmann law
#'
#' @param x          single number or numeric vector
#' @param method     one of MAL (default), simplified_1, simplified_2, Milicka_1, Milicka_2, Milicka_4, Milicka_8
#' @param parameters named vector for parameters a, b and c
#'
#' @return single number or numeric vector
#' @export
dmenzerath <- function(x, parameters, method = "MAL"){
    switch(method,
           "MAL" = parameters['a']*x^parameters['b']*exp(-parameters['c']*x),
           "simplified_1" = parameters['a']*exp(-parameters['c']*x),
           "simplified_2" = parameters['a']*x^parameters['b'],
           "Milicka_1" = parameters['a']*x^(-parameters['b'])*exp(parameters['c']*x),
           "Milicka_2" = parameters['a']*x^(-parameters['b']),
           "Milicka_4" = parameters['a'] + parameters['b']/x,
           "Milicka_8" = parameters['a'] + parameters['b']/x + parameters['c']*min(1, x-1)/x,
           stop(paste("Unknown method:", method))
    )
}

#' Return parameters of the Menzerath-Altmann law.
#'
#'  The parameters are estimated after taking logs
#'
#' @param x An object with class lm
#'
#' @return named list with a, b and c
#' @export
get_parameters <- function(x){
  if(!is(x,"lm")){
    stop("Expecting an lm fit")
  }
  if(is(x, "MAL")){
    return(list(a = exp(summary(x)$coefficients[1]),
                b = summary(x)$coefficients[2],
                c = -summary(x)$coefficients[3]))
  }else if(is(x, "simplified_1")){
    return(list(a = exp(summary(x)$coefficients[1]),
                c = -summary(x)$coefficients[2]))
  }else if(is(x, "simplified_2")){
    return(list(a = exp(summary(x)$coefficients[1]),
                b = summary(x)$coefficients[2]))
  }else if(is(x, "Milicka_1")){
    return(list(a = exp(summary(x)$coefficients[1]),
                b = -summary(x)$coefficients[2],
                c = summary(x)$coefficients[3]))
  }else if(is(x, "Milicka_2")){
    return(list(a = exp(summary(x)$coefficients[1]),
                b = -summary(x)$coefficients[2]))
  }else if(is(x, "Milicka_4")){
    stop("unimplemented")
  }else if(is(x, "Milicka_8")){
    stop("unimplemented")
  }else{
    stop(paste("Unknown fitted method for an object of class menzerath: ", class(x)))
  }
}

#' Fit a menzerath object
#'
#' @param object
#'
#' @param method string Method to perform the fitting, could be one of MAL, simplified_1, simplified_2, Milicka_1, Milicka_2, Milicka_4 or Milicka_8
#' @param ...
#'
#' @export
fit.menzerath <- function(object, method="MAL",...){
  result <- switch(method,
         "MAL" = lm(log(object$y) ~ log(object$x) + object$x, as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...),
         "simplified_1" = lm(log(object$y) ~ object$x, as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...),
         "simplified_2" = lm(log(object$y) ~ log(object$x), as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...),
         "Milicka_1" = lm(log(object$y) ~ log(object$x) + object$x, as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...),
         "Milicka_2" = lm(log(object$y) ~ log(object$x), as.data.frame(x=object$x, y = object$y, stringsAsFactors=FALSE), ...),
         "Milicka_4" = stop("unimplemented"),
         "Milicka_8" = stop("unimplemented"),
         stop(paste("Unknown method: ", method))
  )
  class(result) <- c(method, class(result))
  result
}

#' @export
predict.menzerath <- function(object, method="MAL", ...){
  predict(fit.menzerath(object, method), interval = "confidence", ...)
}


#' @export
print.menzerath <- function(x, ...){
  glue::glue('Observations: {length(x$x)}\n',
       'y: {paste(head(x$y), collapse=",")}...\n',
       'x: {paste(head(x$x), collapse=",")}...')
}

#' @export
plot.menzerath <- function(x, fit = NULL, method="MAL", ...){
  p <- (ggplot2::ggplot(data = x, ggplot2::aes(x=log(x), y=log(y))) +
          ggplot2::geom_point(...))
  if(is.null(fit)){
    # no prediction plot raw data
    p
  }else if(isTRUE(fit)){
    # fit and then plot
    predict_fit <- predict.menzerath(x, method)
    p + ggplot2::geom_ribbon(ggplot2::aes(ymin=predict_fit[,"lwr"], ymax=predict_fit[,"upr"]), alpha=0.1, fill="blue") +
      ggplot2::geom_line(ggplot2::aes(y=predict_fit[,"fit"]))
    p + ggplot2::geom_ribbon(ggplot2::aes(ymin=predict_fit[,"lwr"], ymax=predict_fit[,"upr"]), alpha=0.1, fill="blue") +
      ggplot2::geom_line(ggplot2::aes(y=predict_fit[,"fit"]))
  }else{
    p
  }
}


#' A class to describe and plot data following the Menzerath-Altman law
#'
#' @param x Average size of a construct (L_n) measured in units of its direct constituents
#' @param y Size of the constituent (L_{n-1})measured in its direct subconstituents
#'
#' @export
menzerath <- function(tb=tibble(), x = "x", y = "y"){
  if(!tibble::is_tibble(tb)){
    if(is.data.frame(tb)){
      tb <- tibble::as_tibble(tb)
    }else{
      stop("Constructor expects a tibble")
    }
  }
  m <- tb[c(x, y)]
  names(m) <- c("x","y")
  structure(m,
            x_name = x,
            y_name = y,
            class = c("menzerath", class(m)))
}

#' @export
nobs.menzerath <- function(object, ...){
  length(object$x)
}
