The dataset we used is available [here](https://github.coom/pomber/covid19) (commit `c8d69b5`). It's a time-series (JSON format) of relevant information by country and day. For ex:

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
