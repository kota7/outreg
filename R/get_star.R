#' Create the Siginicance Stars
#' @description Based on the coefficient and standard errors and
#' significance levels, return character vector of stars.
#' @param pv vector of p values
#' @param alpha vector of significance levels
#' @param ... not used
#' @return character vector
#' @keywords internal
get_star <- function(pv, alpha, ...)
{
  alpha <- unique(sort(alpha))
  star <- rep('', length(pv))
  for (a in alpha)
  {
    index <- which(pv < a)
    star[index] <- paste0(star[index], "*")
  }
  star
}
