# data source is: https://pomber.github.io/covid19/timeseries.json
# data is updated thrice daily from Johns Hopkins numbers

using Pkg
pkg"activate .."
using JSON, Statistics, Plots, Dates, LsqFit, TimeSeries
data = JSON.parsefile("../data/timeseries.json");

# Aggregate statistics
function unpack_country(country)
    country_data = data[country]
    confirmed = [datum["confirmed"] for datum in country_data]
    dates = Date.([datum["date"] for datum in country_data])
    diffs = diff(confirmed)
    return country_data, confirmed, dates, diffs
end

function plot_country_aggregates(country)
    country_data, confirmed, dates, diffs = unpack_country(country)
    p = plot(dates[2:end], confirmed[2:end], lw = 3, legend = :topleft, title = "$country Aggregate", label = "Confirmed Cases")
    plot!(p, dates[2:end], diffs, lw = 3, label = "Day-to-Day Difference", xticks = dates[2:10:end])
    savefig(p, "~/Desktop/$(country)_aggregate.jpeg")
end

plot_country_aggregates("Belgium")
# plot_country_aggregates("Canada")
# plot_country_aggregates("France") # because this gives us a longer view

# Regression modeling
function fit_country(country, model, p_guess)
    country_data, confirmed, dates, diffs = unpack_country(country)
    t = 1:length(dates)
    fit = curve_fit(model, t, confirmed, p_guess) # return this
end

# Exponential growth (y(t) = Ae^(kt))
@. model(t, p) = p[1]*exp(p[2]*t)
fr_fit = fit_country("France", model, [0.5, 0.5])
@show coef(fr_fit) # ends up being y(t) = 3.64e^(0.13t)
@show stderror(fr_fit) # stderror(fr_fit) = [0.5807248710582464, 0.002419476241731794]

be_fit = fit_country("Belgium", model, [0.5, 0.5])
@show coef(be_fit) # ends up being y(t) = 0.07*e^(0.17t)
@show stderror(be_fit) # stderror(be_fit) = [0.009881708341035871, 0.0018586282749802605]

prc_fit = fit_country("China", model, [0.5, 0.5])
@show coef(prc_fit) # ends up being y(t) = 30700e^0.017t... so, apparently, an order of magnitude better than Belgium and France? seems dubious
@show stderror(prc_fit) # stderror(prc_fit) = [3123.3555378369188, 0.0020020903719526564]

# Logistic modeling
# The logistic growth equation is (Carrying Capacity)/(1 + e^(=growth rate*(t - t_peak)))
# Let's try filling in the gaps with stuff we know
L = 0.7*11.4*1e6 # millions
be_rate = 0.17 # from above
@. model(t, p) = L/(1 + exp(-be_rate*(t - p[1])))
be_data, be_conf, be_dates, diffs = unpack_country("Belgium")
t = 1:length(be_dates)
be_logistic_fit = curve_fit(model, t, be_conf, [80.])

@show coef(be_logistic_fit) # 107.08398211493504
@show stderror(be_logistic_fit) # stderror(be_logistic_fit) = [0.03196080987817913]

# Plot regression
p = coef(be_logistic_fit)[1]
restricted_data = model.(1:length(be_dates), Ref(p))
pl = plot(be_dates, restricted_data, lw = 3, label = "Model", title = "Belgium So Far", legend = :topleft)
plot!(be_dates, be_conf, lw = 3, label = "Data", xticks = be_dates[1:10:end])
savefig(pl, "~/Desktop/Belgium_restricted.jpeg")

# Belgium Overall
full_data = model.(1:200, Ref(p))
dates = collect(range(be_dates[1], step = Day(1), length = 200))
pl = plot(dates, full_data, lw = 3, label = "Model", legend = :topleft, title = "Belgium Model Full Timescale", xticks = dates[1:50:end])
peak = dates[1] + Day(floor(p))
vline!(pl, [peak], label = "$peak", lw = 3)
savefig(pl, "~/Desktop/Belgium_model.jpeg")
