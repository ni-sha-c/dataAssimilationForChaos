include("../examples/sawtooth.jl")
using PyPlot
function evolve_prob(s, N, T)
	x = rand(N)
	for t = 1:T
		for (i, xi) = enumerate(x)
			x[i] = next(xi, s)
		end
	end
	return x
end
function plot_srb(s)
	x = evolve_prob(s, 100000, 40) 
	hist(x, bins=100, density=true)
end
function generate_data(s,T,ϵ)
	x = rand()
	runup = 300
	for t = 1:runup
		x = next(x,s)
	end
	x_t = zeros(T)
	y_t = zeros(T)
	x_t[1] = x
	y_t[1] = x + ϵ*randn()
	for t = 2:T
		x_t[t] = next(x_t[t-1],s)
		y_t[t] = x_t[t] + ϵ*randn()
	end
	return x_t, y_t
end
