include("../src/sir.jl")
using PyPlot
K = 50
Np = 2500
σ_o = 0.1
σ_d = 0.0
Δ = 5
Nth = 500
obsfun = obs1

x_trj, w_trj, y, x_true = assimilate(K, Np, 
							σ_o, σ_d,
							Δ, Nth, 
							obsfun)
x_trj = permutedims(x_trj,[3,2,1])
trj_len = K*Δ
y = permutedims(y,[2,1])
w_trj = permutedims(w_trj,[2,1])
x_true = permutedims(x_true,[2,1])

function plot_trj()
	#n_t = 10
	#trj_len = size(x_true)[1] - n_t + 1
	time_arr = LinRange(0, trj_len -1, trj_len)
	time_arr = dt*time_arr
	
	for i = 1:d
		fig, ax = subplots()
		ax.grid(true)
		ax.plot(time_arr, x_trj[:,:,i],"b",lw=0.9) 
		ax.plot(time_arr, x_trj[:,end,i],"b",lw=0.9,label="\$ x^{($i)}\$ orbit of particle") 
		if i==d
		    ax.plot(time_arr[1:Δ:end], y[:,1],"k",lw=3.0,label="Observed \$ x^{($i)}\$")
		end
		ax.legend(fontsize=28)
		ax.xaxis.set_tick_params(labelsize=28)
		ax.yaxis.set_tick_params(labelsize=28)
		ax.set_xlabel("Time",fontsize=28)
		ax.set_title("# particles = $(Np), partial observation", fontsize=28)
	end
end
function plot_rmse()
    filter_mean = reshape(sum(x_trj,dims=2)/Np, trj_len, d) 
    norm2(x,dim) = sum(x -> x^2, x, dims=dim)
    rmse = norm2(x_true .- filter_mean, 2) 
	rmse .= sqrt.(rmse)/d
	time_arr = LinRange(0, trj_len -1, trj_len)
	time_arr = dt*time_arr
	fig, ax = subplots()
	ax.grid(true)
	ax.plot(time_arr, rmse,"r",lw=3.0,label="RMSE")	
	ax.legend(fontsize=28)
	ax.xaxis.set_tick_params(labelsize=28)
	ax.yaxis.set_tick_params(labelsize=28)
	ax.set_xlabel("Time",fontsize=28)
	ax.set_title("# particles = $(Np), partial observation", fontsize=28)
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



