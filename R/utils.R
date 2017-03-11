#' @importFrom stats pnorm pt
#' @importFrom stats coefficients df.residual fitted.values
#' @importFrom stats model.matrix vcov AIC
NULL

#' @importFrom sandwich sandwich
NULL


#' @importFrom magrittr %>%
NULL



lazy_rbind <- function(a, b, fill = NA)
{
  if (is.null(a)) return(b)
  if (is.null(b)) return(a)

  vars <- setdiff(names(b), names(a))
  for (j in vars) a[[j]] <- fill
  vars <- setdiff(names(a), names(b))
  for (j in vars) b[[j]] <- fill

  b <- b[names(a)]
  rbind(a, b)
}
