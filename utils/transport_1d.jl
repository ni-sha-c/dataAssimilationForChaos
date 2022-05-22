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
function forecast(x, s)
	for (i, xi) = enumerate(x)
		x[i] = next(xi, s)
	end
	return x
end
function plot_srb(s)
	x = evolve_prob(s, 100000, 40) 
	hist(x, bins=100, density=true)
end
function cdf(x, xarr)
	N = size(xarr)[1]
	return 1/N*sum(xarr .<= x)
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
function sample_tn(N, m, v, a, b)
	g = 1
	k = 0
	x = zeros(N)
	while g <= N
		pt = m + v*randn()
		if a <= pt <= b
			x[g] = pt
			g = g + 1
		end
		k = k + 1
	end
	@show k
	return x
end
function plot_dist(x, t, fig, ax)
	ax.hist(x, density=true, histtype="step", 
			label=string("Time = ", string(t)))
end
function analysis(x, s, y)
	for (i, xi) = enumerate(x)
		x[i] = next(xi, s)
	end
	return x
end
function analytical_filtering(s,T,ϵ,N)
	x_true, y = generate_data(s,T,ϵ)
	x = rand(N)
	fig, ax = subplots()
	for t = 1:T
		x = forecast(x, s)	
		plot_dist(x, string("ft ", t), fig, ax)
		x = analysis(x, s, y[t])
	end
end
