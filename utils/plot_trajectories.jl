include("../src/sir.jl")
using PyPlot
x_trj, w_trj, x_true = assimilate(K, Np)
x_trj = permutedims(x_trj,[3,2,1])
x_true = permutedims(x_true,[2,1])

function plot_trj()
	n_t = 10
	for i = 1:d
		fig, ax = subplots()
		ax.grid(true)
		ax.plot(x_trj[n_t:end,:,i],"b",lw=0.2) 
		ax.plot(x_true[n_t:end,i],"k",lw=3.0,label="Observed \$ x^{($i)}\$")
		ax.legend(fontsize=28)
		ax.xaxis.set_tick_params(labelsize=28)
		ax.yaxis.set_tick_params(labelsize=28)
	end
end




