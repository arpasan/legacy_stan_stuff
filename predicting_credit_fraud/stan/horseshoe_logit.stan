
data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K] X;
  array[N] int<lower=0, upper=1> y;
  int<lower=1> N_new;
  matrix[N_new, K] X_new;
}
parameters {
  real intercept;
  vector[K] z;
  vector<lower=0>[K] lambda;
  real<lower=0> tau;
}
transformed parameters {
  vector[K] beta = z .* lambda * tau;
}
model {
  intercept ~ normal(0, 2);
  z ~ std_normal();
  lambda ~ student_t(1, 0, 1); // half-Cauchy via <lower=0>
  tau ~ student_t(1, 0, 1);
  y ~ bernoulli_logit(intercept + X * beta);
}
generated quantities {
  vector[N_new] p_new = inv_logit(intercept + X_new * beta);
}
