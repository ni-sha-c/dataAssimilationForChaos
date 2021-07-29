include("../src/sir.jl")
using PyPlot
K = 500
Np = 1000
x_trj, w_trj, x_true = assimilate(K, Np)
x_trj = permutedims(x_trj,[3,2,1])
x_true = permutedims(x_true,[2,1])
w_trj = permutedims(w_trj,[2,1])

function plot_trj()
	n_t = 10
	trj_len = size(x_true)[1] - n_t + 1
	time_arr = LinRange(0, trj_len -1, trj_len)
	time_arr = dt*time_arr

	for i = 1:d
		fig, ax = subplots()
		ax.grid(true)
		ax.plot(time_arr, x_trj[n_t:end,:,i],"b",lw=0.9) 
		ax.plot(time_arr, x_trj[n_t:end,end,i],"b",lw=0.9,label="\$ x^{($i)}\$ orbit of particle") 
		ax.plot(time_arr, x_true[n_t:end,i],"k",lw=3.0,label="Observed \$ x^{($i)}\$")
		ax.legend(fontsize=28)
		ax.xaxis.set_tick_params(labelsize=28)
		ax.yaxis.set_tick_params(labelsize=28)
		ax.set_xlabel("Time",fontsize=28)
		ax.set_title("# particles = $(Np)", fontsize=28)
	end
end
function plot_weight_stats()
	fig, ax = subplots()
	ax.grid(true)
	ax.plot(w_trj,"b",lw=0.2) 
	ax.plot(w_trj[:,end],"b",lw=1.0,label="particle weight orbit") 
	ax.legend(fontsize=28)
	ax.xaxis.set_tick_params(labelsize=28)
	ax.yaxis.set_tick_params(labelsize=28)
end



