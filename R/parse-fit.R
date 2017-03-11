make_coef_part <- function(fit, ...) UseMethod("make_coef_part")


make_stat_part <- function(fit, ...) UseMethod("make_stat_part")


make_opt_part  <- function(fit, ...) UseMethod("make_opt_part")
make_opt_part.default <- function(fit, ...) NULL


