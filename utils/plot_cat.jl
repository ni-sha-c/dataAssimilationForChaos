using PyPlot
using JLD
using LinearAlgebra
include("../examples/cat.jl")
# y = v1.x1 + v2.x2 + epsilon
function select_pts(v, ϵ, y, N)
    npts = 0
	pts = zeros(d,N)
    while npts < N
        x = rand(d)
		a = dot(x,v)
		if a > y - ϵ && a <  y + ϵ
			npts += 1
			pts[:,npts] = x
		end
    end
	return pts
end
function plot_pts(x)
	 fig, ax = subplots()
    ax.grid(true)
    ax.plot(Np, mean_rmse, "bo--",lw=1.0,ms=20,label="RMSE") 
    ax.legend(fontsize=28)
    ax.set_xlabel("# of particles", fontsize=28)
    ax.xaxis.set_tick_params(labelsize=28)
    ax.yaxis.set_tick_params(labelsize=28)


end
function plot_sample_orbits(x)
    X = load("../data/mean_rmse_vs_Np_full.jld")
    Np = X["Np"]
    mean_rmse = X["mean_rmse"]
   end

