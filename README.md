# ECON-326-Project

Final project for ECON 326. My collaborators on this project (alphabetically) were Bryn Griffiths, Raven Kirkwood, and Aleena Sharma. 


* [**Main Analysis Notebook**](Julia/Analysis.ipynb)

* [**Exploratory Data Analysis Notebook**](Julia/EDA.ipynb)


## Overview

We study Canadian and American coronavirus data to test two hypotheses: 

1. The `R_0` for Canada falls within the interval [2.06-2.52]. (This number comes from a Zhang et al analysis on the Diamond Princess outbreak.)

2. Canada "responded better" to the pandemic than the US, since the WHO declared a pandemic. (We quantify this by looking at the reduction in `R_0` over the two regimes.)

For (1), we use a simple linear autoregression `x_{t+5} = R_0 x_t + e`, and examine it afterwords for serial correlation effects (since, e.g., the datapoint `(x_0, x_5)` and the point `(x_5, x_10)` are correlated through their shared dependence on `x_5`). 

For (2), we test a hypothesis on the quantity `D_canada - D_US`, where `D_X` is the difference in `R_0` values for the pre- and post-pandemic regimes for country X. 

## Data

The data itself is a transformed version of the JHU COVID tracker, frozen April 6th. 

The source repo is available [here](https://github.com/pomber/covid19) (commit `c8d69b5`). It's a time-series (JSON format) of relevant information by country and day. For ex:

```
"Thailand": [
  {
    "date": "2020-1-22",
    "confirmed": 2,
    "deaths": 0,
    "recovered": 0
  },
  {
    "date": "2020-1-23",
    "confirmed": 3,
    "deaths": 0,
    "recovered": 0
  },
  ...
```

Data is cumulative, and is updated thrice daily from the "official" JHU tallies [here](https://github.com/CSSEGISandData/COVID-19).
