#' List of Statictics Available on outreg
#' @description Returns all available statistics on \code{\link{outreg}}.
#' Statistics names can be used for customizing the outputs, e.g.,
#' to choose stats to display or to choose stats to put starts.
#' @return a data.frame that matches stat name and display name
#' @export
#' @examples
#' outreg_stat_list()
outreg_stat_list <- function()
{
  data.frame(display_name = unname(unlist(.display_names)),
             stats = names(.display_names), stringsAsFactors = FALSE)
}


