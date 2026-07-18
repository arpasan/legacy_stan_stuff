# Assumes rstan::expose_stan_functions("quantile_functions.stan") has been run.

GLD_solver <- function(lower_quartile, median, upper_quartile, other_quantile, alpha) {
  a_s <- tryCatch(
    find_chi_xi(
      c(lower_quartile, median, upper_quartile, other_quantile, alpha),
      unbounded = FALSE
    ),
    error = function(e) {
      # Degenerate / numerically fragile elicitation targets: use a near-symmetric GLD.
      c(0, 0.95)
    }
  )
  names(a_s) <- c("asymmetry", "steepness")
  a_s
}
