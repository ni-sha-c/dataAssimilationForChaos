using PyPlot
using JLD
using LinearAlgebra
include("../examples/cat.jl")
# y = v1.x1 + v2.x2 + epsilon
rot_mat = reshape([q[1], -q[2], q[2], q[1]], 2, 2)
function put_pts(v, ϵ, y, N)
    npts = 0
	pts = zeros(d,N)
	clrs = zeros(N)
    while npts < N
        x = rand(d)
		a = dot(x,v)
		if a > y - ϵ && a <  y + ϵ
			npts += 1
			pts[:,npts] = x
			xprime = rot_mat*x
			clrs[npts] = floor(Int64,xprime[2]/0.1)
		end
    end
	return pts, clrs
end
function select_pts(v, ϵ, y, x, clrs)
    npts = 0
	N = size(clrs)
	a = zeros(N)
    for i = 1:N
		a = dot(x[:,i],v)
	end
	sel = (a .> y - ϵ) && (a .< y + ϵ)
    return x[sel], clrs[sel]
end

function plot_pts(x, xtrue, clrs, str=" ")
	fig, ax = subplots()
    ax.grid(true)
	N = size(x)[2]

	clrs .+= abs(minimum(clrs))
	nclrarr = maximum(clrs) 
	
	clrarr = get_cmap("tab10")
	for i = 1:N
		ax.plot(x[1,i], x[2,i], "o", color=clrarr(clrs[i]/nclrarr), 
					ms=10) 
	end

	ax.plot(xtrue[1], xtrue[2], "k*", ms=40) 
	ax.set_title(string("truth, ", str), fontsize=32)
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
	r = -1.0 + 2*rand()
	y = dot(v, xtrue) + ϵ*r
	x, clrs = put_pts(v, ϵ, y, N)
	plot_pts(x, xtrue, clrs, string("t = ", t*Δ, ", analysis"))


    n = N
	for t = 1:T
		for t1 = 1:Δ
			xtrue = next(xtrue, 0)
			n = size(x)[2]
			for k = 1:n
				x[:,k] = next(x[:,k],0)
			end
		end
        plot_pts(x, xtrue, clrs, string("t = ", t*Δ, ", forecast"))

		r = -1.0 + 2*rand()
		y = dot(v, xtrue) + ϵ*r
		x, clrs = select_pts(v, ϵ, y, x, clrs)

	end
end

