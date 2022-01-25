using PyPlot
using JLD
function plot_rmse_vs_Np()
    X = load("../data/mean_rmse_vs_Np_full.jld")
    Np = X["Np"]
	mean_rmse = X["mean_rmse"]
	fig, ax = subplots()
	ax.grid(true)
	ax.plot(Np, mean_rmse, "bo--",lw=1.0,ms=20,label="RMSE") 
	ax.legend(fontsize=28)
	ax.set_xlabel("# of particles", fontsize=28)
	ax.xaxis.set_tick_params(labelsize=28)
	ax.yaxis.set_tick_params(labelsize=28)
end

