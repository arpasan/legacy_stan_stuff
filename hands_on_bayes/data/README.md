# Election / ACS county extract

`election_counties.csv` is a slim public extract used by `stan_lm_intro.Rmd`:

- Outcome: `gop_support_change` — percentage-point change in GOP support, 2012 → 2016
- Predictors: ACS-style county covariates (`pop_change`, `age_65_plus`, `black`, `hispanic`, `hs_grad`, `undergrad`, `homeownership_rate`, `median_home_value`, `median_income`, `poverty_rate`)

Rows with any missing outcome or predictor are dropped (3,111 complete counties).

Source materials (teaching examples):

- Earvin Balderama’s former Loyola “MLR in Stan” notes (`webpages.math.luc.edu/~ebalderama/bayes_resources/code/mlr_stan.html`) — that page is no longer online; the Stan teaching pattern is reflected in `stan/mlr.stan`.
- [Brian Reich — Election data notes](https://www4.stat.ncsu.edu/~bjreich/BSMdata/Election.html)

`election_2008_2016.Rdata` is the original multi-object teaching dump kept for provenance; the notebook reads the CSV.
