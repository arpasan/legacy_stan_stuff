# CDSS Hackathon 2020 data

- `google_mobility_swe_den.csv` — Google Community Mobility Reports extract for Sweden and Denmark (region-day; 2020-02-15 to 2020-09-11).
- `covid19_ecdc.csv` — ECDC geographic distribution of COVID-19 cases (country-day), including `pop_data_2019`.

The notebook aggregates mobility to **country-day** means before joining COVID outcomes, so each date contributes one row per country in the DiD models.
