#' @importFrom stats pnorm pt
#' @importFrom stats coefficients df.residual fitted.values
#' @importFrom stats model.matrix vcov AIC
NULL

#' @importFrom utils tail
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



make_unique <- function(x)
{
  stopifnot(is.character(x))
  while (TRUE)
  {
    flg <- duplicated(x)
    if (!any(flg)) break

    i <- which(flg)[1]
    suf <- 2
    while (TRUE)
    {
      a <- paste(x[i], suf, sep = '_')
      if (!(a %in% x)) {
        x[i] <- a
        break
      }
      suf <- suf + 1
    }
  }
  x
}



unfactor_df <- function(x)
{
  stopifnot(is.data.frame(x))
  for (j in seq_along(x))
  {
    if (is.factor(x[[j]])) x[[j]] <- as.character(x[[j]])
  }
  x
}
