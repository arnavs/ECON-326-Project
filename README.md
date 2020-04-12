# ECON-326-Project

Final project for ECON 326.

We study Canadian and American coronavirus data to test two hypotheses: 

1. The `R_0` for Canada falls within the interval [2.06-2.52]. (This number comes from a Zhang et al analysis on the Diamond Princess outbreak.)

2. Canada "responded better" to the pandemic than the US, since the WHO declared a pandemic. (We quantify this by looking at the reduction in `R_0` over the two regimes.)

For (1), we use a simple linear autoregression `x_{t+5} = R_0 x_t + e`, and examine it afterwords for serial correlation effects (since, e.g., the datapoint `(x_0, x_5)` and the point `(x_5, x_10)` are correlated through their shared dependence on `x_5`). 

For (2), we test a hypothesis on the quantity `D_canada - D_US`, where `D_X` is the difference in `R_0` values for the pre- and post-pandemic regimes for country X. 

The data itself is a transformed version of the JHU COVID tracker, frozen April 6th. See the data folder for more info. 

My collaborators on this project (alphabetically) were Bryn Griffiths, Raven Kirkwood, and Aleena Sharma. 
