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
	ax.plot(x[1,:], x[2,:], "bo", ms=20, label="RMSE") 
    ax.legend(fontsize=28)
	ax.set_xlabel("x^{(1)}", fontsize=28)
	ax.set_xlabel("x^{(2)}", fontsize=28)
    ax.xaxis.set_tick_params(labelsize=28)
    ax.yaxis.set_tick_params(labelsize=28)
end
function plot_sample_orbits(T, Δ)
	v = [1.0, 0.0]
	ϵ = 0.1
	y = -1.0 .+ 2.0*rand(T)
	x = rand(d, N)
	for t = 1:T
		plot_pts(x)
		for t1 = 1:Δ
			for k = 1:N
				x[:,k] = next(x[:,k],0)
			end
		end
	end
end

