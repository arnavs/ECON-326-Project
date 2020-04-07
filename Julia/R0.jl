#
using Pkg
pkg"activate .."
using JSON, Statistics, Plots, Dates, LsqFit, TimeSeries
using StatsModels, GLM, 
data = JSON.parsefile("../data/covid_data.json");
