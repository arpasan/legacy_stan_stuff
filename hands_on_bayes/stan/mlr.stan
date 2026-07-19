// County-level Gaussian linear regression with weakly informative priors.
// Predictors in X should be centered (and preferably scaled) before sampling.
data {
  int<lower=1> n;
  int<lower=1> k;
  matrix[n, k] X;
  vector[n] Y;
}
parameters {
  real alpha;
  vector[k] beta;
  real<lower=0> sigma;
}
model {
  alpha ~ student_t(3, 0, 10);
  beta ~ student_t(3, 0, 2.5);
  sigma ~ student_t(3, 0, 10);
  Y ~ normal(alpha + X * beta, sigma);
}
generated quantities {
  vector[n] log_lik;
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(Y[i] | alpha + X[i] * beta, sigma);
  }
}
