// Simple Stan lm model: Y ~ normal(alpha + X * beta, sigma)
data {
  int<lower=0> n;
  int<lower=0> k;
  matrix[n, k] X;
  vector[n] Y;
}
parameters {
  real alpha;
  vector[k] beta;
  real<lower=0> sigma;
}
model {
  Y ~ normal(alpha + X * beta, sigma);
}
