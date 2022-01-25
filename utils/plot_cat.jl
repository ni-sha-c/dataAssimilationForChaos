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
function plot_pts(x, xtrue, str=" ")
	fig, ax = subplots()
    ax.grid(true)
	ax.plot(x[1,:], x[2,:], "bo", ms=10, label=str) 
	ax.plot(xtrue[1], xtrue[2], "r*", ms=20, label="truth") 
    ax.legend(fontsize=32)
	ax.set_xlabel(L"x^{(1)}", fontsize=32)
	ax.set_ylabel(L"x^{(2)}", fontsize=32)
    ax.xaxis.set_tick_params(labelsize=32)
    ax.yaxis.set_tick_params(labelsize=32)
	ax.set_xlim([0,1])
	ax.set_ylim([0,1])

end
function plot_sample_orbits(N, T, Δ)
	v = [1.0, 0.0]
	ϵ = 0.1
	xtrue = rand(d)
	x = rand(d, N)
	for t = 1:T
		plot_pts(x, xtrue, string("t = ", t*Δ, ", forecast"))
		r = -1.0 + 2*rand()
		y = dot(v, xtrue) + ϵ*r
		x = select_pts(v, ϵ, y, N)
		plot_pts(x, xtrue, string("t = ", t*Δ, ", analysis"))
		for t1 = 1:Δ
			xtrue = next(xtrue, 0)
			for k = 1:N
				x[:,k] = next(x[:,k],0)
			end
		end
	end
end

