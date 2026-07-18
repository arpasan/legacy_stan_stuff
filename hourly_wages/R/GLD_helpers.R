# Assumes rstan::expose_stan_functions("stan/quantile_functions.stan") has been run.
# find_chi_xi() can fail under modern Stan algebra_solver tolerances; for the
# elicitation targets used in wages.Rmd we fall back to the historically solved
# (asymmetry, steepness) pairs from the original 2020 write-up, and say so.

GLD_solver <- function(lower_quartile, median, upper_quartile, other_quantile, alpha) {
  key <- sprintf(
    "%.6f_%.6f_%.6f_%.6f_%.6f",
    lower_quartile, median, upper_quartile, other_quantile, alpha
  )
  known <- list(
    "-0.300000_-0.200000_-0.100000_0.200000_0.900000" = c(asymmetry = 0.0000000, steepness = 0.9653298),
    "-0.010000_0.000000_0.010000_0.030000_0.900000" = c(asymmetry = 0.0000000, steepness = 0.9283763),
    "0.300000_0.500000_0.650000_0.850000_0.900000" = c(asymmetry = -0.4226581, steepness = 0.9033965),
    "0.000000_0.200000_0.300000_0.500000_0.900000" = c(asymmetry = -0.6771304, steepness = 0.9722460)
  )

  used_fallback <- FALSE
  a_s <- tryCatch(
    {
      find_chi_xi(
        c(lower_quartile, median, upper_quartile, other_quantile, alpha),
        unbounded = FALSE
      )
    },
    error = function(e) {
      if (!is.null(known[[key]])) {
        used_fallback <<- TRUE
        return(unname(known[[key]]))
      }
      stop(e)
    }
  )
  if (used_fallback) {
    message(
      "GLD_solver: algebra_solver failed; using archived (asymmetry, steepness) ",
      "for this elicitation target."
    )
  }
  names(a_s) <- c("asymmetry", "steepness")
  low <- GLD_icdf(
    0, median,
    IQR = upper_quartile - lower_quartile,
    asymmetry = a_s[1], steepness = a_s[2]
  )
  if (low > -Inf) warning("solution implies a bounded lower tail at ", low)
  high <- GLD_icdf(
    1, median,
    IQR = upper_quartile - lower_quartile,
    asymmetry = a_s[1], steepness = a_s[2]
  )
  if (high < Inf) warning("solution implies a bounded upper tail at ", high)
  return(a_s)
}
