# Assumes rstan::expose_stan_functions("stan/quantile_functions.stan") has been run.
# find_chi_xi() can fail under modern Stan algebra_solver tolerances; fall back to
# a near-symmetric GLD when the elicitation target has no archived solution.

GLD_solver <- function(lower_quartile, median, upper_quartile, other_quantile, alpha) {
  a_s <- tryCatch(
    find_chi_xi(
      c(lower_quartile, median, upper_quartile, other_quantile, alpha),
      unbounded = FALSE
    ),
    error = function(e) {
      message(
        "GLD_solver: algebra_solver failed for this elicitation target; ",
        "using near-symmetric (asymmetry=0, steepness=0.95)."
      )
      c(0, 0.95)
    }
  )
  names(a_s) <- c("asymmetry", "steepness")
  a_s
}
